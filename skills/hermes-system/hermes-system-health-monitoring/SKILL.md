---
name: hermes-system-health-monitoring
description: Hermes Agent 系统链路心跳监控 + Cron 部署。用于监控 Hermes Gateway、OpenClaw MCP、OpenClaw Gateway 进程是否存活，异常时推送飞书 DM，日常静默。
triggers:
  - 部署 Hermes 健康监控
  - Hermes Cron 链路告警
  - 系统进程存活检测
---

# Hermes 系统链路监控部署

## 核心脚本

路径：`~/.hermes/scripts/health_check.sh`

```bash
#!/bin/bash
LOG=~/.hermes/logs/health.log
mkdir -p ~/.hermes/logs
echo "[$(date '+%Y-%m-%d %H:%M:%S')] --- Heartbeat Check ---" >> $LOG

# 1. Hermes Agent 进程检测（当前会话 CLI）
if ps aux | grep -v grep | grep -q "hermes"; then
  echo "HERMES=OK" >> $LOG
else
  echo "HERMES=DEAD" >> $LOG
fi

# 2. OpenClaw MCP Server 进程检测
if ps aux | grep -v grep | grep -q "openclaw-node"; then
  echo "OPENCLAW_MCP=OK" >> $LOG
else
  echo "OPENCLAW_MCP=DEAD" >> $LOG
fi

# 3. OpenClaw Gateway 进程检测
if ps aux | grep -v grep | grep -q "openclaw-gateway"; then
  echo "OPENCLAW_GW=OK" >> $LOG
else
  echo "OPENCLAW_GW=DEAD" >> $LOG
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') ALIVE_CHECK=DONE" >> $LOG
```

## Cron 创建（使用 cronjob 工具）

**不要用 `hermes cron create`** — Hermes CLI 的 cron 子命令参数格式不同且需要交互。

使用 `cronjob` 工具创建定时任务（参数如下），部署后 cron 会自动执行：

- **action**: `create`
- **name**: `ai-system-health`
- **schedule**: `every 90m`（推荐值，可按需调整）
- **repeat**: `0`（表示 forever）
- **deliver**: `feishu:oc_1f4f26112f2f7457d5052e5e07036fd5`（心跳投递目标，日常静默，DEAD 时才推送）
- **prompt**: `执行 ~/.hermes/scripts/health_check.sh，然后读取 ~/.hermes/logs/health.log 最新输出。如果包含 DEAD，使用 send_message 发飞书给 oc_8d0a43e1451303f735f9c1dc696afee7，格式：「🔴 AI系统告警\n检测到进程异常：[列具问题项]\n请检查系统状态」。如果全是 OK 则静默。`

Cron 创建后会自动调度，下次执行时间由系统返回。

## 部署验证

```bash
# 1. 创建目录
mkdir -p ~/.hermes/logs ~/.hermes/scripts

# 2. 写入脚本并授权
chmod +x ~/.hermes/scripts/health_check.sh

# 3. 手动执行测试
~/.hermes/scripts/health_check.sh
tail ~/.hermes/logs/health.log

# 4. 确认 cron 存在
cronjob --action list
```

## 监控项

| 进程 | 检测内容 |
|------|---------|
| Hermes Agent | `hermes` 进程（当前 CLI 会话） |
| OpenClaw MCP Server | `openclaw-node` 进程 |
| OpenClaw Gateway | `openclaw-gateway` 进程 |

## 关键坑

### macOS 没有 timeout 命令
- 用 bash 背景进程 + sleep + kill 实现超时：
  ```bash
  { long_running_cmd > /tmp/out.txt 2>&1 & } &
  PID=$!
  sleep 5
  if ps -p $PID > /dev/null 2>&1; then
    kill -9 $PID 2>/dev/null; echo "FAIL"
  fi
  ```
- 或者用 `gtimeout`（需 brew install coreutils）

