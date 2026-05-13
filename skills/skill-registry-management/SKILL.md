---
name: skill-registry-management
description: 规范化管理GitHub上的AI Skills — 统一Frontmatter标准、版本管理、分类索引、自动同步。适用于维护多个skills仓库。
version: 1.0.0
author: heshuidewajueji
license: MIT
tags: [skill-management, github,规范化, frontmatter, version]
---

# Skill Registry Management

## 标准Frontmatter模板

```yaml
---
name: [skill-name]           # 唯一标识，英文+连字符
description: [一句话描述]   # 说明用途和触发场景
version: 1.0.0              # 语义版本
author: heshuidewajueji     # 作者
license: MIT                # 许可证
tags: [category, tag2]      # 分类标签
homepage: [repo-url]       # 所属仓库
---
```

## 必须字段

| 字段 | 说明 | 示例 |
|------|------|------|
| `name` | 唯一标识 | `obsidian-markdown` |
| `description` | 一句话说明用途 | `Obsidian Flavored Markdown语法` |
| `version` | 语义版本 | `1.0.0` |
| `author` | 作者 | `heshuidewajueji` |
| `license` | 协议 | `MIT` |
| `tags` | 分类标签数组 | `[obsidian, markdown]` |

## 可选字段

| 字段 | 说明 |
|------|------|
| `homepage` | 仓库URL |
| `related_skills` | 相关skills |
| `required_environment_variables` | 依赖环境变量 |
| `required_commands` | 依赖命令 |

## 版本号规范

格式: `MAJOR.MINOR.PATCH`

- **MAJOR**: 不兼容的重大变更
- **MINOR**: 向后兼容的功能新增
- **PATCH**: 向后兼容的问题修复

更新时:
- 添加新field → MINOR +1
- Bug修复 → PATCH +1
- 删除/重命名字段 → MAJOR +1

## 分类标签规范

### 按领域
- `obsidian` — Obsidian相关
- `product` — 产品文档
- `creative` — 创意/艺术
- `productivity` — 效率工具
- `research` — 学术研究
- `devops` — 开发运维
- `mlops` — 机器学习

### 按功能
- `web` — 网页相关
- `content-extraction` — 内容提取
- `database` — 数据库
- `markdown` — 标记语言

### 按语言/地区
- `zh` — 中文
- `en` — 英文

## 目录结构规范

```
repo/
├── README.md              # 仓库总索引（必须）
├── SKILL.md              # 单skill仓库时
└── [skill-name]/
    ├── SKILL.md          # 核心文件（必须）
    ├── references/       # 参考文档
    ├── templates/       # 模板文件
    ├── examples/        # 示例
    ├── data/            # 数据文件
    ├── assets/          # 静态资源
    └── LICENSE          # 许可证
```

## 仓库README模板

```markdown
# [仓库名]

[一句话描述]

## Skills 索引

| Skill | 功能 | 安装 |
|-------|------|------|
| [name] | [desc] | `npx skills add [user]/[repo]/[name]` |

## 安装

```bash
npx skills add [user]/[repo]/[skill-name]
```
```

## 更新检查清单

- [ ] Frontmatter完整（5个必须字段）
- [ ] Version号正确递增
- [ ] License声明
- [ ] README索引最新
- [ ] 无敏感信息泄露

## 常用GitHub API

```bash
# 查看仓库内容
curl -H "Authorization: token $TOKEN" \
  https://api.github.com/repos/[user]/[repo]/contents

# 更新仓库描述
curl -X PATCH -H "Authorization: token $TOKEN" \
  -d '{"description":"..."}' \
  https://api.github.com/repos/[user]/[repo]

# 创建新仓库
curl -X POST -H "Authorization: token $TOKEN" \
  -d '{"name":"new-skill","private":false}' \
  https://api.github.com/user/repos
```
