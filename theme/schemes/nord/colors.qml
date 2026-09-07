pragma Singleton

import Quickshell
import QtQuick

// Nord palette: https://www.nordtheme.com/
Singleton {
  readonly property color bg0: "#2e3440" // nord0
  readonly property color bg1: "#3b4252" // nord1
  readonly property color bg2: "#434c5e" // nord2
  readonly property color bg3: "#4c566a" // nord3
  readonly property color bg4: "#616e88" // nord3, lightened

  readonly property color fg0: "#eceff4" // nord6
  readonly property color fg1: "#e5e9f0" // nord5
  readonly property color fg2: "#d8dee9" // nord4
  readonly property color fg3: "#81a1c1" // nord9
  readonly property color fg4: "#4c566a" // nord3

  readonly property color red: "#bf616a" // nord11
  readonly property color green: "#a3be8c" // nord14
  readonly property color yellow: "#ebcb8b" // nord13
  readonly property color blue: "#5e81ac" // nord10
  readonly property color purple: "#b48ead" // nord15
  readonly property color aqua: "#88c0d0" // nord8
  readonly property color orange: "#d08770" // nord12
  readonly property color gray: "#4c566a" // nord3

  readonly property color accent: aqua
}
