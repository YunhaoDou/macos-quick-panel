<p align="center">
  <img src="design/icon_v2.svg" width="120" alt="QuickPanel Logo" />
</p>

<h1 align="center">QuickPanel</h1>

<p align="center">
  <strong>macOS 菜单栏快捷操作面板</strong><br />
  <code>⌥⌘P</code> 一键唤出 · 控制中心没有的功能
</p>

<p align="center">
  <a href="README.md">🇨🇳 中文</a> · <a href="README_EN.md">🇬🇧 English</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-13.0%2B-blue?logo=apple&logoColor=white" alt="macOS 13.0+">
  <img src="https://img.shields.io/badge/Swift-5.9%2B-orange?logo=swift&logoColor=white" alt="Swift 5.9+">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT">
  <img src="https://img.shields.io/github/stars/YunhaoDou/macos-quick-panel?style=flat" alt="Stars">
</p>

<p align="center">
  <a href="#-功能一览">功能</a> ·
  <a href="#-双入口模式">双入口</a> ·
  <a href="#-安装">安装</a> ·
  <a href="#-自定义">自定义</a> ·
  <a href="#-开箱即用-vs-控制中心">对比</a>
</p>

---

**QuickPanel** 是一个为 macOS 打造的轻量工具面板。它提供 Apple 控制中心 **没有的实用功能**，支持菜单栏点击和全局快捷键 `⌥⌘P` 两种方式打开。

> 🆓 免费 · 🧩 开源 MIT · ⚡ ~800KB · 🔒 纯本地运行

---

## 🎯 核心特性

**只做控制中心做不到的事：**

| 类别 | 功能 | 说明 |
|------|------|------|
| 🖼️ | **截图工具** | 区域/窗口/全屏/剪贴板，一键保存到桌面 |
| 🪟 | **窗口布局** | 左半/右半/全屏/居中，AppleScript 快速排列 |
| ☕ | **阻止休眠** | `caffeinate` 一键保持 Mac 唤醒 |
| 👁️ | **隐藏文件** | Finder 显示/隐藏系统文件开关 |
| 🔒 | **锁定屏幕** | 一键锁屏（ScreenSaverEngine） |
| 🗑️ | **清空废纸篓** | 快捷清理 |
| ⌨️ | **输入法切换** | 搜狗拼音 / ABC 一键切换，显示当前状态 |
| 🖥️ | **桌面图标** | 隐藏/显示桌面图标（演示时好用） |
| 📝 | **快速笔记** | 弹出编辑窗口，保存到 Obsidian 收件箱 |
| ⏰ | **番茄钟** | 25min 专注 / 5min 休息，完成时通知+响铃 |
| 📋 | **剪贴板历史** | 自动记录最近 20 条复制内容，点击即粘贴 |
| 🧹 | **清空剪贴板** | 一键清空剪贴板及历史记录 |
| 🏃 | **一键场景** | 💼工作 / 🌙深夜 / 🎤演示 / 🚪出门 四种模式 |
| 📦 | **内置更新** | 偏好设置中一键检查更新并下载安装 |

---

## 🏗️ 双入口模式

QuickPanel 提供两种打开方式：

```
┌─ 菜单栏入口 ─────────────────────┐
│                                   │
│  ▦        点击菜单栏图标          │
│                                   │
│  弹出下拉面板，随点随关           │
│  适合快速操作，不占桌面空间       │
│                                   │
├─ ⌥⌘P 快捷键入口 ────────────────┤
│                                   │
│  ⌥⌘P    全局快捷键唤出           │
│                                   │
│  浮动面板窗口，可拖动、可关闭     │
│  位置记忆，下次打开回到原位       │
│  适合长时间使用（番茄钟等）       │
└────────────────────────────────────┘
```

> ⌥⌘P 不与任何 macOS 系统快捷键冲突，也不与主流应用快捷键冲突。

---

## 📸 面板预览

### 菜单栏模式
```
┌──────────────────────────────────┐
│ 🔍 QuickPanel                    │
├──────────────────────────────────┤
│ Ａ 输入 & 桌面                    │
│   Ａ 输入法 (中/英)            ›  │
│   🖥️ 桌面图标                ○   │
├──────────────────────────────────┤
│ ⚡ 快捷操作                       │
│   🔒 锁定屏幕                 ›  │
│   🗑️ 清空废纸篓              ›   │
│   📝 笔记 → Obsidian          ›  │
│   ⏰ 番茄钟                   ›  │
│   📋 剪贴板历史 (3)  🧹    ▼    │
├──────────────────────────────────┤
│ 🖼️ 截图                           │
│ [区域] [窗口] [全屏] [剪贴板]     │
├──────────────────────────────────┤
│ 🪟 窗口布局                       │
│ [◧左半] [◨右半] [⛶全屏] [⬡居中]  │
├──────────────────────────────────┤
│ 🛠️ 系统工具                       │
│ ☕ 阻止休眠                   ○   │
│ 👁️ 隐藏文件                  ○   │
├──────────────────────────────────┤
│ 🏃 一键场景                       │
│ [💼工作] [🌙深夜] [🎤演示] [🚪出门]│
├──────────────────────────────────┤
│ ⚙️ 偏好设置     ⌥⌘P        退出  │
└──────────────────────────────────┘
```

### 浮动面板模式（⌥⌘P）
内容与菜单栏一致，但为独立窗口：
- 可拖拽到任意位置
- 位置自动记忆
- 底部有 `⌥⌘P` / `隐藏` 提示
- 顶部显示 **QuickPanel** 标题 + 操作反馈