### pgrep -f 会误匹配 grep 自身
`pgrep -f "hermes gateway"` 会同时匹配包含该字符串的 grep 命令本身，导致误报 DEAD。
- 解决：必须用 `ps aux | grep -v grep | grep -q "pattern"`

### openclaw mcp ping 不存在
`openclaw mcp ping` 返回 `error: unknown command 'ping'`，且命令会挂起。
- 原因：`openclaw mcp` 是 MCP server 管理工具，不是 MCP 客户端
- 解决：MCP 通道通过进程级检测（检测 `openclaw-node` 进程）

### croniter 必须装在 Hermes 自己的 Python 环境
- Hermes 用 Homebrew Python 3.11：`/opt/homebrew/opt/python@3.11/bin/pip3.11 install croniter`
- 系统 pip3 和 Hermes 用的不是同一个 Python

### 飞书 deliver 格式
- `feishu:oc_xxxxxxxxxxxx` — 注意是 `oc_` 前缀的 chat_id，不是 open_id

### Hermes 没有独立 Gateway 进程
- 架构说明：Hermes Gateway 不是独立进程，而是集成在 `hermes` CLI 中的能力
- 实际监控的是：当前 Hermes CLI 会话（`hermes` 进程）、OpenClaw Gateway（`openclaw-gateway`）、OpenClaw MCP（`openclaw-node`）

### 架构更新（2026-05-13 修正）
**`hermes gateway run` 是独立进程，不是 in-process**
- 正确启动：`cd ~/.hermes/hermes-agent && nohup ./venv/bin/hermes gateway run > logs/gateway.log 2>&1 &`
- 进程名：`Python ./venv/bin/hermes gateway run`
- `python -m gateway.run` 会被 `hermes gateway restart` 杀掉（两个进程冲突），不要用
- 飞书连接通过 WebSocket（wss://msg-frontier.feishu.cn），无 HTTP health 端点，验证存活靠日志 `[Feishu] Connected in websocket mode`

### 进程检测命令
```bash
# Hermes Gateway（独立进程）
ps aux | grep -v grep | grep -q "hermes gateway run" && echo "HERMES_GW=OK" || echo "HERMES_GW=DEAD"

# OpenClaw Gateway
ps aux | grep -v grep | grep -q "openclaw-gateway" && echo "OPENCLAW_GW=OK" || echo "OPENCLAW_GW=DEAD"

# Hermes CLI（当前会话）
ps aux | grep -v grep | grep -q "hermes --resume\|hermes run" && echo "HERMES_CLI=OK" || echo "HERMES_CLI=DEAD"
```

### 快速重启 Gateway（故障恢复）
```bash
cd ~/.hermes/hermes-agent
# 杀旧进程
pkill -f "hermes gateway run" 2>/dev/null
sleep 2
# 启动
nohup ./venv/bin/hermes gateway run > logs/gateway.log 2>&1 &
sleep 5
tail logs/gateway.log | grep -E "Connected|DEAD|ERROR"
```

### Gateway 日志关键标识
| 日志内容 | 含义 |
|---------|------|
| `[Feishu] Connected in websocket mode` | 飞书连接成功 |
| `Connecting to feishu...` | 启动中 |
| `Gateway already running (PID N)` | 已有实例在跑 |
| `SIGTERM/SIGINT — initiating shutdown` | 被关闭 |
| `Killed: 9` | 被 SIGKILL 强制杀死（通常是进程冲突）|

## 监控与 Cron 降级联动（OpenClaw → Hermes）

当 Hermes 接管 OpenClaw 的 cron 任务时，必须同步禁用原 OpenClaw cron：
1. 修改 `~/.openclaw/cron/jobs.json` 中对应 job 的 `enabled: false`
2. 同步在 description 中标注迁移目标：`已迁移到 Hermes (cron-job-name)`
3. payload message 改为 `[DISABLED] 此任务已迁移到 Hermes cron`
4. delivery.mode 改为 `none`（不再推送）
