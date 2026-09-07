import QtQuick
import Quickshell.Services.UPower
import qs.config

// Displays the primary battery's charge level, and whether it's charging.
Row {
  spacing: 4

  readonly property UPowerDevice battery: UPower.displayDevice
  readonly property bool charging: battery !== null && battery.state === UPowerDeviceState.Charging
  readonly property int percent: battery ? Math.round(battery.percentage * 100) : 0
  readonly property bool low: percent <= 15 && !charging

  // Font Awesome glyphs (via the Nerd Font patch): bolt, battery-{full,3/4,half,1/4,empty}.
  readonly property string icon: {
    if (charging) return ""
    if (percent > 90) return ""
    if (percent > 60) return ""
    if (percent > 35) return ""
    if (percent > 10) return ""
    return ""
  }

  readonly property color iconColor: charging ? Colors.yellow : low ? Colors.red : Colors.green

  visible: battery !== null && battery.isPresent

  Text {
    anchors.verticalCenter: parent.verticalCenter
    text: parent.icon
    font.family: Style.iconFontFamily
    font.pixelSize: Style.fontSize
    color: parent.iconColor
  }

  Text {
    anchors.verticalCenter: parent.verticalCenter
    text: parent.percent + "%"
    font.pixelSize: Style.fontSize
    color: parent.low ? Colors.red : Colors.fg1
  }
}
