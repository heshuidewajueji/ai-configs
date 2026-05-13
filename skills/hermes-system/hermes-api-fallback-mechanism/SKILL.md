---
name: hermes-api-fallback-mechanism
description: Hermes Agent API 故障转移（fallback）机制详解 — 错误分类、立即切换条件、fallback_model 配置格式
---

# Hermes API Fallback 机制详解

## 触发条件

| 错误类型 | 处理方式 | 重试？ |
|---------|---------|--------|
| 429/billing | 立即切换到 fallback provider | 不重试 |
| login_fail/1004/invalid_credentials | 立即切换到 fallback provider | 不重试 |
| 500/503/overloaded | 重试 3 次后切换 | 3次 |
| 空响应/畸形响应 | 立即切换 | 不重试 |

## 核心代码路径

### 1. 错误分类
- 文件：`~/.hermes/hermes-agent/agent/error_classifier.py`
- 函数：`_classify_by_error_code()` (行 768)
- 关键类：`ClassifiedError` (dataclass，字段：reason, should_fallback, should_rotate_credential)
- 关键枚举：`FailoverReason.auth`, `FailoverReason.rate_limit`, `FailoverReason.billing`

### 2. 立即切换逻辑（eager fallback）
- 文件：`~/.hermes/hermes-agent/run_agent.py`
- 位置：行 11663-11700（rate-limit eager fallback）+ 行 11686-11700（auth eager fallback）
- 函数：`_try_activate_fallback(reason=...)`
- 切换后：`retry_count = 0; compression_attempts = 0; continue`

### 3. 重试耗尽后切换
- 文件：`~/.hermes/hermes-agent/run_agent.py` 行 ~10539
- while 循环：`while retry_count < max_retries`
- 耗尽后调用：`_try_activate_fallback()`

### 4. 凭证池轮换
- 文件：`run_agent.py`
- 函数：`_recover_with_credential_pool()`
- 仅在 credentials pool 有多个 key 时有效

## fallback_model 配置格式

```yaml
fallback_model:
  - provider: modelscope
    model: deepseek-ai/DeepSeek-V3.2
  - provider: siliconflow
    model: Qwen/Qwen2.5-7B-Instruct
  - provider: zai
    model: glm-4-flash
```

配置路径：`~/.hermes/hermes-agent/config.yaml`（不是 `~/.hermes/config.yaml`）

## 链路顺序
```
请求 → modelscope (主)
     ↓ 401/login_fail 或 429/billing 或 空响应
     → siliconflow (备1)
     ↓ 同上
     → zai (备2)  ← 必须验证可用
```

## 验证脚本
`~/.hermes/hermes-agent/scripts/test_fallback_chain.py`
```bash
/opt/homebrew/opt/python@3.11/bin/python3.11 scripts/test_fallback_chain.py
```

## Per-provider Cooldown（2026-05-11 凌晨追加）

解决 LiteLLM Issue #22296/#26015：流式响应中收到 429 时，下一个 fallback provider 可能自己也刚被 429，不能立即试。

### 机制
`_provider_cooldowns: dict[str, float]` — 每个 provider 独立的 cooldown expiry（monotonic 时间戳）。

### 新增字段
- `_provider_cooldowns: dict` — 初始化（行 1506）、reset（行 2290）

### 修改位置
1. **行 7196**：`_try_activate_fallback()` 中，记录失败 provider 到 `_provider_cooldowns`
2. **行 7213**：选择下一个 fallback 前，检查 `cooldowns.get(fb_provider, 0) > now`，是则跳过
3. **行 7403**：`_restore_primary()` 也检查 primary 是否在 per-provider cooldown 中

### 完整保护链条
```
modelscope 429 → _provider_cooldowns['modelscope']=now+60 → siliconflow
siliconflow 429 → _provider_cooldowns['siliconflow']=now+60 → siliconflow在cooldown→跳过 → zai
zai 429 → _provider_cooldowns['zai']=now+60 → chain耗尽 → 报错
60s后恢复 → modelscope cooldown已过期但_auth_failed_providers仍有 → 不恢复
```

