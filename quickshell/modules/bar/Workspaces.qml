import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.config

// Always shows workspaces 1-3. Higher workspaces only show up once they
// have a window open on them, and disappear again once emptied.
Row {
  id: root

  required property ShellScreen screen

  spacing: 4

  function workspaceFor(id) {
    return Hyprland.workspaces.values.find(ws => ws.id === id
      && ws.monitor && ws.monitor.name === root.screen.name) ?? null
  }

  readonly property var visibleIds: {
    const ids = new Set([1, 2, 3])
    for (const ws of Hyprland.workspaces.values) {
      if (ws.monitor && ws.monitor.name === root.screen.name
        && ws.id > 3 && ws.toplevels.values.length > 0)
        ids.add(ws.id)
    }
    return Array.from(ids).sort((a, b) => a - b)
  }

  Repeater {
    model: root.visibleIds

    delegate: Rectangle {
      id: delegate

      required property int modelData
      readonly property var ws: root.workspaceFor(modelData)
      readonly property bool current: ws !== null && ws.active
      readonly property bool urgent: ws !== null && ws.urgent

      width: 22
      height: 22
      radius: width / 2
      color: current ? Colors.bg3 : "transparent"
      border.width: current || urgent ? 2 : 0
      border.color: urgent ? Colors.red : Colors.accent

      Behavior on color { ColorAnimation { duration: Style.animationDuration } }
      Behavior on border.width { NumberAnimation { duration: Style.animationDuration } }

      Text {
        anchors.centerIn: parent
        text: delegate.modelData
        font.pixelSize: Style.fontSize
        color: delegate.current ? Colors.fg0 : Colors.fg3
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          if (delegate.ws)
            delegate.ws.activate()
          else
            Hyprland.dispatch("workspace " + delegate.modelData)
        }
      }
    }
  }
}
