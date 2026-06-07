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
  <a href="#-features">Features</a> ·
  <a href="#-install">Install</a> ·
  <a href="#-usage">Usage</a> ·
  <a href="#-comparison">Comparison</a> ·
  <a href="#-architecture">Architecture</a> ·
  <a href="#-roadmap">Roadmap</a>
</p>

---

**QuickPanel** is a lightweight, open-source, free macOS menu bar toolbox. Click the menu bar icon to quickly control system settings, perform common actions, or switch between work/life scenes with one click.

> 🆓 Free · 🧩 Open Source (MIT) · ⚡ 800KB · 🔒 100% Local (no network)

> 🇨🇳 中文版: [README.md](README.md)

---

## 📸 Preview

```
┌─────────────────────────────────┐
│ 🔍 Search files / Apps…  ⌥⌘Q   │
├─────────────────────────────────┤
│ 🎛️ System Controls               │
│   🌙 Dark Mode              ○ ON │
│   🔊 Output          AirPods ▾   │
│   🔇 Do Not Disturb         ○    │
│   🔒 Lock Screen             ›   │
├─────────────────────────────────┤
│ Ａ Input & Desktop               │
│   Ａ IME (中文/English)       ›   │
│   🖥️ Desktop Icons           ○   │
├─────────────────────────────────┤
│ ⚡ Quick Actions                  │
│   🗑️ Empty Trash              ›   │
│   📝 Quick Note → Obsidian    ›   │
│   ⏰ Pomodoro Timer           ›   │
│   📋 Clipboard History        ›   │
├─────────────────────────────────┤
│ 🌐 Network                       │
│   📶 Current Wi-Fi ▼             │
├─────────────────────────────────┤
│ 🏃 One-Click Scenes              │
│ [💼 Work] [🌙 Night] [🎤 Present] [🚪 Leave] │
├─────────────────────────────────┤
│ ⌨️ Global Shortcut   ⌥⌘Q        │
│  Preferences               Quit │
└─────────────────────────────────┘
```

---

## 🚀 Features

### 🎛️ System Controls
| Feature | Description |
|---------|-------------|
| **Dark Mode** | Toggle Light/Dark appearance |
| **Audio Output** | Switch speakers/headphones/AirPods |
| **Do Not Disturb** | Toggle Focus mode |
| **Lock Screen** | Quick lock via CGSession |

### Ａ Input & Desktop
| Feature | Description |
|---------|-------------|
| **IME Toggle** | Switch between Sogou Pinyin / ABC |
| **Desktop Icons** | Hide/show desktop icons (useful for presentations) |

### ⚡ Quick Actions
| Feature | Description |
|---------|-------------|
| **Empty Trash** | One-click `~/.Trash/` cleanup |
| **Quick Note** | Save notes to Obsidian inbox |
| **Pomodoro** | 25min focus + 5min break timer |
| **Clipboard History** | Last 20 clipboard items, click to paste |

### 🌐 Network
| Feature | Description |
|---------|-------------|
| **Wi-Fi Scanner** | Scan nearby networks with signal bars |
| **Wi-Fi Switch** | Click to connect, current network labeled |

### 🏃 One-Click Scenes
| Scene | Actions |
|-------|---------|
| 💼 **Work** | Open VSCode + Chrome + Terminal → Light mode |
| 🌙 **Night** | Dark mode → Volume 20% → Close Mail/Messages |
| 🎤 **Presentation** | DND → Hide desktop icons → Dark mode |
| 🚪 **Leaving** | Close apps → Empty trash → Lock screen |

All scene actions are customizable in `Sources/QuickPanel/Features/Macros.swift`.

### ⌨️ Shortcuts
| Shortcut | Action |
|----------|--------|
| `⌥⌘Q` | Global QuickPanel toggle (WIP) |

---

## 📦 Install

