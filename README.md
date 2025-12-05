# Neovim 配置

> 作者：chenao
>
> 一个现代化、模块化的 Neovim 配置，专为全栈开发者打造，集成了 LSP、AI 辅助编程、文件管理等丰富功能。

## ✨ 特性

### 核心功能

- 🎨 **现代主题** - Dracula 配色方案，支持透明背景和斜体注释
- 📦 **插件管理** - 基于 lazy.nvim 的懒加载插件管理系统
- 🔍 **文件导航** - Telescope 模糊搜索 + nvim-tree 文件树
- 🌲 **语法高亮** - Treesitter 提供更智能的代码高亮和文本对象
- 🔧 **LSP 支持** - 完整的语言服务器协议支持，包含自动补全、代码诊断、格式化等

### AI 辅助编程

- 🤖 **GitHub Copilot** - 智能代码补全建议
  - `Ctrl+L` 接受建议
  - `Ctrl+J/K` 切换建议
- 🧠 **Claude Code CLI** - 在终端中使用 Claude Code 进行 AI 辅助编程

### 语言支持

| 语言 | LSP | 语法高亮 | 格式化 |
|------|-----|----------|--------|
| Lua | ✅ lua_ls | ✅ | ✅ |
| TypeScript/JavaScript | ✅ ts_ls + ESLint | ✅ | ✅ |
| React (JSX/TSX) | ✅ | ✅ | ✅ |
| Python | ✅ pyright | ✅ | ✅ |
| Go | ✅ gopls | ✅ | ✅ |
| Rust | ✅ rust-analyzer | ✅ | ✅ |
| Java | ✅ jdtls | ✅ | ✅ |
| CSS/SCSS | ✅ cssls | ✅ | ✅ |
| JSON | ✅ jsonls | ✅ | ✅ |
| Kotlin | - | ✅ | - |
| Vue | - | ✅ | - |
| YAML | - | ✅ | ✅ (ALE) |
| Markdown | - | ✅ | ✅ |

额外支持：Nginx、Ansible、TOML、Dhall、Mermaid、Groovy 等

### 开发工具

- 🔄 **Git 集成** - gitgutter + neogit + diffview + git-blame
- 🐛 **调试支持** - nvim-dap + vim-delve (Go 语言调试器)
- 📄 **Markdown** - 实时预览支持
- 📐 **EditorConfig** - 自动应用项目代码风格规范
- 🖥️ **终端** - toggleterm.nvim 集成终端，支持右侧垂直分屏

## 📋 系统要求

