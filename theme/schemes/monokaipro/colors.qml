pragma Singleton

import Quickshell
import QtQuick

// Monokai Pro (default "Pro" filter) palette: https://monokai.pro/
Singleton {
  readonly property color bg0: "#2d2a2e"
  readonly property color bg1: "#403e41" // dimmed5
  readonly property color bg2: "#5b595c" // dimmed4
  readonly property color bg3: "#727072" // dimmed3
  readonly property color bg4: "#939293" // dimmed2

  readonly property color fg0: "#fcfcfa" // text
  readonly property color fg1: "#c1c0c0" // dimmed1
  readonly property color fg2: "#939293" // dimmed2
  readonly property color fg3: "#727072" // dimmed3
  readonly property color fg4: "#5b595c" // dimmed4

  readonly property color red: "#ff6188" // accent1
  readonly property color green: "#a9dc76" // accent4
  readonly property color yellow: "#ffd866" // accent3
  readonly property color blue: "#78dce8" // accent5
  readonly property color purple: "#ab9df2" // accent6
  readonly property color aqua: "#78dce8" // accent5
  readonly property color orange: "#fc9867" // accent2
  readonly property color gray: "#727072" // dimmed3

  readonly property color accent: red
}
