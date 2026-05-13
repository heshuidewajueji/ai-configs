---
name: vault-directory-deep-scan
description: >-
  当用户说「整理某个目录」「深度扫描某个目录」「全面梳理某目录」时触发。
  执行 Obsidian vault 子目录的全面深度扫描和结构整理。
  包含：识别孤立文件/归档文件、补充/修复 frontmatter、创建综合框架文档、创建 CLAUDE.md 入口。
version: 1.0.0
author: King
license: private
---

# Vault 目录深度扫描与整理

> 对 vault 子目录进行系统性深度整理的标准化流程

## 触发条件

用户说：
- "整理某个目录"
- "深度扫描某个目录"
- "全面梳理某目录"
- "检查下我的知识库结构"

## 整理流程

### Step 1：目录现状扫描

```bash
# 列出目录结构
ls -la "/path/to/vault/目标目录/"

# 列出所有子目录
find "/path/to/vault/目标目录/" -type d -maxdepth 2

# 查看各文件 frontmatter（检查是否缺损）
for f in "/path/to/vault/目标目录/"*.md; do head -5 "$f"; echo "---"; done

# 识别孤立/不相关文件（与目录主题无关的文件）
# 识别空目录
# 识别重复文件（标题/内容高度相似）
```

### Step 2：问题分类

将问题归为以下类别：

| 问题类型 | 识别方式 | 处理策略 |
|---------|---------|---------|
| **孤立文件** | 文件内容与目录主题无关 | 归档或移动 |
| **缺 frontmatter** | 文件头部无 YAML frontmatter | 补充标准 frontmatter |
| **内容过时** | 文件内容已过时或被替代 | 归档 |
| **空目录** | 目录为空或仅有 .DS_Store | 删除或归档 |
| **结构不清** | 目录文件超过 15 个无分类 | 建议分子目录 |

### Step 3：执行整理

**归档孤立文件**（需用户确认）：
```bash
mv "/path/to/file.md" "/path/to/vault/90-归档/"
```

**补充 frontmatter**（直接执行）：
```markdown
---
title: 文件标题
created: YYYY-MM-DD
updated: YYYY-MM-DD
domain: 领域
type: 类型
status: active
tags: [标签列表]
summary: 摘要（≤50字）
---
```

### Step 4：综合框架文档（核心产出）

当目录有 5+ 文件且内容丰富时，创建综合框架文档：

```markdown
# {目录名}（YYYY-MM-DD整理版）

## 一、整体架构
## 二、核心文件说明
## 三、目录结构
## 四、运行机制（如适用）
## 五、相关文件
```

### Step 5：CLAUDE.md 入口（可选）

当目录有 3+ 个核心文件时，创建 `CLAUDE.md` 作为 AI Agent 入口：

```markdown
# {目录名} — AI Agent 工作手册

> 本文件是 AI Agent 进入本目录的入口说明。

## 核心文件速查
| 文件 | 作用 |
|------|------|

## 目录结构
```

### Step 6：更新知识地图

如果目录有 `INDEX.md` 或 `知识地图.md`，更新其内容。

---

## 判断标准

| 条件 | 动作 |
|------|------|
| 文件与目录主题无关 | → 归档 |
| 文件缺 frontmatter | → 补充 |
| 文件内容已过时 | → 归档 |
| 目录文件 > 15 个 | → 建议分子目录 |
| 目录有 5+ 核心文件但无综合文档 | → 创建综合文档 |
| 目录有 3+ 核心文件但无 CLAUDE.md | → 创建 CLAUDE.md |

## 输出物清单

1. 目录现状报告（问题列表 + 建议）
2. 已归档文件列表
3. 已修复 frontmatter 文件列表
4. 新创建的框架文档（如有）
5. 新创建的 CLAUDE.md（如有）

## 注意事项

- **删除/修改类操作** → 先报告用户，得到确认后再执行
- **读查询类命令**（ls, du, head, grep）→ 直接执行
- **vault 升华层（91-升华层/）和收件箱（01-收件箱/）** → 不做大规模整理
- 归档目录统一使用 `90-归档/`

## 存储路径

vault 目标目录 + 对话中持续记录进度
