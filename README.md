# QuickPanel

macOS 菜单栏快捷操作面板 — 系统控制 + 效率增强 + 一键场景切换

![macOS 13.0+](https://img.shields.io/badge/macOS-13.0+-blue) ![Swift 5.9+](https://img.shields.io/badge/Swift-5.9+-orange) ![MIT](https://img.shields.io/badge/License-MIT-green)

## 功能

### 🎛️ 系统控制
- **深色模式** — 一键切换 Light/Dark
- **音频输出** — 切换扬声器/耳机/AirPods
- **勿扰模式** — 开启/关闭专注
- **锁定屏幕** — 快速锁屏

### ⚡ 快捷操作
- **🗑️ 清空废纸篓**
- **📝 快速笔记** — 保存到 Obsidian 收件箱
- **⏰ 番茄钟** — 25min 专注 + 5min 休息
- **📋 剪贴板历史** — 最近 20 条记录，点击即粘贴

### 🏃 一键场景
| 场景 | 动作 |
|------|------|
| 💼 **工作模式** | 打开 VSCode + Chrome + Terminal，浅色模式 |
| 🌙 **深夜模式** | 深色模式 + 音量 20%，关消息/Mail |
| 🎤 **演示模式** | 勿扰 + 隐藏桌面图标 + 深色模式 |
| 🚪 **出门模式** | 关应用 → 清废纸篓 → 锁屏 |

## 安装

```bash
# 1. 克隆仓库
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel

# 2. 构建并打包
bash scripts/build.sh

# 3. 运行
open dist/QuickPanel.app

# 或拖到 Applications 目录，添加到登录项
```

> **首次运行**：在 `系统设置 → 隐私与安全性 → 辅助功能` 中允许 QuickPanel。

## 构建

```bash
# Debug 构建 + .app 打包
bash scripts/build.sh

# Release 构建
bash scripts/build.sh --release
```

## 自定义

### Obsidian 笔记路径
编辑 `Sources/QuickPanel/Features/ObsidianManager.swift` 中的 `vaultPath`，或通过菜单设置。

### 场景动作
编辑 `Sources/QuickPanel/Features/Macros.swift` 调整各场景触发的命令。

## 技术栈

- **语言**: Swift 5.9+
- **框架**: SwiftUI + AppKit + CoreAudio
- **最低版本**: macOS 13.0 (Ventura)
- **构建**: Swift Package Manager
- **打包**: 手动生成 .app bundle + 自签名

## 许可证

MIT
