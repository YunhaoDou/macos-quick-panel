<p align="center">
  <img src="QuickPanel.icns" width="128" alt="QuickPanel Logo" />
</p>

<h1 align="center">QuickPanel</h1>

<p align="center">
  <strong>macOS 菜单栏快捷操作面板</strong><br />
  系统控制 · 效率增强 · 一键场景
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13.0%2B-blue?logo=apple&logoColor=white" alt="macOS 13.0+">
  <img src="https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift&logoColor=white" alt="Swift 5.9+">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT">
  <img src="https://img.shields.io/github/stars/YunhaoDou/macos-quick-panel?style=flat" alt="Stars">
</p>

<p align="center">
  <a href="#-功能">功能</a> ·
  <a href="#-安装">安装</a> ·
  <a href="#-使用">使用</a> ·
  <a href="#-竞品对比">竞品对比</a> ·
  <a href="#-自定义">自定义</a> ·
  <a href="#-路线图">路线图</a>
</p>

---

**QuickPanel** 是一个轻量、开源、免费的 macOS 菜单栏工具箱。点击菜单栏图标即可快速控制系统设置、执行常用操作、或一键切换工作/生活场景，不用打开系统偏好设置，不用装全家桶。

> 🆓 完全免费 · 🧩 开源可自定义 · ⚡ 800KB 极致轻量 · 🔒 纯本地运行无网络依赖

---

## 📸 预览

```
┌─────────────────────────────────┐
│ 🔍 搜索文件 / App…               │
├─────────────────────────────────┤
│ 🎛️ 系统控制                      │
│   🌙 深色模式               ○ ON │
│   🔊 输出设备       AirPods ▾    │
│   🔇 勿扰模式               ○    │
│   🔒 锁定屏幕                ›   │
├─────────────────────────────────┤
│ ⚡ 快捷操作                      │
│   🗑️ 清空废纸篓               ›   │
│   📝 快速笔记 → Obsidian      ›   │
│   ⏰ 番茄钟                   ›   │
│   📋 剪贴板历史                ›   │
├─────────────────────────────────┤
│ 🏃 一键场景                      │
│ [💼 工作] [🌙 深夜] [🎤 演示] [🚪 出门] │
├─────────────────────────────────┤
│  偏好设置                    退出 │
└─────────────────────────────────┘
```

---

## 🚀 功能

### 🎛️ 系统控制
| 功能 | 说明 | 实现方式 |
|------|------|---------|
| **深色模式** | 一键切换 Light / Dark 外观 | `defaults write` + 系统通知 |
| **音频输出** | 切换扬声器 / 耳机 / AirPods | CoreAudio API / SwitchAudioSource |
| **勿扰模式** | 开启/关闭专注模式 | System Events AppleScript |
| **锁定屏幕** | 快速锁屏 | `CGSession -suspend` |

### ⚡ 快捷操作
| 功能 | 说明 |
|------|------|
| **清空废纸篓** | 一键清空 `~/.Trash/` |
| **快速笔记** | 弹出编辑器，保存到 Obsidian 收件箱 |
| **番茄钟** | 25min 专注 + 5min 休息，支持暂停/重置 |
| **剪贴板历史** | 监控最近 20 条复制记录，点击即粘贴 |

### 🏃 一键场景
场景模式让你**一次点击完成一串操作**：

| 场景 | 触发动作 |
|------|---------|
| 💼 **工作模式** | 打开 VSCode + Chrome + Terminal → 浅色模式 |
| 🌙 **深夜模式** | 深色模式 → 音量 20% → 关闭消息/Mail |
| 🎤 **演示模式** | 勿扰开启 → 隐藏桌面图标 → 深色模式 |
| 🚪 **出门模式** | 关闭工作应用 → 清废纸篓 → 锁屏 |

> 所有场景动作可在 `Features/Macros.swift` 自由修改。

---

## 📦 安装

### 方式一：下载 Release（推荐）
```bash
# 从 Releases 下载最新版 QuickPanel.app
# 拖到 Applications 文件夹即可
```

