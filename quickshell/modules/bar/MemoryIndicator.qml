import QtQuick
import qs.services
import qs.config

// Overall memory usage, colored green/yellow/red by load.
Row {
  spacing: 4

  readonly property real usage: Memory.usedFraction
  readonly property color statusColor: usage > 0.85 ? Colors.red
    : usage > 0.6 ? Colors.yellow
    : Colors.green

  Text {
    anchors.verticalCenter: parent.verticalCenter
    text: ""
    font.family: Style.iconFontFamily
    font.pixelSize: Style.fontSize
    color: parent.statusColor
  }

  Text {
    anchors.verticalCenter: parent.verticalCenter
    text: Math.round(parent.usage * 100) + "%"
    font.pixelSize: Style.fontSize
    color: parent.statusColor
  }
}