- Neovim >= 0.11.0
- Git
- Node.js >= 18.0 (用于 Copilot 和部分 LSP)
- Python 3.x (用于部分插件)
- ripgrep (用于 Telescope 搜索)
- 一个 [Nerd Font](https://www.nerdfonts.com/) 字体（用于图标显示）

### 可选依赖

- `yarn` - Markdown 预览
- `go` - 使用 Delve 调试器
- Language servers 会通过 Mason 自动安装

## 🚀 安装

### 1. 备份现有配置

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

### 2. 克隆配置仓库

```bash
git clone <your-repo-url> ~/.config/nvim
```

### 3. 启动 Neovim

```bash
nvim
```

首次启动时，lazy.nvim 会自动安装所有插件。等待安装完成后重启 Neovim。

### 4. 安装 Language Servers

打开 Neovim 后执行：

```vim
:Mason
```

配置中已设置自动安装以下 LSP：
- lua_ls, ts_ls, rust_analyzer, pyright, gopls
- jdtls, cssls, jsonls, tailwindcss, eslint

### 5. 配置 Copilot (可选)

```vim
:Copilot setup
```

按照提示完成 GitHub 授权。

## 📁 配置结构

```
~/.config/nvim/
├── init.lua                 # 入口文件
├── core/                    # 核心配置
│   ├── options.lua          # Vim 选项设置
│   ├── keymaps.lua          # 全局按键映射
│   ├── autocmds.lua         # 自动命令
│   └── theme.lua            # 主题和高亮配置
├── plugins/                 # 插件配置
│   ├── init.lua             # 插件列表和加载
│   └── configs/             # 各插件的详细配置
│       ├── lsp.lua          # LSP 配置
│       ├── telescope.lua    # 模糊搜索配置
│       ├── nvim-tree.lua    # 文件树配置
│       ├── lualine.lua      # 状态栏配置
│       ├── dap.lua          # 调试器配置
│       └── ...
├── ftplugin/                # 文件类型特定配置
├── indent/                  # 自定义缩进规则
└── lazy-lock.json          # 插件版本锁定
```

## ⌨️ 快捷键

### 基础编辑

Leader 键: `空格键`

#### 文件操作
| 快捷键 | 功能 |
|--------|------|
| `<leader>w` | 保存文件 |
| `<leader>rr` | 重新加载文件 |
| `<leader>Q` | 强制退出 |
| `<leader>sv` | 重新加载配置 |
| `<leader>nf` | 在当前目录新建文件 |

#### 窗口管理
| 快捷键 | 功能 |
|--------|------|
| `<leader>v` | 垂直分屏 |
| `<leader>h/j/k/l` | 窗口间导航 |
| `<leader>oo` | 仅保留当前窗口 |
| `<leader>q` | 关闭当前窗口 |

#### 标签页管理
| 快捷键 | 功能 |
|--------|------|
| `<leader>tn` | 新建标签页 |
| `<leader>tc` | 关闭标签页 |
| `<leader>to` | 仅保留当前标签页 |
| `<leader>tm` | 移动标签页 |

#### Buffer 管理 (bufferline)
| 快捷键 | 功能 |
|--------|------|
| `<Tab>` | 下一个 buffer |
| `<S-Tab>` | 上一个 buffer |
| `<leader>bc` | 关闭当前 buffer |
| `<leader>bo` | 关闭其他 buffers |

#### 终端 (toggleterm)
| 快捷键 | 功能 |
|--------|------|
| `<leader>tt` | 打开/关闭右侧终端 |
| `<Esc>` | 退出终端模式 |
| `<C-q>` | 从终端切换到左侧窗口 |

#### 剪贴板操作
| 快捷键 | 功能 |
|--------|------|
| `<leader>y` | 复制到系统剪贴板 |
| `<leader>Y` | 复制整行到系统剪贴板 |
| `<leader>p` | 从系统剪贴板粘贴 |

### LSP 功能

| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 |
| `gD` | 跳转到声明 |
| `gi` | 跳转到实现 |
| `gr` | 查看引用 |
| `K` | 显示悬浮文档（增强版） |
| `<C-k>` | 显示函数签名 |
| `<leader>rn` | 重命名符号 |
| `<leader>La` | 代码动作 |
| `<leader>f` | 格式化代码 |
| `<leader>e` | 显示诊断信息 |
| `[g` | 上一个诊断 |
| `]g` | 下一个诊断 |
| `<leader>dl` | 诊断列表 |

### 文件导航

#### Telescope (模糊搜索)
| 快捷键 | 功能 |
|--------|------|
| `<leader>ff` | 查找文件 |
| `<leader>fg` | 全文搜索 (live grep) |
| `<leader>fb` | 搜索缓冲区 |
| `<leader>fh` | 搜索帮助文档 |

#### nvim-tree (文件树)
| 快捷键 | 功能 |
|--------|------|
| `<leader>tt` | 切换文件树 |
| 在文件树中: `a` | 新建文件 |
| 在文件树中: `d` | 删除文件 |
| 在文件树中: `r` | 重命名文件 |
| 在文件树中: `x` | 剪切文件 |
| 在文件树中: `p` | 粘贴文件 |

### Git 操作

#### Neogit & Diffview
| 快捷键 | 功能 |
|--------|------|
| `<leader>gg` | 打开 Neogit (Git 状态) |
| `<leader>gc` | Git commit |
| `<leader>gd` | 打开 Diffview |
| `<leader>gh` | 当前文件历史 |
| `<leader>gH` | 仓库提交历史 |
| `<leader>gq` | 关闭 Diffview |

#### GitGutter
| 快捷键 | 功能 |
|--------|------|
| `<leader>gp` | 预览 hunk 变更 |
| `<leader>gu` | 撤销 hunk 变更 |
| `<leader>gs` | 暂存 hunk |
| 行号旁显示 | Git diff 变更指示 |

### 调试 (DAP)

#### 通用调试快捷键
| 快捷键 | 功能 |
|--------|------|
| `<leader>db` | 切换断点 |
| `<leader>dB` | 条件断点 |
| `<leader>dc` | 继续执行 |
| `<leader>dn` | 单步跳过 (Step over) |
| `<leader>ds` | 单步进入 (Step into) |
| `<leader>do` | 单步跳出 (Step out) |
| `<leader>dr` | 重启调试 |
| `<leader>dq` | 终止调试 |
| `<leader>du` | 切换 DAP UI |
| `<leader>de` | 计算表达式 |

#### Java (nvim-java)

**构建**
| 快捷键 | 功能 |
|--------|------|
| `<leader>jbb` | 构建工作区 |
| `<leader>jbc` | 清理工作区 |

**运行**
| 快捷键 | 功能 |
|--------|------|
| `<leader>jr` | 运行 main 方法 |
| `<leader>js` | 停止运行 |
| `<leader>jl` | 切换日志窗口 |

**调试**
| 快捷键 | 功能 |
|--------|------|
| `<leader>jdc` | 配置 DAP |

**测试**
| 快捷键 | 功能 |
|--------|------|
| `<leader>jtc` | 运行测试类 |
| `<leader>jtC` | 调试测试类 |
| `<leader>jtm` | 运行测试方法 |
| `<leader>jtM` | 调试测试方法 |
| `<leader>jtr` | 查看测试报告 |

**配置**
| 快捷键 | 功能 |
|--------|------|
| `<leader>jp` | 打开 Profiles UI |
| `<leader>jsr` | 切换 JDK 版本 |

**重构**
| 快捷键 | 功能 |
|--------|------|
| `<leader>jrv` | 提取变量 |
| `<leader>jrV` | 提取变量 (所有出现) |
| `<leader>jrc` | 提取常量 |
| `<leader>jrm` | 提取方法 |
| `<leader>jrf` | 提取字段 |

### 会话管理

| 快捷键 | 功能 |
|--------|------|
| `<leader>ss` | 保存会话 |
| `<leader>sl` | 加载会话 |

## 🎨 编码规范

### 缩进规则

- **Python, Go, Kotlin, Java**: 4 空格
- **JavaScript, TypeScript, HTML, CSS, YAML, JSON, Vue, Lua**: 2 空格
- **所有文件**: 使用空格代替 Tab
- **自动缩进**: 启用

### 文件类型关联

- `*.kt` → Kotlin
- `*.gradle` → Groovy
- `*.tsx` → TypeScript React
- `*.jsx` → JavaScript React
- `*.ympl` → YAML
- `Dockerfile.*` → Dockerfile
- JSON 文件支持注释 (JSONC)

### EditorConfig

本配置支持 EditorConfig，会自动读取项目根目录的 `.editorconfig` 文件并应用相应的编码规范。

## 🔌 主要插件列表

### 核心插件

- **lazy.nvim** - 插件管理器
- **plenary.nvim** - Lua 实用函数库

### 界面增强

- **dracula.nvim** - Dracula 主题
- **lualine.nvim** - 状态栏（每个窗口独立显示）
- **bufferline.nvim** - Buffer 标签栏
- **nvim-web-devicons** - 文件图标
- **indent-blankline.nvim** - 缩进参考线
- **mini.nvim** - 小型实用工具集合
- **toggleterm.nvim** - 集成终端

### 文件管理

- **nvim-tree.lua** - 文件浏览器
- **telescope.nvim** - 模糊查找器
- **fzf.vim** - 模糊搜索

### LSP 和补全

- **nvim-lspconfig** - LSP 配置
- **mason.nvim** - LSP/DAP/Linter 安装管理
- **mason-lspconfig.nvim** - Mason 与 LSP 桥接
- **nvim-cmp** - 自动补全引擎
- **LuaSnip** - 代码片段引擎

### AI 辅助

- **copilot.lua** - GitHub Copilot

### Git 工具

- **vim-gitgutter** - Git diff 标记
- **neogit** - Git 命令集成 (Magit 风格)
- **diffview.nvim** - Git diff 和文件历史查看
- **git-blame.nvim** - Git blame 显示

### 语法和语言

- **nvim-treesitter** - 语法解析器
- **vim-js** / **vim-jsx-pretty** - JavaScript/React
- **rust.vim** - Rust
- **kotlin-vim** - Kotlin
- **ansible-vim** - Ansible
- **vim-vue-plugin** - Vue.js
- **nginx.vim** - Nginx 配置
- 更多语言支持...

### 开发工具

- **nvim-dap** - 调试适配器协议
- **nvim-dap-ui** - 调试界面
- **nvim-dap-virtual-text** - 调试时显示变量值
- **vim-delve** - Go 调试器
- **nvim-java** - Java 开发支持 (LSP, DAP, 测试, 重构)
- **markdown-preview.nvim** - Markdown 实时预览

## 🛠️ 自定义配置

### 修改 Leader 键

编辑 `core/options.lua`:

```lua
vim.g.mapleader = " "  -- 改为你喜欢的键
```

### 添加新插件

编辑 `plugins/init.lua`，在 `require("lazy").setup({})` 中添加：

```lua
{
  "author/plugin-name",
  config = function()
    -- 插件配置
  end
}
```

### 添加 LSP 服务器

编辑 `plugins/configs/lsp.lua`：

1. 在 `ensure_installed` 中添加 LSP 名称
2. 使用 `vim.lsp.config()` 配置服务器

```lua
vim.lsp.config('your_lsp', {
  on_attach = on_attach,
  capabilities = capabilities,
  -- 其他设置...
})
```

### 修改按键映射

编辑 `core/keymaps.lua`：

```lua
map("n", "<your-key>", "<command>", opts)
```

### 调整缩进规则

编辑 `core/autocmds.lua`，在 `tab_width` 表中修改或添加：

```lua
local tab_width = {
  your_filetype = 2,  -- 设置缩进宽度
}
```

## 📝 使用技巧

### 1. 项目快速导航

- 使用 `<leader>ff` 快速查找文件
- 使用 `<leader>fg` 在项目中全文搜索
- 使用 nvim-tree 浏览目录结构

### 2. LSP 工作流

1. 将光标移到符号上按 `K` 查看文档
2. 按 `gd` 跳转到定义
3. 按 `gr` 查看所有引用
4. 按 `<leader>rn` 重命名符号

### 3. AI 辅助编程

- 编写代码时，Copilot 会自动提供建议
- 使用 `<leader>tt` 打开终端，运行 Claude Code CLI 进行 AI 辅助编程

### 4. Git 集成

- 左侧行号旁会显示修改标记 (GitGutter)
- 使用 `<leader>gg` 打开 Neogit 进行 Git 操作
- 使用 `<leader>gd` 打开 Diffview 查看差异
- 使用 `<leader>gh` 查看当前文件历史

### 5. 代码检查和格式化

- 使用 `<leader>f` 格式化当前文件
- LSP 提供实时诊断信息

## 🐛 故障排查

### 插件安装失败

```vim
:Lazy sync
:Lazy clean
:Lazy update
```

### LSP 不工作

1. 检查 Mason 安装：`:Mason`
2. 查看 LSP 日志：`:LspLog`
3. 重启 LSP：`:LspRestart`

### Copilot 无法使用

```vim
:Copilot setup
:Copilot status
```

### 图标显示异常

确保终端使用了 Nerd Font 字体。

## 📄 许可证

个人使用的 Neovim 配置，欢迎参考和修改。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

如有问题或建议，请随时联系。Happy Coding! 🎉
