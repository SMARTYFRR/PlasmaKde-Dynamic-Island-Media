<div align="center">

<img src="Di_logo.png" width="128" alt="Dynamic Island Media Logo">

# Dynamic Island Media for KDE Plasma 6

A lightweight, media-focused Dynamic Island capsule for the KDE Plasma panel.

Shows your currently playing track, album art, and live animated sound bars with zero background CPU overhead.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Plasma 6](https://img.shields.io/badge/Plasma-6-1d99f3.svg)
![Qt 6](https://img.shields.io/badge/Qt-6-41cd52.svg)

</div>

---

## 🎵 What is Dynamic Island Media?

**Dynamic Island Media** is a streamlined media capsule for KDE Plasma 6 designed specifically for users who want an aesthetic, ultra-lightweight media capsule on their panel without intrusive popups or background system polling.

* **Compact Capsule Only:** Displays album cover, track title, and real-time audio visualizer sound bars directly on your panel.
* **No Expanded Popup:** Non-intrusive design—clicks will not open extra popup menus, making it ideal if you already use dedicated music or lyrics widgets.
* **Zero Idle CPU Overhead:** All background system monitoring, clock timers, notification listeners, and sensors have been completely stripped out.
* **MPRIS Integration:** Supports Spotify, VLC, Firefox, Chrome, Celluloid, Audacious, and any MPRIS2-compatible player.
* **Mouse Wheel Controls:** Scroll over the capsule to adjust volume or skip tracks.

---

## ✨ Features

* **Album Artwork & Fallback Icons:** Displays live album art from the active player or a clean music icon.
* **Animated Sound Bars:** Custom visualizer bars that scale dynamically during media playback.
* **Theme & Accent Color Customization:** Follows your desktop theme colors or lets you set custom accent highlights and animation speeds.
* **Responsive Capsule Sizing:** Dynamically adjusts its width based on track title length.

---

## 🛠️ Installation

### Automatic Install / Update

Run the included install script:

```bash
git clone https://github.com/anshatetheapples/Dynamic-Island-Media.git
cd Dynamic-Island-Media
./install.sh
```

### Standalone Testing

To test the widget in a standalone test window without adding it to your panel:

```bash
plasmawindowed com.anshatetheapples.dynamicisland.media
```

### Add to Plasma Panel

1. Right-click on your KDE Plasma panel or desktop.
2. Select **Add Widgets...**
3. Search for **Dynamic Island Media** and drag it onto your panel.

---

## 📋 Requirements

* **KDE Plasma:** 6.0+
* **Qt:** 6.x

---

## 📜 License

* Created by **anshatetheapples**
* Released under the [MIT License](LICENSE).
