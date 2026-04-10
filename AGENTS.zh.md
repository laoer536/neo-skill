# 技能管理指南

管理 Neo 的个人 Agent Skills 集合。

## 项目结构

本项目采用**纯手动管理**方式，不使用 Git submodules：

```
.
├── meta.ts                     # 技能注册表
├── scripts/
│   └── cli.ts                  # 技能管理 CLI
├── skills/                     # 所有技能目录
│   └── {skill-name}/
│       ├── SKILL.md           # 技能索引
│       └── references/
│           └── *.md            # 详细参考文档
├── AGENTS.md                   # 本指南（英文版）
└── AGENTS.zh.md               # 中文版本
```

## CLI 命令

```bash
pnpm start list        # 列出所有技能
pnpm start init        # 创建新的技能结构（交互式）
pnpm start init -y     # 自动创建 meta.ts 中的所有技能
pnpm start --help      # 显示帮助
```

## 添加新技能

### 方法一：使用 CLI

1. 在 `meta.ts` 的 `manual` 数组中添加技能名称：
   ```ts
   export const manual = [
     'neo',
     'react',
     'nextjs',
     'my-new-skill',  // 添加到这里
   ]
   ```

2. 运行初始化：
   ```bash
   pnpm start init -y
   ```

3. 编辑生成的文件：
   - `skills/my-new-skill/SKILL.md` - 技能索引
   - `skills/my-new-skill/references/*.md` - 详细参考文档

### 方法二：手动创建

1. 创建技能目录：
   ```bash
   mkdir -p skills/my-skill/references
   ```

2. 按照以下格式创建 `SKILL.md`

3. 添加到 `meta.ts` 的 manual 数组

## SKILL.md 格式

```markdown
---
name: skill-name
description: 技能的简要描述
metadata:
  author: Neo
  version: "2026.04.09"
  source: Manual
---

# 技能名称

> 简要总结或核心原则

## 偏好设置

- 在这里写下你的偏好

## 核心参考

| 主题 | 描述 | 参考 |
|-------|-------------|-----------|
| 主题 1 | 描述 | [topic-1](references/topic-1.md) |

## 功能特性

### 功能 A

| 主题 | 描述 | 参考 |
|-------|-------------|-----------|
| 功能 A | 描述 | [feature-a](references/feature-a.md) |
```

## 参考文档格式

```markdown
---
name: topic-name
description: 简要描述
---

# 主题名称

说明这个参考文档涵盖的内容。

## 使用方法

```typescript
// 代码示例
```

## 要点

- 重要细节 1
- 重要细节 2
```

## 编写指南

1. **简洁明了** - 删除冗余，保留核心信息
2. **实用为主** - 关注使用模式和代码示例
3. **一文一概念** - 将大型主题拆分
4. **包含代码** - 始终提供可工作的示例
5. **解释原因** - 不仅说明怎么用，还要说明何时用、为什么用

## 当前技能

查看 [README.zh.md](README.zh.md) 获取完整技能列表。
