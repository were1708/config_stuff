pragma Singleton

import Quickshell
import QtQuick

// Gruvbox dark palette: https://github.com/morhetz/gruvbox
Singleton {
  readonly property color bg0: "#282828"
  readonly property color bg1: "#3c3836"
  readonly property color bg2: "#504945"
  readonly property color bg3: "#665c54"
  readonly property color bg4: "#7c6f64"

  readonly property color fg0: "#fbf1c7"
  readonly property color fg1: "#ebdbb2"
  readonly property color fg2: "#d5c4a1"
  readonly property color fg3: "#bdae93"
  readonly property color fg4: "#a89984"

  readonly property color red: "#fb4934"
  readonly property color green: "#b8bb26"
  readonly property color yellow: "#fabd2f"
  readonly property color blue: "#83a598"
  readonly property color purple: "#d3869b"
  readonly property color aqua: "#8ec07c"
  readonly property color orange: "#fe8019"
  readonly property color gray: "#928374"

  readonly property color accent: yellow
}
