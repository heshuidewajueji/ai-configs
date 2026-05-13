#!/bin/bash
# sync-skills.sh — 同步Skills到本地Hermes

set -e

SKILLS_DIR="$HOME/.hermes/skills/ai-configs"
TARGET_DIR="$HOME/.hermes/skills"

echo "🔄 同步Skills到本地..."
echo "源: $(pwd)/skills"
echo "目标: $TARGET_DIR"

# 创建目标目录
mkdir -p "$TARGET_DIR"

# 同步skills
rsync -av --include='skills/' --include='skills/*/' --include='skills/*/SKILL.md' --exclude='*' . "$TARGET_DIR/" 2>/dev/null || \
cp -r skills/* "$TARGET_DIR/"

echo "✅ 同步完成！"
echo ""
echo "Skills已安装到: $TARGET_DIR"
