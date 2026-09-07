pragma Singleton

import Quickshell
import QtQuick

// Tokyo Night (night variant) palette: https://github.com/folke/tokyonight.nvim
Singleton {
  readonly property color bg0: "#1a1b26" // bg
  readonly property color bg1: "#292e42" // bg_highlight
  readonly property color bg2: "#414868" // terminal_black
  readonly property color bg3: "#545c7e" // dark3
  readonly property color bg4: "#737aa2" // dark5

  readonly property color fg0: "#c0caf5" // fg
  readonly property color fg1: "#a9b1d6" // fg_dark
  readonly property color fg2: "#737aa2" // dark5
  readonly property color fg3: "#565f89" // comment
  readonly property color fg4: "#545c7e" // dark3

  readonly property color red: "#f7768e"
  readonly property color green: "#9ece6a"
  readonly property color yellow: "#e0af68"
  readonly property color blue: "#7aa2f7"
  readonly property color purple: "#9d7cd8"
  readonly property color aqua: "#7dcfff" // cyan
  readonly property color orange: "#ff9e64"
  readonly property color gray: "#565f89" // comment

  readonly property color accent: blue
}
