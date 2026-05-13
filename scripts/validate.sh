#!/bin/bash
# validate.sh — 验证所有Skills的Frontmatter

set -e

echo "🔍 验证Skills Frontmatter..."
echo ""

ERRORS=0

for skill in skills/*/SKILL.md; do
    name=$(dirname "$skill" | xargs basename)
    
    echo -n "检查 $name... "
    
    # 必须字段
    if ! grep -q "^name:" "$skill"; then
        echo "❌ 缺少 name"
        ERRORS=$((ERRORS + 1))
    elif ! grep -q "^description:" "$skill"; then
        echo "❌ 缺少 description"
        ERRORS=$((ERRORS + 1))
    elif ! grep -q "^version:" "$skill"; then
        echo "❌ 缺少 version"
        ERRORS=$((ERRORS + 1))
    elif ! grep -q "^license:" "$skill"; then
        echo "❌ 缺少 license"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅"
    fi
done

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✅ 所有Skills验证通过！"
    exit 0
else
    echo "❌ 发现 $ERRORS 个错误"
    exit 1
fi
