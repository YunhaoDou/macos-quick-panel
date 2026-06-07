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
  <a href="#-dual-entry">Dual Entry</a> ·
  <a href="#-install">Install</a> ·
  <a href="#-vs-control-center">vs Control Center</a>
</p>

---

**QuickPanel** is a lightweight macOS toolbox. It provides features **Apple's Control Center doesn't have**, accessible via both the menu bar icon and the global hotkey `⌥⌘P`.

> 🆓 Free · 🧩 Open Source (MIT) · ⚡ ~800KB · 🔒 100% Local

---

## 🎯 Features

**Only what Control Center can't do:**

| Category | Feature | Description |
|----------|---------|-------------|
| 🖼️ | **Screenshot** | Region / Window / Fullscreen / Clipboard |
| 🪟 | **Window Layout** | Left / Right / Fullscreen / Center |
| ☕ | **Caffeinate** | Keep Mac awake toggle |
| 👁️ | **Hidden Files** | Show/hide hidden Finder files |
| 🔒 | **Lock Screen** | One-click lock via ScreenSaverEngine |
| 🗑️ | **Empty Trash** | Quick cleanup |
| ⌨️ | **IME Toggle** | Switch between Sogou Pinyin / ABC |
| 🖥️ | **Desktop Icons** | Hide/show desktop icons |
| 📝 | **Quick Note** | Save to Obsidian inbox |
| ⏰ | **Pomodoro** | 25min focus / 5min break timer |
| 📋 | **Clipboard History** | Auto-captures last 20 items, click to paste |
| 🧹 | **Clear Clipboard** | One-click clear + history |
| 🏃 | **One-Click Scenes** | Work / Night / Presentation / Leaving |
| 📦 | **In-App Updates** | Check & install from GitHub Releases |

---

## 🏗️ Dual Entry

QuickPanel opens two ways:

```
┌─────────────────────────────────────┐
│ Menu Bar Icon                        │
│ Click ▦ in menu bar                  │
│ Dropdown panel, quick access         │
├─────────────────────────────────────┤
│ ⌥⌘P Global Hotkey                    │
│ Floating panel window                │
│ Draggable, remembers position        │
│ Great for pomodoro & long tasks      │
└─────────────────────────────────────┘
```

> `⌥⌘P` doesn't conflict with any macOS system shortcuts or common app shortcuts.

---

## 📸 Panel Preview

### Menu Bar Mode
```
┌────────────────────────────────────┐
│ 🔍 QuickPanel                      │
├────────────────────────────────────┤
│ Ａ Input & Desktop                  │
│   Ａ IME (中文/English)          ›  │
│   🖥️ Desktop Icons             ○   │
├────────────────────────────────────┤
│ ⚡ Quick Actions                     │
│   🔒 Lock Screen                ›  │
│   🗑️ Empty Trash               ›   │
│   📝 Note → Obsidian           ›   │
│   ⏰ Pomodoro                  ›   │
│   📋 Clipboard (3)  🧹     ▼      │
├────────────────────────────────────┤
│ 🖼️ Screenshot                       │
│ [Region] [Window] [Full] [Clipbrd]  │
├────────────────────────────────────┤
│ 🪟 Window Layout                     │
│ [◧Left] [◨Right] [⛶Full] [⬡Center] │
├────────────────────────────────────┤
│ 🛠️ System Tools                     │
│ ☕ Caffeinate                   ○   │
│ 👁️ Hidden Files                ○   │
├────────────────────────────────────┤
│ 🏃 One-Click Scenes                 │
│ [💼Work] [🌙Night] [🎤Present] [🚪Leave]│
├────────────────────────────────────┤
│ ⚙️ Preferences    ⌥⌘P         Quit │
└────────────────────────────────────┘
```

### Floating Panel Mode (⌥⌘P)
Same content as menu bar, but as a floating window:
- Drag anywhere, remembers position
- Shows `⌥⌘P` / Hide in footer
- Header with QuickPanel title + feedback toast

---

## 📦 Install

### Option 1: Download Release (recommended)

```bash
https://github.com/YunhaoDou/macos-quick-panel/releases

# Open .dmg → drag to Applications
# First time: right-click → Open
```

### Option 2: Build from source

