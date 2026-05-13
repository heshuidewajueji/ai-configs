# AI Configs

AI助手配置与Skills统一管理仓库。模块化的AI助手配置框架，展示如何构建可复用、可维护的AI Agent配置体系。

**适用平台**：Hermes Agent / Claude Code / OpenCode / Codex

---

## 📂 目录结构

```
ai-configs/
├── README.md
├── agents/                 # AI Agent 核心配置
│   └── hermes/             #   config.yaml + SOUL.md
├── skills/                 # 可复用 Skills
│   ├── automotive-industry/    # 汽车行业 Skills
│   ├── book-distillation/      # 书籍蒸馏方法论
│   ├── engineering-methods/    # 工程方法论 Skills
│   ├── hermes-system/          # Hermes 系统文档
│   ├── obsidian-tools/         # Obsidian 工具链
│   ├── persona-distill/        # 人物蒸馏
│   ├── skill-registry-management/
│   ├── tbox-prd-skill/         # 汽车 TBOX PRD
│   └── obsidian-markdown/cli/bases/json-canvas/defuddle/tutor/
└── scripts/
```

---

## 🧠 Skills 索引

### 🚗 汽车行业（Automotive Industry）

| Skill | 功能 | 适用场景 |
|-------|------|---------|
| **automotive-8d-report** | 8D 问题报告生成 | 客户投诉/OEM 8D请求/重大质量问题 |
| **automotive-ppap-submission** | PPAP 提交指南 | 供应商提交18项 PPAP 包 |
| **automotive-ppap-supplier-audit** | PPAP 供应商审核 | 主机厂审核供应商 PPAP |

### 📚 书籍蒸馏（Book Distillation）

| Skill | 功能 | 适用场景 |
|-------|------|---------|
| **book-to-skill-distiller** | 书籍→Skill 转化 | 把方法论书籍蒸馏成可执行 Skill |
| **book-skill-verifier** | Skill 验收 | 验证 Skill 是否合格、准确、有用 |

### 🔧 工程方法论（Engineering Methods）

| Skill | 功能 | 适用场景 |
|-------|------|---------|
| **test-driven-development** | TDD 红绿重构 | 426行，含铁律+垂直切片+Tracer Bullet |
| **requesting-code-review** | 代码审查 | 279行，安全扫描+自动修复 |
| **systematic-debugging** | 系统调试 | 6阶段框架（mattpocock/diagnose 融合）|
| **subagent-handoff-protocol** | 任务交接协议 | 多Agent 协作的结构化交接 |
| **architecture-health-check** | 架构健康检查 | 深层模块/依赖方向/熵增 |
| **self-evaluation-checkpoint** | 自检检查点 | 每15步自检+Skill沉淀判断 |

### ⚙️ Hermes 系统（Hermes System）

| Skill | 功能 | 适用场景 |
|-------|------|---------|
| **hermes-api-fallback-mechanism** | Fallback 机制详解 | auth eager + per-provider cooldown |
| **hermes-feishu-gateway-setup** | 飞书接入指南 | macOS + venv + MiniMax |
| **hermes-system-health-monitoring** | 系统健康监控 | Cron 部署+飞书告警 |

### 📝 Obsidian 工具链

| Skill | 功能 |
|-------|------|
| **obsidian-markdown** | Obsidian Flavored Markdown |
| **obsidian-cli** | Obsidian 命令行交互 |
| **obsidian-bases** | Obsidian 数据库 |
| **vault-directory-deep-scan** | Vault 目录深度扫描 |

---

## 🚀 快速使用

### 安装单个 Skill

```bash
npx skills add heshuidewajueji/ai-configs/skills/automotive-industry/automotive-8d-report
npx skills add heshuidewajueji/ai-configs/skills/engineering-methods/test-driven-development
```

### 复制 Hermes 配置

```bash
cp agents/hermes/config.yaml ~/.hermes/config.yaml
cp agents/hermes/SOUL.md ~/.hermes/SOUL.md
```

> ⚠️ config.yaml 中的 API 密钥已脱敏，请手动添加

---

## 🏷️ Topics

ai-assistant hermes-agent prompt-engineering ai-framework automation automotive

---

## 📜 License

MIT License