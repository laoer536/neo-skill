# Neo 的技能集

这是一个精心策划的 [Agent Skills](https://agentskills.io/home) 集合，反映了 Neo 的偏好、最佳实践和现代前端开发工具文档。

## 安装

### 方式一：使用 CLI（传统方式）

```bash
pnpx skills add neo/skills --skill='*'
```

或者全局安装所有技能：

```bash
pnpx skills add neo/skills --skill='*' -g
```

了解更多 CLI 使用方法，请访问 [skills](https://github.com/vercel-labs/skills)。

### 方式二：使用同步脚本（推荐用于本地开发）

将所有技能同步到你 AI 编程平台的本地目录：

```bash
./sync-all-skills.sh
```

这会将所有技能安装到 `~/.qoder/skills/`（或你配置的平台路径）。

**支持的 AI 平台：**
- Qoder: `~/.qoder/skills`
- Cursor: `~/.cursor/skills`
- 自定义: 编辑 `sync-all-skills.sh` 设置你的目标路径

查看 [AGENTS.zh.md](AGENTS.zh.md) 了解详细配置。

## 技能概览

本集合为使用 Vue 和 React 生态的开发者提供一站式技能库。

### 手动维护的技能

> 包含个人偏好

由 Neo 手动维护，包含偏好的工具、设置惯例和最佳实践。

| 技能 | 描述 |
|-------|-------------|
| [neo](skills/neo) | Neo 的编码规范、工具偏好和工作流指南 |

### Vue 生态

> 从官方文档生成

| 技能 | 描述 |
|-------|-------------|
| [vue](skills/vue) | Vue 3 核心 - Composition API、响应式、组件 |
| [nuxt](skills/nuxt) | Nuxt 3 框架 - SSR、服务器路由、模块 |
| [pinia](skills/pinia) | Pinia - 直观的、类型安全的 Vue 状态管理 |
| [vitepress](skills/vitepress) | VitePress - 基于 Vite 的静态站点生成器 |
| [vue-best-practices](skills/vue-best-practices) | Vue 3 + TypeScript 最佳实践 |

### React 生态

> 从官方文档生成

| 技能 | 描述 |
|-------|-------------|
| [react](skills/react) | React 18+ - Hooks、组件、Context、Suspense |
| [nextjs](skills/nextjs) | Next.js 14+ App Router - 服务器组件、服务器 Actions |

### 共享工具

> 适用于双生态的构建工具和实用工具

| 技能 | 描述 |
|-------|-------------|
| [vite](skills/vite) | Vite 构建工具 - 配置、插件、SSR |
| [vitest](skills/vitest) | Vitest - Vite 原生单元测试框架 |
| [pnpm](skills/pnpm) | pnpm - 快速、节省磁盘空间的包管理器 |

## 添加新技能

1. 在 `meta.ts` 的 manual 数组中添加技能名称
2. 运行 `pnpm start init` 创建技能结构
3. 在 `skills/{name}/references/` 中创建详细参考文档

查看 [AGENTS.zh.md](AGENTS.zh.md) 了解详细指南。

## 许可证

本仓库中的技能和脚本采用 [MIT](LICENSE.md) 许可证。
