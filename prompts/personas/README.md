# Hermes Personas

预定义的个性预设，可以在Hermes中切换使用。

## 使用方式

在Hermes中输入：
```
/personality concise
```

## 可用Personas

| 名称 | 说明 |
|------|------|
| helpful | 友好助人型 |
| concise | 简洁直接型 |
| technical | 技术专家型 |
| creative | 创意发散型 |
| teacher | 耐心教导型 |
| noir | 黑色侦探型 |

## 添加新Persona

在 `agents/hermes/config.yaml` 的 `personalities` 部分添加：

```yaml
personalities:
  my persona:
    "Your persona description here..."
```
