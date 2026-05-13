# AI Configs

AI助手配置与Skills统一管理仓库。

## 📂 目录结构

```
ai-configs/
├── 🤖 agents/              # AI助手配置
│   ├── hermes/             # Hermes Agent
│   │   ├── config.yaml     # 主配置
│   │   ├── SOUL.md        # Persona定义
│   │   └── personalities/  # 个性预设
│   └── opencode/           # OpenCode配置
│
├── 🧠 skills/              # Skills集合
│   ├── persona-distill/    # 人物蒸馏框架
│   ├── dogfood/           # Web QA测试
│   ├── skill-registry-management/  # 规范化管理
│   └── king-ai-skills/    # 原有Skills
│       ├── obsidian-markdown/
│       ├── obsidian-cli/
│       ├── obsidian-bases/
│       ├── json-canvas/
│       ├── tutor/
│       ├── defuddle/
│       ├── skill-manage/
│       └── tbox-prd-skill/
│
├── 📝 prompts/            # 提示词模板
│   ├── system-prompts/
│   └── personas/          # 角色预设
│
├── 🔧 scripts/            # 管理脚本
│   ├── sync-skills.sh     # 同步Skills
│   └── validate.sh         # 验证Frontmatter
│
└── 📋 .github/workflows/  # GitHub Actions
    └── validate.yml        # 自动验证
```

## 🚀 快速安装

### 安装单个Skill

```bash
# persona-distill
npx skills add heshuidewajueji/ai-configs/skills/persona-distill

# dogfood
npx skills add heshuidewajueji/ai-configs/skills/dogfood

# king-ai-skills中的某个
npx skills add heshuidewajueji/ai-configs/skills/king-ai-skills/obsidian-markdown
```

### 克隆整个Skills集合

```bash
git clone https://github.com/heshuidewajueji/ai-configs.git ~/.hermes/skills/ai-configs
```

## 🤖 Agents配置

### Hermes Agent

```bash
# 复制配置（不含密钥）
cp agents/hermes/config.yaml ~/.hermes/config.yaml
cp agents/hermes/SOUL.md ~/.hermes/SOUL.md
```

> ⚠️ config.yaml中的API密钥已脱敏，请手动添加

## 🔧 管理脚本

```bash
# 验证所有Skills的Frontmatter
./scripts/validate.sh

# 同步Skills到本地
./scripts/sync-skills.sh
```

## 📜 License

MIT License