### 方式二：源码构建
```bash
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

### 开机自启
`系统设置 → 通用 → 登录项 → + → 选择 QuickPanel.app`

### 权限说明
首次使用部分功能时，macOS 会弹窗请求权限：
| 权限 | 需要的原因 |
|------|-----------|
| **辅助功能** | 切换音频输出、锁屏、控制勿扰 |
| **自动化 → System Events** | 一键场景中的 AppleScript 调用 |

前往 `系统设置 → 隐私与安全性 → 辅助功能` 允许 QuickPanel 即可。

---

## 🎮 使用

点击菜单栏的 ▦ 图标展开面板，所有操作都在面板内完成。

### ⌨️ 快捷键（规划中）
> 未来将支持全局快捷键唤出面板（`⌥⌘Q` 等）

### 🔧 修改 Obsidian 路径
编辑 `Sources/QuickPanel/Features/ObsidianManager.swift`：
```swift
static var vaultPath: String {
    UserDefaults.standard.string(forKey: "obsidian_vault_path")
        ?? "\(NSHomeDirectory())/Documents/Obsidian"  // ← 修改这里
}
```

### 🛠️ 自定义场景动作
编辑 `Sources/QuickPanel/Features/Macros.swift`，修改 `MacroRunner` 中的 shell 命令即可自定义每个场景的行为。

---

## 📊 竞品对比

QuickPanel 属于 **macOS 菜单栏工具箱** 品类，以下是同类产品的详细对比：

| 维度 | QuickPanel | One Switch | Raycast | Alfred Powerpack | Bartender | BetterTouchTool |
|------|-----------|-----------|---------|-----------------|-----------|----------------|
| **价格** | 🆓 免费 | ¥38 买断 | 免费 / ¥93 Pro | ¥299 | ¥78 | ¥88 |
| **开源** | ✅ MIT | ❌ | ❌ | ❌ | ❌ | ❌ |
| **菜单栏常驻** | ✅ | ✅ | ❌ 启动器 | ❌ 启动器 | ✅ 图标管理 | ✅ 自定义 |
| **语言** | 中文 / 英文 | 英文 | 英文 | 英文 | 英文 | 英文 |
| **深色模式** | ✅ 一键 | ✅ 一键 | 需插件 | 需工作流 | ❌ | 需配置 |
| **音频输出切换** | ✅ 下拉选 | ❌ | 需插件 | 需工作流 | ❌ | 需配置 |
| **勿扰开关** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **场景宏** | ✅ 4场景内置 | ❌ | ❌ | ✅ 可配 | ❌ | ✅ 强大 |
| **番茄钟** | ✅ 内置 | ❌ | 需插件 | ❌ | ❌ | ❌ |
| **剪贴板历史** | ✅ 20条 | ❌ | ✅ 强大 | ✅ 强大 | ❌ | ❌ |
| **快速笔记** | ✅ Obsidian | ❌ | ✅ 插件 | ✅ Snippet | ❌ | ❌ |
| **菜单栏图标管理** | ❌ | ❌ | ❌ | ❌ | ✅ 核心 | ❌ |
| **体积** | ~800KB | ~5MB | ~50MB | ~30MB | ~10MB | ~20MB |
| **技术栈** | SwiftUI | Swift | TS/React | Obj-C/Swift | Swift | Obj-C |

### 与 One Switch 的对比

**One Switch** 是最直接的竞品——都是菜单栏系统开关。差异：
- One Switch 是闭源付费（¥38），QuickPanel 开源免费
- QuickPanel 多出：**番茄钟、剪贴板历史、一键场景、QuickNote**
- One Switch 有 **隐藏桌面图标、屏幕保护、Night Shift** 等 QuickPanel 尚未覆盖的功能

### 与 Raycast 的对比

**Raycast** 是启动器，QuickPanel 是面板，**两者可以共存**：
- Raycast 需要 `⌘Space` 唤出，适合键盘党深度操作
- QuickPanel 常驻菜单栏，适合鼠标党快速点击
- QuickPanel 的一键场景和番茄钟是开箱即用，Raycast 需要装插件

### 为什么不用 Apple 控制中心？

Apple 控制中心只覆盖部分系统功能，且不包含：废纸篓清理、剪贴板历史、番茄钟、笔记、场景宏。QuickPanel 填补了这些空白。

---

## 🏗️ 架构

```
macos-quick-panel/
├── Package.swift                 # SwiftPM 构建配置
├── Info.plist                    # App bundle 配置 (LSUIElement)
├── QuickPanel.icns               # App 图标
├── design/                       # 图标设计源文件
│   └── icon_v2.svg
├── scripts/
│   └── build.sh                  # 编译 + .app 打包脚本
└── Sources/
    └── QuickPanel/
        ├── QuickPanelApp.swift   # @main 入口 + AppState
        ├── MenuBarContent.swift  # 面板 UI 主视图
        ├── Helpers/
        │   ├── SystemCommands.swift  # 系统命令 (dark mode / lock / trash)
        │   ├── AudioManager.swift    # 音频设备管理 (CoreAudio)
        │   ├── DoNotDisturb.swift    # 勿扰模式开关
        │   └── ClipboardManager.swift # 剪贴板监听
        └── Features/
            ├── PomodoroTimer.swift   # 番茄钟逻辑
            ├── PomodoroView.swift    # 番茄钟 UI
            ├── QuickNote.swift       # 快速笔记编辑器
            ├── ObsidianManager.swift  # Obsidian 写入
            ├── Macros.swift          # 一键场景执行器
            └── ClipboardHistoryView.swift # 剪贴板历史 UI
```

### 技术栈
| 层 | 技术 |
|----|------|
| **语言** | Swift 5.9+ |
| **UI 框架** | SwiftUI (MenuBarExtra) + AppKit 桥接 |
| **音频** | CoreAudio API |
| **系统调用** | Process (zsh) + AppleScript + DistributedNotificationCenter |
| **最低系统** | macOS 13.0 (Ventura) |
| **构建** | Swift Package Manager |
| **打包** | 自定义 build.sh → .app bundle + ad-hoc 签名 |

---

## 🗺️ 路线图

### v1.1 — 体验优化
- [ ] 剪贴板自动轮询（当前需手动展开）
- [ ] 全局快捷键唤出面板
- [ ] 面板位置记忆（固定/跟随菜单栏）
- [ ] 番茄钟完成通知

### v1.2 — 更多功能
- [ ] Wi-Fi 列表快速切换
- [ ] 隐藏/显示桌面图标
- [ ] Night Shift 开关
- [ ] 自定义场景（用户添加/编辑）

### v2.0 — 平台提升
- [ ] 偏好设置窗口（UI 配置而非改源码）
- [ ] 插件系统 / 第三方集成
- [ ] GitHub Releases + CI 自动构建
- [ ] Homebrew Cask 安装

---

## 🤝 贡献

欢迎 Issue / PR / Feature Request！

```bash
# 本地开发
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

---

## 📄 许可证

[MIT License](LICENSE) © 2025 YunhaoDou

---

<p align="center">
  <b>QuickPanel</b> — 让 macOS 操控快一点。
</p>
