<p align="center">
  <img src="QuickPanel.icns" width="128" alt="QuickPanel Logo" />
</p>

<h1 align="center">QuickPanel</h1>

<p align="center">
  <strong>macOS Menu Bar Quick Control Panel</strong><br />
  System Controls · Productivity Tools · One-Click Scenes
</p>

<p align="center">
  <a href="README.md">🇨🇳 中文</a> ·
  <a href="README_EN.md">🇬🇧 English</a>
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
  <a href="#-自定义">自定义</a> ·
  <a href="#-路线图">路线图</a>
</p>

---

**QuickPanel** 是一个轻量、开源、免费的 macOS 菜单栏工具箱。点击菜单栏图标即可快速控制系统设置、执行常用操作、或一键切换工作/生活场景。

> 🆓 完全免费 · 🧩 开源可自定义 · ⚡ 800KB 极致轻量 · 🔒 纯本地运行无网络依赖

> 🇬🇧 English version: [README_EN.md](README_EN.md)

---

## 📸 预览

```
┌─────────────────────────────────┐
│ 🔍 搜索文件 / App…       ⌥⌘Q    │
├─────────────────────────────────┤
│ 🎛️ 系统控制                      │
│   🌙 深色模式               ○ ON │
│   🔊 输出设备       AirPods ▾    │
│   🔇 勿扰模式               ○    │
│   🔒 锁定屏幕                ›   │
├─────────────────────────────────┤
│ Ａ 输入 & 桌面                   │
│   Ａ 输入法 (中/英)            ›  │
│   🖥️ 桌面图标                ○   │
├─────────────────────────────────┤
│ ⚡ 快捷操作                      │
│   🗑️ 清空废纸篓               ›   │
│   📝 快速笔记 → Obsidian      ›   │
│   ⏰ 番茄钟                   ›   │
│   📋 剪贴板历史                ›   │
├─────────────────────────────────┤
│ 🌐 网络                          │
│   📶 Wi-Fi 热点名           ▼    │
├─────────────────────────────────┤
│ 🏃 一键场景                      │
│ [💼 工作] [🌙 深夜] [🎤 演示] [🚪 出门] │
├─────────────────────────────────┤
│ ⌨️ 全局快捷键     ⌥⌘Q            │
│  偏好设置                    退出 │
└─────────────────────────────────┘
```

---

## 🚀 功能

### 🎛️ 系统控制
| 功能 | 说明 |
|------|------|
| **深色模式** | 一键切换 Light / Dark |
| **音频输出** | 切换扬声器 / 耳机 / AirPods |
| **勿扰模式** | 开启/关闭专注模式 |
| **锁定屏幕** | 快速锁屏 |

### Ａ 输入 & 桌面
| 功能 | 说明 |
|------|------|
| **输入法切换** | 搜狗拼音/ABC 一键切换 |
| **桌面图标** | 隐藏/显示桌面图标（演示时有用） |

### ⚡ 快捷操作
| 功能 | 说明 |
|------|------|
| **清空废纸篓** | 一键清空 `~/.Trash/` |
| **快速笔记** | 弹出编辑器，保存到 Obsidian |
| **番茄钟** | 25min 专注 + 5min 休息 |
| **剪贴板历史** | 最近 20 条，点击即粘贴 |

### 🌐 网络
| 功能 | 说明 |
|------|------|
| **Wi-Fi 列表** | 扫描附近网络，显示信号强度 |
| **Wi-Fi 切换** | 点击连接，当前网络标识 |

### 🏃 一键场景
| 场景 | 动作 |
|------|------|
| 💼 **工作模式** | 打开 VSCode + Chrome + Terminal → 浅色模式 |
| 🌙 **深夜模式** | 深色模式 → 音量 20% → 关闭消息/Mail |
| 🎤 **演示模式** | 勿扰 → 隐藏桌面图标 → 深色模式 |
| 🚪 **出门模式** | 关应用 → 清废纸篓 → 锁屏 |

### ⌨️ 快捷键
| 快捷键 | 功能 |
|--------|------|
| `⌥⌘Q` | 全局唤出 QuickPanel（开发中） |

---

## 📦 安装

```bash
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

### 开机自启
`系统设置 → 通用 → 登录项 → + → QuickPanel.app`

### 权限
首次使用部分功能时会弹窗请求权限：
- **辅助功能** — 切换音频输出、锁屏、控制勿扰
- 前往 `系统设置 → 隐私与安全性 → 辅助功能` 允许

---

## 🏗️ 架构

```
macos-quick-panel/
├── Package.swift                 # SwiftPM 构建
├── Info.plist                    # LSUIElement = true
├── QuickPanel.icns               # App 图标
├── design/                       # 图标设计源 SVG
│   └── icon_v2.svg
├── scripts/
│   └── build.sh                  # 编译 + .app 打包
└── Sources/
    └── QuickPanel/
        ├── QuickPanelApp.swift   # @main + AppState
        ├── MenuBarContent.swift  # 面板 UI + 毛玻璃
        ├── Helpers/
        │   ├── SystemCommands.swift   # 系统命令
        │   ├── AudioManager.swift     # CoreAudio 音频
        │   ├── DoNotDisturb.swift     # 勿扰
        │   ├── ClipboardManager.swift # 剪贴板
        │   ├── WiFiManager.swift      # CoreWLAN Wi-Fi
        │   ├── InputMethodManager.swift # TIS 输入法
        │   ├── DesktopIconsManager.swift # 桌面图标
        │   └── HotkeyManager.swift    # 全局快捷键
        └── Features/
            ├── PomodoroTimer.swift
            ├── PomodoroView.swift
            ├── QuickNote.swift
            ├── ObsidianManager.swift
            ├── Macros.swift
            ├── ClipboardHistoryView.swift
            └── WiFiListView.swift
```

### 技术栈
| 层 | 技术 |
|----|------|
| **语言** | Swift 5.9+ |
| **UI** | SwiftUI MenuBarExtra + NSVisualEffectView |
| **音频** | CoreAudio API |
| **Wi-Fi** | CoreWLAN 框架 |
| **输入法** | Carbon TIS API |
| **快捷键** | Carbon Event HotKey |
| **系统** | Process (zsh) + AppleScript + DistributedNotificationCenter |
| **最低** | macOS 13.0 (Ventura) |
| **构建** | Swift Package Manager |

---

## 🗺️ 路线图

- [x] 系统控制（深色/音频/DND/锁屏）
- [x] 快捷操作（废纸篓/笔记/番茄钟/剪贴板）
- [x] 一键场景（工作/深夜/演示/出门）
- [x] 自定义 App 图标
- [x] Wi-Fi 扫描切换
- [x] 输入法切换（中/英）
- [x] 桌面图标隐藏/显示
- [x] 全局快捷键
- [x] 毛玻璃 UI
- [ ] 偏好设置窗口
- [ ] Night Shift 开关
- [ ] 自定义场景（用户编辑）
- [ ] Homebrew Cask 安装
- [ ] GitHub Releases + CI

---

## 🤝 贡献

欢迎 Issue / PR / Feature Request！

```bash
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
  <a href="README_EN.md">🇬🇧 English Version</a>
</p>
