cmake_minimum_required(VERSION 3.16)

project(collective VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Qml Quick Widgets Core Multimedia DBus)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
qt_standard_project_setup(REQUIRES 6.8)

add_subdirectory(third_party/qhotkey)

set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/assets/app.rc")
qt_add_executable(appcollective
    main.cpp
    ${app_icon_resource_windows}
)

qt_add_qml_module(appcollective
    URI collective
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/ImageList.qml
        qml/PreviewWindow.qml
        qml/WorkspaceSwitcher.qml
        qml/EmojiPickerWindow.qml
        qml/CollectiveDialog.qml
        qml/ImageListThumbnail.qml
        qml/MusicPreview.qml
        qml/MiniWaveform.qml
        qml/RecordPlayerWindow.qml
    SOURCES
        src/utils.h
        src/utils.cpp
        src/mediaPlayer.h
        src/mediaPlayer.cpp
        src/mediaImageProvider.h
        src/mediaImageProvider.cpp
    RESOURCES
        assets/icon.png
        assets/drag.png
        assets/lock-white.png
        assets/lock-yellow.png
        assets/refresh-white.png
        assets/refresh-yellow.png
        assets/x-white.png
        assets/zoom-white.png
        assets/drop-white.png
        assets/drop-yellow.png
        assets/reflect-white.png
        assets/reflect-yellow.png
        assets/plus.png
        qml/emojis.js
        assets/sh-ad-grotesk.ttf
        assets/calsans.ttf
        assets/music-player.gif
        assets/disk.png
        assets/play.png
        assets/skip-back.png
        assets/skip-forward.png
        assets/volume.png
        assets/pause.png
        assets/switch.png
        assets/clipboard.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appcollective PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appcollective
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    #WIN32_EXECUTABLE TRUE
)

target_include_directories(appcollective PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src)

if(DEFINED ENV{USE_PAID_VERSION})
  set(USE_PAID_DEFAULT "$ENV{USE_PAID_VERSION}")
else()
  set(USE_PAID_DEFAULT "OFF")
endif()

if(NOT DEFINED USE_PAID_VERSION)
  set(USE_PAID_VERSION "${USE_PAID_DEFAULT}" CACHE BOOL "Use paid version" FORCE)
endif()

option(USE_PAID_VERSION "Build with paid version features" OFF)


if(USE_PAID_VERSION)
  target_compile_definitions(appcollective PRIVATE PAID_VERSION)
else()
  target_compile_definitions(appcollective PRIVATE FREE_VERSION)
endif()

target_link_libraries(appcollective
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Widgets
    PRIVATE Qt6::Core
    PRIVATE Qt6::Multimedia
    PRIVATE Qt6::Qml
    PRIVATE Qt6::DBus
    PRIVATE qhotkey
)
include(GNUInstallDirs)
install(TARGETS appcollective
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
