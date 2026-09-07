pragma Singleton

import Quickshell
import QtQuick

// Catppuccin Mocha palette: https://github.com/catppuccin/catppuccin
Singleton {
  readonly property color bg0: "#1e1e2e" // base
  readonly property color bg1: "#313244" // surface0
  readonly property color bg2: "#45475a" // surface1
  readonly property color bg3: "#585b70" // surface2
  readonly property color bg4: "#6c7086" // overlay0

  readonly property color fg0: "#cdd6f4" // text
  readonly property color fg1: "#bac2de" // subtext1
  readonly property color fg2: "#a6adc8" // subtext0
  readonly property color fg3: "#9399b2" // overlay2
  readonly property color fg4: "#7f849c" // overlay1

  readonly property color red: "#f38ba8"
  readonly property color green: "#a6e3a1"
  readonly property color yellow: "#f9e2af"
  readonly property color blue: "#89b4fa"
  readonly property color purple: "#cba6f7" // mauve
  readonly property color aqua: "#94e2d5" // teal
  readonly property color orange: "#fab387" // peach
  readonly property color gray: "#6c7086" // overlay0

  readonly property color accent: purple
}