```bash
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

### Launch on Login
`System Settings → General → Login Items → + → QuickPanel.app`

### Permissions
When first using certain features, macOS may prompt for:
- **Accessibility** — required for audio switching, lock screen, DND
  - Grant at `System Settings → Privacy & Security → Accessibility`

---

## 📊 Comparison

| Dimension | QuickPanel | One Switch | Raycast | Alfred Powerpack | Bartender |
|-----------|-----------|-----------|---------|-----------------|-----------|
| **Price** | 🆓 Free | ¥38 | Free / ¥93 Pro | ¥299 | ¥78 |
| **Open Source** | ✅ MIT | ❌ | ❌ | ❌ | ❌ |
| **Menu Bar** | ✅ Always | ✅ | ❌ Launcher | ❌ Launcher | ✅ Icon mgmt |
| **Dark Mode** | ✅ One-click | ✅ One-click | Needs plugin | Needs workflow | ❌ |
| **Audio Switch** | ✅ Dropdown | ❌ | Needs plugin | Needs workflow | ❌ |
| **Scene Macros** | ✅ 4 built-in | ❌ | ❌ | ✅ Customizable | ❌ |
| **Pomodoro** | ✅ Built-in | ❌ | Needs plugin | ❌ | ❌ |
| **Wi-Fi** | ✅ Scan+switch | ❌ | ❌ | ❌ | ❌ |
| **IME Toggle** | ✅ CN/EN | ❌ | ❌ | ❌ | ❌ |
| **Clipboard** | ✅ 20 items | ❌ | ✅ Powerful | ✅ Powerful | ❌ |
| **Quick Note** | ✅ Obsidian | ❌ | ✅ Plugin | ✅ Snippet | ❌ |
| **Size** | ~800KB | ~5MB | ~50MB | ~30MB | ~10MB |

### vs One Switch
The closest competitor. QuickPanel is free & open-source, adding Pomodoro/Clipboard/Wi-Fi/IME/Scene Macros. One Switch has hide desktop icons, Night Shift, screensaver — coming to QuickPanel soon.

### vs Raycast
**They complement each other.** Raycast needs a keyboard shortcut (good for keyboard power users). QuickPanel lives in the menu bar (good for mouse/trackpad users). QuickPanel's scenes and pomodoro work out of the box — Raycast needs plugins.

---

## 🏗️ Architecture

```
macos-quick-panel/
├── Package.swift                 # SwiftPM build config
├── Info.plist                    # LSUIElement = true
├── QuickPanel.icns               # App icon
├── design/                       # SVG design sources
│   └── icon_v2.svg
├── scripts/
│   └── build.sh                  # Build + .app packaging
└── Sources/
    └── QuickPanel/
        ├── QuickPanelApp.swift   # @main entry + AppState
        ├── MenuBarContent.swift  # Panel UI + frosted glass
        ├── Helpers/
        │   ├── SystemCommands.swift
        │   ├── AudioManager.swift     # CoreAudio
        │   ├── DoNotDisturb.swift
        │   ├── ClipboardManager.swift
        │   ├── WiFiManager.swift      # CoreWLAN
        │   ├── InputMethodManager.swift # TIS
        │   ├── DesktopIconsManager.swift
        │   └── HotkeyManager.swift    # Carbon hotkey
        └── Features/
            ├── PomodoroTimer.swift
            ├── PomodoroView.swift
            ├── QuickNote.swift
            ├── ObsidianManager.swift
            ├── Macros.swift
            ├── ClipboardHistoryView.swift
            └── WiFiListView.swift
```

### Tech Stack
| Layer | Technology |
|-------|-----------|
| **Language** | Swift 5.9+ |
| **UI** | SwiftUI MenuBarExtra + NSVisualEffectView |
| **Audio** | CoreAudio API |
| **Wi-Fi** | CoreWLAN framework |
| **IME** | Carbon TIS API |
| **Hotkey** | Carbon Event HotKey |
| **System** | Process (zsh) + AppleScript |
| **Minimum** | macOS 13.0 (Ventura) |
| **Build** | Swift Package Manager |

---

## 🗺️ Roadmap

- [x] System controls (dark/audio/DND/lock)
- [x] Quick actions (trash/note/pomodoro/clipboard)
- [x] One-click scenes (work/night/presentation/leaving)
- [x] Custom app icon
- [x] Wi-Fi scan & switch
- [x] IME toggle (CN/EN)
- [x] Desktop icons hide/show
- [x] Global hotkey
- [x] Frosted glass UI
- [ ] Preferences window
- [ ] Night Shift toggle
- [ ] Custom scenes (user editable)
- [ ] Homebrew Cask install
- [ ] GitHub Releases + CI

---

## 🤝 Contributing

Issues, PRs, and Feature Requests are welcome!

```bash
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

---

## 📄 License

[MIT License](LICENSE) © 2025 YunhaoDou

---

<p align="center">
  <a href="README.md">🇨🇳 中文版</a>
</p>