```bash
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

### Launch on Login

`System Settings → General → Login Items → + → QuickPanel.app`

---

## ⚙️ Preferences

Click ⚙️ in the footer:

| Setting | Description |
|---------|-------------|
| **Obsidian Vault** | Set note save directory (browse supported) |
| **Launch at Login** | Auto-start on login |
| **Global Hotkey** | Current: `⌥⌘P` |
| **Check Updates** | Auto-detect latest GitHub Release |

---

## ✅ vs Control Center

| Feature | QuickPanel | Control Center |
|---------|-----------|----------------|
| Screenshot (region/window/full) | ✅ | ❌ |
| Window layout (left/right/full/center) | ✅ | ❌ |
| Caffeinate (keep awake) | ✅ | ❌ |
| Finder hidden files toggle | ✅ | ❌ |
| Lock screen | ✅ | ❌ |
| Empty trash | ✅ | ❌ |
| IME toggle (CN/EN) | ✅ | ❌ |
| Hide desktop icons | ✅ | ❌ |
| Quick note (Obsidian) | ✅ | ❌ |
| Pomodoro timer | ✅ | ❌ |
| Clipboard history | ✅ | ❌ |
| One-click scenes (4 modes) | ✅ | ❌ |
| ⌥⌘P hotkey to open | ✅ | ❌ |
| In-app auto updater | ✅ | ❌ |
| Dark mode | ❌ — provided by Control Center | ✅ |
| Audio output | ❌ — provided by Control Center | ✅ |
| Do Not Disturb | ❌ — provided by Control Center | ✅ |

---

## 🏗️ Architecture

```
macos-quick-panel/
├── Package.swift                 # SwiftPM config
├── Info.plist                    # LSUIElement = true
├── QuickPanel.icns               # App icon (1.4MB)
├── design/icon_v2.svg            # Icon design source
├── scripts/
│   ├── build.sh                  # Build + .app packaging
│   └── create-dmg.sh             # DMG installer creation
└── Sources/QuickPanel/
    ├── QuickPanelApp.swift       # @main + AppState
    ├── MenuBarContent.swift      # Menu bar panel UI
    ├── PanelManager.swift        # Floating panel (NSPanel)
    ├── Helpers/
    │   ├── SystemCommands.swift
    │   ├── ClipboardManager.swift
    │   ├── InputMethodManager.swift   # TIS
    │   ├── DesktopIconsManager.swift
    │   ├── ScreenshotManager.swift    # screencapture
    │   ├── WindowManager.swift        # AppleScript
    │   ├── CaffeinateManager.swift    # caffeinate
    │   ├── FinderHiddenFilesManager.swift
    │   ├── HotkeyManager.swift        # Carbon
    │   ├── AppUpdater.swift           # In-app updates
    │   └── SettingsStore.swift        # UserDefaults
    └── Features/
        ├── PomodoroView.swift
        ├── QuickNote.swift
        ├── ObsidianManager.swift
        ├── Macros.swift
        ├── ClipboardHistoryView.swift
        └── PreferencesView.swift
```

### Tech Stack

| Layer | Technology |
|-------|-----------|
| **Language** | Swift 5.9+ |
| **UI** | SwiftUI MenuBarExtra + NSPanel + NSVisualEffectView |
| **Screenshot** | `screencapture` CLI |
| **Window mgmt** | AppleScript (System Events) |
| **IME** | Carbon TIS API |
| **Hotkey** | Carbon Event HotKey |
| **System** | Process (zsh) + AppleScript |
| **Minimum** | macOS 13.0 (Ventura) |
| **Build** | Swift Package Manager · ad-hoc signed |

---

## 🗺️ Roadmap

- [x] Quick actions (lock/trash/note/pomodoro/clipboard)
- [x] IME toggle + desktop icons
- [x] Screenshot + window layout
- [x] Caffeinate + hidden files
- [x] One-click scenes (4 modes)
- [x] Frosted glass UI (NSVisualEffectView)
- [x] Feedback toast
- [x] Global hotkey ⌥⌘P
- [x] Dual entry (menu bar + floating panel)
- [x] Preferences + in-app updater
- [ ] Custom scenes (user editable)
- [ ] Homebrew Cask install
- [ ] GitHub Actions CI

---

## 🤝 Contributing

```bash
git clone https://github.com/YunhaoDou/macos-quick-panel.git
cd macos-quick-panel
bash scripts/build.sh
open dist/QuickPanel.app
```

Issues, PRs, and Feature Requests are welcome!

---

## 📄 License

[MIT License](LICENSE) © 2025 YunhaoDou

<p align="center">
  <a href="README.md">🇨🇳 中文</a>
</p>
