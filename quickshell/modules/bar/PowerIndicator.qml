import QtQuick
import Quickshell.Io
import qs.config

// Power controls pill. Click it to open Lock/Suspend/Restart/Shut Down/Log
// Out. Destructive actions require a second confirming click before they
// actually run.
Item {
  id: root

  property bool expanded: false
  property string armed: ""

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight
  width: implicitWidth
  height: implicitHeight

  onExpandedChanged: if (!expanded) armed = ""

  function run(command) {
    runner.command = command
    runner.startDetached()
  }

  Process {
    id: runner
  }

  Timer {
    id: disarmTimer
    interval: 3000
    onTriggered: root.armed = ""
  }

  Row {
    id: row

    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: ""
      font.family: Style.iconFontFamily
      font.pixelSize: Style.fontSize
      color: Colors.red
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: root.expanded = !root.expanded
  }

  StatusPopup {
    anchorItem: root
    expanded: root.expanded

    Text {
      text: "Power"
      font.bold: true
      font.pixelSize: Style.fontSize + 1
      color: Colors.fg0
    }

    Repeater {
      model: [
        { id: "lock", label: "Lock", icon: "", destructive: false, command: ["loginctl", "lock-session"] },
        { id: "suspend", label: "Suspend", icon: "", destructive: false, command: ["systemctl", "suspend"] },
        { id: "logout", label: "Log Out", icon: "", destructive: true, command: ["hyprctl", "dispatch", "exit"] },
        { id: "reboot", label: "Restart", icon: "", destructive: true, command: ["systemctl", "reboot"] },
        { id: "shutdown", label: "Shut Down", icon: "", destructive: true, command: ["systemctl", "poweroff"] }
      ]

      delegate: Rectangle {
        id: actionRow
        required property var modelData

        readonly property bool isArmed: root.armed === modelData.id

        implicitWidth: actionContent.implicitWidth + 12
        implicitHeight: actionContent.implicitHeight + 8
        radius: 6
        color: isArmed ? Colors.bg2 : "transparent"

        Behavior on color { ColorAnimation { duration: Style.animationDuration } }

        Row {
          id: actionContent
          anchors.centerIn: parent
          spacing: 8

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: actionRow.modelData.icon
            font.family: Style.iconFontFamily
            font.pixelSize: Style.fontSize
            color: actionRow.isArmed ? Colors.red : Colors.fg1
          }

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: actionRow.isArmed ? "Click to confirm" : actionRow.modelData.label
            color: actionRow.isArmed ? Colors.red : Colors.fg1
            font.pixelSize: Style.fontSize
          }
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (!actionRow.modelData.destructive) {
              root.run(actionRow.modelData.command)
              root.expanded = false
              return
            }

            if (actionRow.isArmed) {
              root.run(actionRow.modelData.command)
              root.expanded = false
            } else {
              root.armed = actionRow.modelData.id
              disarmTimer.restart()
            }
          }
        }
      }
    }
  }
}