---

## 📦 安装

### 方式一：下载 Release（推荐）

```bash
# 前往 Releases 页面下载最新 .dmg
https://github.com/YunhaoDou/macos-quick-panel/releases

# 打开 .dmg → 拖到 Applications 文件夹
# 首次打开：右键 → 打开
```

### 方式二：源码构建

```bash
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

### 开机自启

`系统设置 → 通用 → 登录项 → + → QuickPanel.app`

---

## ⚙️ 偏好设置

点击面板底部 ⚙️ **偏好设置** 打开：

| 设置项 | 说明 |
|--------|------|
| **Obsidian 路径** | 修改快速笔记的保存目录（支持浏览选择） |
| **开机启动** | 登录时自动启动 |  
| **全局快捷键** | 当前 `⌥⌘P` |
| **检查更新** | 自动检测 GitHub 最新 Release |

---

## ✅ 开箱即用 vs 控制中心

| 功能 | QuickPanel | 控制中心 |
|------|-----------|---------|
| 截图工具 (区域/窗口/全屏) | ✅ | ❌ |
| 窗口布局 (左/右/全屏/居中) | ✅ | ❌ |
| 阻止休眠 (Caffeinate) | ✅ | ❌ |
| Finder 隐藏文件开关 | ✅ | ❌ |
| 锁定屏幕 | ✅ | ❌ |
| 清空废纸篓 | ✅ | ❌ |
| 输入法切换 (中/英) | ✅ | ❌ |
| 桌面图标隐藏 | ✅ | ❌ |
| 快速笔记 (Obsidian) | ✅ | ❌ |
| 番茄钟 | ✅ | ❌ |
| 剪贴板历史 | ✅ | ❌ |
| 一键场景 (4种模式) | ✅ | ❌ |
| 快捷键 ⌥⌘P 唤出 | ✅ | ❌ |
| 内置自动更新 | ✅ | ❌ |
| 深色模式 | ❌ 由控制中心提供 | ✅ |
| 音频输出切换 | ❌ 由控制中心提供 | ✅ |
| 勿扰模式 | ❌ 由控制中心提供 | ✅ |

---

## 🏗️ 架构

```
macos-quick-panel/
├── Package.swift                 # SwiftPM
├── Info.plist                    # LSUIElement = true
├── QuickPanel.icns               # 图标 (1.4MB)
├── design/icon_v2.svg            # 图标设计源文件
├── scripts/
│   ├── build.sh                  # 编译 + .app 打包
│   └── create-dmg.sh             # DMG 安装包生成
└── Sources/QuickPanel/
    ├── QuickPanelApp.swift       # @main + AppState
    ├── MenuBarContent.swift      # 菜单栏面板 UI + 毛玻璃
    ├── PanelManager.swift        # 浮动主面板 (NSPanel)
    ├── Helpers/
    │   ├── SystemCommands.swift   # 锁屏、废纸篓
    │   ├── ClipboardManager.swift # 剪贴板监听
    │   ├── InputMethodManager.swift # TIS 输入法
    │   ├── DesktopIconsManager.swift # 桌面图标
    │   ├── ScreenshotManager.swift  # 截图 (screencapture)
    │   ├── WindowManager.swift     # 窗口布局 (AppleScript)
    │   ├── CaffeinateManager.swift  # 阻止休眠 (caffeinate)
    │   ├── FinderHiddenFilesManager.swift # 隐藏文件
    │   ├── HotkeyManager.swift    # 全局快捷键 (Carbon)
    │   ├── AppUpdater.swift       # 内置自动更新
    │   └── SettingsStore.swift    # UserDefaults 持久化
    └── Features/
        ├── PomodoroView.swift     # 番茄钟 UI
        ├── QuickNote.swift        # 快速笔记
        ├── ObsidianManager.swift  # Obsidian 写入
        ├── Macros.swift           # 一键场景执行器
        ├── ClipboardHistoryView.swift # 剪贴板历史 UI
        └── PreferencesView.swift  # 偏好设置窗口
```

### 技术栈

| 层 | 技术 |
|----|------|
| **语言** | Swift 5.9+ |
| **UI** | SwiftUI MenuBarExtra + NSPanel + NSVisualEffectView |
| **截图** | `screencapture` CLI |
| **窗口管理** | AppleScript (System Events) |
| **输入法** | Carbon TIS API |
| **快捷键** | Carbon Event HotKey |
| **系统** | Process (zsh) + AppleScript + DistributedNotificationCenter |
| **最低** | macOS 13.0 (Ventura) |
| **构建** | Swift Package Manager · ad-hoc 签名 |

---

## 🗺️ 路线图

- [x] 快捷操作（锁屏/废纸篓/笔记/番茄钟/剪贴板）
- [x] 输入法切换 + 桌面图标
- [x] 截图工具 + 窗口布局
- [x] Caffeinate + 隐藏文件
- [x] 一键场景（4种模式）
- [x] 毛玻璃 UI
- [x] 操作反馈 Toast
- [x] 全局快捷键 ⌥⌘P
- [x] 双入口模式（菜单栏 + 浮动面板）
- [x] 偏好设置 + 内置自动更新
- [ ] 自定义场景（用户编辑）
- [ ] Homebrew Cask 安装
- [ ] GitHub Actions CI

---

## 🤝 贡献

```bash
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

欢迎 Issue / PR / Feature Request！

---

## 📄 许可证

[MIT License](LICENSE) © 2025 YunhaoDou

<p align="center">
  <a href="README_EN.md">🇬🇧 English</a>
</p>
