# 🎨 Collective

> Your Visual Command Center for Creative Assets

**Collective** is a sleek, always-on-top desktop companion that transforms how you organize and access your creative materials. Built with Qt6 and QML, it's the elegant sidebar you didn't know you needed.

## ✨ What is Collective?

Imagine having all your inspiration, references, and creative assets at your fingertips—literally. Collective is a beautiful, frameless dock that lives on the edge of your screen, giving you instant access to images, music, videos, and PDFs without disrupting your workflow.

### 🚀 Key Features

- **🎯 Always There, Never Intrusive** - Stays on top of all windows while remaining elegantly minimal
- **🎵 Multi-Media Support** - Handle images, music files, videos, and PDFs with built-in previews
- **🌈 Workspace Collections** - Organize assets into emoji-labeled collections for different projects
- **⚡ Global Hotkeys** - Control everything without touching your mouse
  - `Alt+C` - Toggle visibility
  - `Alt+W` - Close all preview windows
  - `Alt+X` - Close unfocused windows
- **💾 Auto-Save** - Your collections are automatically saved every 10 seconds
- **🎨 Smart Edge Snapping** - Magnetically snaps to screen edges with smooth animations
- **🎭 Beautiful Previews** - Rich preview windows with music player, waveforms, and image zoom
- **📌 Drag & Drop** - Simply drop files to add them to your collection
- **🎪 System Tray Integration** - Minimize to tray and recall with a click

## 🎬 Perfect For

- **Designers** - Keep reference images and mood boards instantly accessible
- **Musicians** - Quick access to samples, loops, and project audio
- **Writers** - Organize research PDFs and reference materials
- **Content Creators** - Manage assets across multiple projects
- **Anyone** who works with visual or audio media

## 🛠️ Built With

- **Qt6** - Cross-platform C++ framework
- **QML** - Fluid, modern UI
- **Qt Multimedia** - Rich media playback
- **QHotkey** - Global keyboard shortcuts
- **CMake** - Build system

## 📋 Requirements

- Qt 6.8 or higher
- CMake 3.16 or higher
- C++17 compatible compiler

## 🚀 Getting Started

### Building from Source

```bash
# Clone the repository
git clone <repository-url>
cd collective

# Build the project
mkdir build && cd build
cmake ..
cmake --build .

# Run
./appcollective
```

### Quick Start on Linux
```bash
./run.sh
```

### Quick Start on Windows
```powershell
.\build.ps1
```

## 🎯 How It Works

1. **Launch Collective** - The sidebar appears on your desktop
2. **Drag & Drop** - Add any supported file to your collection
3. **Create Workspaces** - Use emoji labels to organize different projects
4. **Preview & Play** - Click any asset for a beautiful preview window
5. **Switch Collections** - Instantly swap between different workspace collections
6. **Global Control** - Use hotkeys to show/hide without context switching

## 🎨 UI Highlights

- **Frameless Design** - Clean, modern aesthetic
- **Edge-Aware Resizing** - Resize from the edge away from the screen border
- **Smooth Animations** - Polished transitions and interactions
- **Dark Theme** - Easy on the eyes during long creative sessions
- **Custom Fonts** - Includes SH Ad Grotesk and Cal Sans for typography nerds

## 🔮 What Makes It Special

Collective isn't just another file manager—it's a **creative workspace enhancer**. By keeping your assets visible and accessible without cluttering your desktop, it creates a seamless bridge between inspiration and execution. Whether you're designing, composing, writing, or creating, Collective becomes your personal assistant that's always just one click (or hotkey) away.

## 📁 Project Structure

```
collective/
├── src/           # C++ backend (utilities, media player, providers)
├── qml/           # QML UI components
├── assets/        # Icons, fonts, and visual resources
├── third_party/   # External dependencies (qhotkey)
├── packaging/     # Distribution files
└── build/         # Build output directory
```

## 🤝 Contributing

Contributions are welcome! Whether it's bug fixes, feature additions, or documentation improvements, feel free to submit a pull request.

## 🌟 Acknowledgments

- Built with Qt6 Framework
- QHotkey library for global shortcuts
- Custom fonts: SH Ad Grotesk & Cal Sans

---

**Collective** - *Where creativity meets organization*
