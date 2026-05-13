# Persona Distill Skill

将任何人的思维方式蒸馏成可运行的AI Skill。

## 什么是人物蒸馏？

人物蒸馏是把一个人独特的思维方式——心智模型、决策框架、表达DNA——提取成可复用的AI Skill的技术。

不是角色扮演，是提取**认知操作系统**。同一个问题，芒格和马斯克会给出不同答案，因为他们用的是不同的思维框架。

## 核心功能

- **5层蒸馏模型**：表达DNA → 心智模型 → 决策启发式 → 反模式 → 诚实边界
- **双轨架构**：工作Skill × 人格 Persona 分离，效果更精准
- **六路并行调研**：著作/访谈/社媒/批评者/关键决策/人生时间线
- **三重验证**：跨域复现 + 预测力 + 辨识度
- **对抗性验证**：方向一致性、反向诱导、边界测试、匿名辨识度

## 安装

### Claude Code
```bash
npx skills add heshuidewajueji/persona-distill-skill
```

### Hermes Agent
```bash
# 克隆到skills目录
git clone https://github.com/heshuidewajueji/persona-distill-skill ~/.hermes/skills/persona-distill
```

### OpenClaw
```bash
openclaw skills install heshuidewajueji/persona-distill-skill
```

## 使用方法

蒸馏一个新人物：
```
> 蒸馏一个张一鸣
> 帮我做一个乔布斯的Skill
> 用芒格的视角帮我分析这个投资决策
```

## 蒸馏检查清单

- [ ] 确认数据源类型（聊天/书籍/访谈/社媒）
- [ ] 覆盖至少3个数据源类型
- [ ] 通过三重验证（跨域/预测力/辨识度）
- [ ] 标注诚实边界

## 已蒸馏人物推荐

```bash
# 一键安装已蒸馏好的Skill
npx skills add alchaincyf/paul-graham-skill
npx skills add alchaincyf/karpathy-skill
npx skills add alchaincyf/steve-jobs-skill
npx skills add alchaincyf/elon-musk-skill
npx skills add alchaincyf/munger-skill
npx skills add alchaincyf/naval-skill
```

## 参考项目

- [女娲.skill](https://github.com/alchaincyf/nuwa-skill) - 通用蒸馏框架
- [同事.skill](https://github.com/titanwings/colleague-skill) - 同事关系蒸馏
- [awesome-persona-distill-skills](https://github.com/xixu-me/awesome-persona-distill-skills) - 全面的蒸馏Skill列表

## License

MIT
