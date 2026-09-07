pragma Singleton

import Quickshell
import QtQuick

// Everforest (dark, medium contrast) palette: https://github.com/sainnhe/everforest
Singleton {
  readonly property color bg0: "#2d353b"
  readonly property color bg1: "#343f44"
  readonly property color bg2: "#3d484d"
  readonly property color bg3: "#475258"
  readonly property color bg4: "#4f585e"

  readonly property color fg0: "#d3c6aa" // fg
  readonly property color fg1: "#9da9a0" // grey2
  readonly property color fg2: "#859289" // grey1
  readonly property color fg3: "#7a8478" // grey0
  readonly property color fg4: "#56635f" // bg5

  readonly property color red: "#e67e80"
  readonly property color green: "#a7c080"
  readonly property color yellow: "#dbbc7f"
  readonly property color blue: "#7fbbb3"
  readonly property color purple: "#d699b6"
  readonly property color aqua: "#83c092"
  readonly property color orange: "#e69875"
  readonly property color gray: "#859289" // grey1

  readonly property color accent: green
}