## auth 失败追踪机制（2026-05-11 凌晨新增）

auth 错误（401/login_fail）不同于 rate-limit：key 无效不是临时状态，60 秒后还是无效。不能回到已确认失败的 provider。

### 新增字段
- `_auth_failed_providers: set` — 记录所有返回过 auth 错误的 provider 名称（小写）

### 修改位置
1. **行 1504**：`__init__` 中初始化 `self._auth_failed_providers = set()`
2. **行 2286**：`reset_fallback_state()` 中也重置为新 set
3. **行 7184**：cooldown 条件加入 `FailoverReason.auth` — auth 错误触发 60s cooldown
4. **行 7203**：`_try_activate_fallback()` 跳过 `_auth_failed_providers` 中的 provider
5. **行 11704**：auth eager fallback 块中 `self._auth_failed_providers.add(self.provider)`
6. **行 7389**：`_restore_primary()` 检查 primary 是否在 `_auth_failed_providers` 中

### 完整保护链条
```
modelscope 返回 401
  → _auth_failed_providers.add('modelscope')
  → _rate_limited_until = now + 60s
  → _try_activate_fallback() → siliconflow

siliconflow 也返回 401
  → _auth_failed_providers.add('siliconflow')
  → _try_activate_fallback() → zai (跳过已在 set 中的)

60秒后 _restore_primary()
  → _rate_limited_until 未过期 → 不恢复，停留在 zai
  → 或 primary 在 _auth_failed_providers → 也不恢复
```

## 新增 login_fail 处理（2026-05-11）

### error_classifier.py 修改
- 位置：行 796-803
- 新增 code: `login_fail`, `invalid_credentials`, `1004`, `auth_failed`
- 映射到：`FailoverReason.auth`, `should_fallback=True`, `retryable=False`

### run_agent.py 修改
- 位置：行 11686-11700（新增 auth eager fallback 块）
- 位置：行 7184（cooldown 条件加入 auth）
- 位置：行 7203（跳过 auth 失败的 provider）
- 位置：行 7389（恢复前检查 auth 失败 set）

## 关键发现
1. config 键名必须是 `fallback_model`（不是 `fallback_providers`）
2. `_try_activate_fallback` 返回 True 才切换；返回 False 表示没有更多 fallback
3. `_fallback_index` 初始值 0；`_fallback_chain` 初始为空 list
4. `pool_may_recover` 对单 key 的 MiniMax 永远是 False
5. Hermes 用 Python 3.11：`/opt/homebrew/opt/python@3.11/bin/python3.11`
6. `_auth_failed_providers` 用 `getattr(self, "_auth_failed_providers", set())` 访问（向后兼容旧 session）

## Health Check 主动探测（未做）

### 结论：暂不实现
现有 `per-provider cooldown` + `_auth_failed_providers` 已覆盖 80% 场景。

### 已有的覆盖
| 失败类型 | 机制 |
|---------|------|
| 401/auth | `_auth_failed_providers` set + 60s cooldown |
| 429/billing | per-provider cooldown 60s |
| 503/overload | 同 429，cooldown 后跳过 |

### 剩余空白
429 恢复后（cooldown 还在）无法提前探测，必须等 60s 过期才能切回。

### 未实现原因
1. **LiteLLM 背景线程有 bug**（#8248 循环、#10114 挂起高 CPU）
2. **probe 需要适配各 provider 接口**：MiniMax/siliconflow/zai 端点不同，非 OpenAI 兼容
3. **性价比低**：60s cooldown 已足够，等一分钟比实现 probe 简单得多
4. **实现复杂度高**：需要区分各 provider 的 /models 或专用 health 端点

### 未来如果要做
参考 `web_server.py:448 _probe_gateway_health()` 的极简模式：
- 不做背景线程
- 只在 `_restore_primary()` 前做 on-demand probe
- 用已创建的 client 发一个最小请求（timeout=3s）
- 缓存结果 10s（`_provider_healthy_until`）
