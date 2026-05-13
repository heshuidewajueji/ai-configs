# AI Configs

AI助手配置与Skills统一管理仓库。模块化的AI助手配置框架，展示如何构建可复用、可维护的AI Agent配置体系。

**适用平台**：Hermes Agent / Claude Code / OpenCode / Codex

---

## 📂 目录结构

```
ai-configs/
├── README.md               # 本文件
├── agents/                 # AI Agent 核心配置
│   └── hermes/
│       ├── config.yaml     # 主配置（fallback/provider/平台）
│       └── SOUL.md         # Persona 定义
├── skills/                 # 可复用 Skills（10个）
│   ├── persona-distill/    # 人物蒸馏（心智模型→AI Skill）
│   ├── skill-registry-management/  # Skills 规范化管理
│   ├── tbox-prd-skill/     # 汽车TBOX产品需求文档
│   ├── obsidian-markdown/  # Obsidian Markdown 工具链
│   ├── obsidian-cli/       # Obsidian 命令行交互
│   ├── obsidian-bases/     # Obsidian 数据库
│   ├── json-canvas/        # JSON Canvas 可视化
│   ├── tutor/              # 学习Quiz助手
│   ├── defuddle/           # 网页内容提取
│   └── skill-manage/       # Skill 管理脚本
├── prompts/                 # 提示词模板
│   ├── system-prompts/
│   └── personas/
└── scripts/                # 自动化脚本
    ├── validate.sh         # Frontmatter 验证
    └── sync-skills.sh      # Skills 同步
```

---

## 🧠 Skills 索引

| Skill | 功能 | 适用场景 |
|-------|------|---------|
| **persona-distill** | 人物思维方式蒸馏 | 把专家思维蒸馏成AI Skill |
| **skill-registry-management** | Skills规范化管理 | 维护多个Skills仓库 |
| **tbox-prd-skill** | 汽车TBOX PRD生成 | OEM/Tier1供应商需求文档 |
| **obsidian-markdown** | Obsidian工具链 | 笔记整理、md处理 |
| **obsidian-cli** | Obsidian命令行 | CLI操作Obsidian库 |
| **obsidian-bases** | Obsidian数据库 | 结构化数据管理 |
| **json-canvas** | JSON Canvas可视化 | 知识图谱/关系图 |
| **tutor** | 学习Quiz助手 | 自测/教学 |
| **defuddle** | 网页内容提取 | 抓取净化网页 |
| **skill-manage** | Skill管理脚本 | 批量操作Skills |

---

## 🚀 快速使用

### 安装单个 Skill

```bash
# 通过 npx skills 安装
npx skills add heshuidewajueji/ai-configs/skills/persona-distill
npx skills add heshuidewajueji/ai-configs/skills/obsidian-markdown
```

### 克隆整个仓库

```bash
git clone https://github.com/heshuidewajueji/ai-configs.git
```

### 复制 Hermes Agent 配置

```bash
cp agents/hermes/config.yaml ~/.hermes/config.yaml
cp agents/hermes/SOUL.md ~/.hermes/SOUL.md
```

> ⚠️ config.yaml 中的 API 密钥已脱敏，请手动添加

---

## 🤖 Agent 配置

### Hermes Agent

配置位于 `agents/hermes/`，包含：
- `config.yaml` — fallback 链（modelscope→siliconflow→zai）+ provider 配置
- `SOUL.md` — Persona 定义

---

## 🔧 管理脚本

```bash
# 验证所有 Skills 的 Frontmatter
./scripts/validate.sh

# 同步 Skills 到本地
./scripts/sync-skills.sh
```

---

## 🏷️ Topics

ai-assistant hermes-agent prompt-engineering ai-framework automation

---

## 📜 License

MIT License

---

更多信息请访问：https://github.com/heshuidewajueji/ai-configs