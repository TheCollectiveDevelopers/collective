# Collective

Collective is a dock for designers. Put all your references in one place for easy access.

## Features

- **Visual Reference Management**: Store and organize images, videos, and other media files
- **Quick Access**: Global hotkeys for instant access to your reference library
- **Music Player**: Built-in audio player with waveform visualization
- **Workspace Switching**: Organize references across different workspaces
- **Emoji Picker**: Quick emoji selection for your workflow

## Requirements

- **Qt 6.8+** (Qml, Quick, Widgets, Core, Multimedia, DBus)
- **CMake 3.16+**
- **C++ compiler** with C++17 support

## Build Instructions

```sh
git clone --recurse-submodules https://github.com/TheCollectiveDevelopers/collective.git
mkdir collective/build && cd collective/build
cmake ..
cmake --build .
```

The executable will either be placed in the build directory or in a Debug directory.

## Keyboard Shortcuts

- **Alt+C**: Toggle visibility
- **Alt+W**: Close all preview windows

## License

This project is licensed under the GNU General Public License v3.0. See [LICENSE.md](LICENSE.md) for details.

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.
