import QtQuick
import Quickshell.Bluetooth
import qs.config

// Bluetooth status pill. Click it to open a small device manager listing
// paired/visible devices, with tap-to-connect/disconnect.
Item {
  id: root

  readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
  readonly property bool on: adapter !== null && adapter.enabled

  readonly property int connectedCount: adapter
    ? adapter.devices.values.filter(device => device.connected).length
    : 0

  property bool expanded: false

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight
  width: implicitWidth
  height: implicitHeight

  Row {
    id: row
    spacing: 4

    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: ""
      font.family: Style.iconFontFamily
      font.pixelSize: Style.fontSize
      color: root.on ? Colors.blue : Colors.fg4
    }

    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: root.on ? root.connectedCount : "off"
      font.pixelSize: Style.fontSize
      color: root.on ? Colors.fg1 : Colors.fg4
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

    Rectangle {
      width: headerRow.implicitWidth
      height: headerRow.implicitHeight + 6
      color: "transparent"

      Row {
        id: headerRow
        spacing: 8

        Text {
          text: "Bluetooth"
          font.bold: true
          font.pixelSize: Style.fontSize + 1
          color: Colors.fg0
        }

        Text {
          text: root.on ? "On" : "Off"
          font.pixelSize: Style.fontSize
          color: root.on ? Colors.blue : Colors.fg4
        }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.adapter && (root.adapter.enabled = !root.adapter.enabled)
      }
    }

    Repeater {
      model: root.on && root.adapter ? root.adapter.devices.values : []

      delegate: Rectangle {
        id: deviceRow
        required property BluetoothDevice modelData

        implicitWidth: deviceContent.implicitWidth
        implicitHeight: deviceContent.implicitHeight + 8
        color: "transparent"

        Row {
          id: deviceContent
          spacing: 8

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: deviceRow.modelData.connected ? "●" : "○"
            color: deviceRow.modelData.connected ? Colors.accent : Colors.fg4
            font.pixelSize: Style.fontSize - 2
          }

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: deviceRow.modelData.name
            color: Colors.fg1
            font.pixelSize: Style.fontSize
          }
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: deviceRow.modelData.connected
            ? deviceRow.modelData.disconnect()
            : deviceRow.modelData.connect()
        }
      }
    }

    Text {
      visible: root.on && root.adapter && root.adapter.devices.values.length === 0
      text: "No devices found"
      color: Colors.fg4
      font.pixelSize: Style.fontSize
    }
  }
}
