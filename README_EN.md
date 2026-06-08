<p align="center">
  <img src="design/icon_v2.svg" width="120" alt="QuickPanel Logo" />
</p>

<h1 align="center">QuickPanel</h1>

<p align="center">
  <strong>macOS Menu Bar Quick Control Panel</strong><br />
  <code>⌥⌘P</code> to open · Features Apple Control Center doesn't have
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
  <a href="#-features">Features</a> ·
  <a href="#-preview">Preview</a> ·
  <a href="#-install">Install</a> ·
  <a href="#-dual-entry">Dual Entry</a>
</p>

---

**QuickPanel** is a lightweight macOS toolbox with features **Apple's Control Center doesn't have**. Access via menu bar icon or global hotkey `⌥⌘P`.

> 🆓 Free · 🧩 Open Source (MIT) · ⚡ ~800KB · 🔒 100% Local

---

## 🎯 Features

| Category | Feature | Description |
|----------|---------|-------------|
| 🧠 | **DeepSeek Balance** | Hero header with large balance, color-coded |
| 🖼️ | **Screenshot** | Region / Window / Fullscreen / Clipboard |
| 🪟 | **Window Layout** | Left / Right / Fullscreen / Center |
| ☕ | **Caffeinate** | Keep Mac awake toggle |
| 👁️ | **Hidden Files** | Show/hide hidden Finder files |
| 🔒 | **Lock Screen** | One-click lock |
| 🗑️ | **Empty Trash** | Quick cleanup |
| ⌨️ | **IME Toggle** | Sogou Pinyin / ABC |
| 🖥️ | **Desktop Icons** | Hide/show |
| 📝 | **Quick Note** | Save to Obsidian inbox |
| ⏰ | **Pomodoro** | 25min / 5min timer |
| 📋 | **Clipboard History** | Last 20 items, click to paste |
| 🧹 | **Clear Clipboard** | One-click clear |
| 🏃 | **One-Click Scenes** | Work / Night / Presentation / Leaving |
| 📦 | **In-App Updates** | Check & install from GitHub |

---

## 📸 Preview

```
┌──────────────────────────────────────┐
│ 🧠 DeepSeek          Connected  🔄   │  ← Hero header
│   41.64  CNY                         │  ← Large balance
│   Top-up 41.64   Gift 0.00           │
│                          Updated 06/07│
├──────────────────────────────────────┤
│ 🔍 QuickPanel              ⌥⌘P      │
├──────────────────────────────────────┤
│ Ａ Input & Desktop                    │
│   Ａ IME (中文/English)           ›  │
│   🖥️ Desktop Icons              ○   │
├──────────────────────────────────────┤
│ ⚡ Quick Actions                       │
│   🔒 Lock Screen                 ›  │
│   🗑️ Empty Trash                ›   │
│   📝 Note → Obsidian            ›   │
│   ⏰ Pomodoro                   ›   │
│   📋 Clipboard (3)  🧹       ▼     │
├──────────────────────────────────────┤
│ 🖼️ Screenshot                         │
│ [Region] [Window] [Full] [Clipboard]  │
├──────────────────────────────────────┤
│ 🪟 Window Layout                       │
│ [◧Left] [◨Right] [⛶Full] [⬡Center]  │
├──────────────────────────────────────┤
│ 🛠️ System Tools                       │
│ ☕ Caffeinate                    ○   │
│ 👁️ Hidden Files                 ○   │
├──────────────────────────────────────┤
│ 🏃 One-Click Scenes                   │
│ [💼Work] [🌙Night] [🎤Present] [🚪Leave]│
├──────────────────────────────────────┤
│ ⚙️ Preferences    ⌥⌘P         Quit   │
└──────────────────────────────────────┘
```

---

## 🏗️ Dual Entry

| Method | Action | Feature |
|--------|--------|---------|
| ▦ **Menu Bar** | Click icon for dropdown | Quick access, no screen space |
| ⌥⌘P **Hotkey** | Global shortcut | Floating panel, position memory |

---

## 📦 Install

```bash
# Option 1: Download Release
# https://github.com/YunhaoDou/macos-quick-panel/releases
# Open .dmg → drag to Applications

# Option 2: Build from source
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

---

## ⚙️ Preferences

| Setting | Description |
|---------|-------------|
| **DeepSeek API Key** | Input + test, auto-reads from `~/.hermes/.env` |
| **Obsidian Vault** | Quick note save directory |
| **Launch at Login** | Auto-start |
| **Check Updates** | GitHub Release check |

---

## ✅ vs Control Center

| Feature | QuickPanel | Control Center |
|---------|-----------|----------------|
| Screenshot | ✅ | ❌ |
| Window Layout | ✅ | ❌ |
| Caffeinate | ✅ | ❌ |
| Hidden Files | ✅ | ❌ |
| Lock Screen | ✅ | ❌ |
| Empty Trash | ✅ | ❌ |
| IME Toggle | ✅ | ❌ |
| Desktop Icons | ✅ | ❌ |
| Quick Note | ✅ | ❌ |
| Pomodoro | ✅ | ❌ |
| Clipboard History | ✅ | ❌ |
| One-Click Scenes | ✅ | ❌ |
| DeepSeek Balance | ✅ | ❌ |
| In-App Update | ✅ | ❌ |
| Dark/Audio/DND | ❌ via Control Center | ✅ |

---

## 🏗️ Architecture

```
Sources/QuickPanel/
├── QuickPanelApp.swift       # @main + AppState
├── MenuBarContent.swift      # Menu bar panel UI
├── PanelManager.swift        # Floating panel (NSPanel)
├── Helpers/ (10 modules)
└── Features/ (6 modules)
```

**Tech:** Swift 5.9+ · SwiftUI · NSPanel · NSVisualEffectView · CoreWLAN · Carbon HotKey · DeepSeek API

---

## 📄 License

[MIT License](LICENSE) © 2025 YunhaoDou

<p align="center">
  <a href="README.md">🇨🇳 中文</a>
</p>
