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

  // Only scan for nearby devices while the manager is actually open.
  onExpandedChanged: {
    if (adapter)
      adapter.discovering = expanded
  }

  readonly property var pairedDevices: on && adapter
    ? adapter.devices.values.filter(d => d.paired || d.bonded)
    : []

  readonly property var availableDevices: on && adapter
    ? adapter.devices.values.filter(d => !d.paired && !d.bonded)
    : []

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

    Text {
      visible: root.pairedDevices.length > 0
      text: "Paired"
      color: Colors.fg3
      font.pixelSize: Style.fontSize - 2
      font.bold: true
    }

    Repeater {
      model: root.pairedDevices

      delegate: Rectangle {
        id: pairedRow
        required property BluetoothDevice modelData

        implicitWidth: pairedContent.implicitWidth
        implicitHeight: pairedContent.implicitHeight + 8
        color: "transparent"

        Row {
          id: pairedContent
          spacing: 8

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: pairedRow.modelData.connected ? "●" : "○"
            color: pairedRow.modelData.connected ? Colors.accent : Colors.fg4
            font.pixelSize: Style.fontSize - 2
          }

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: pairedRow.modelData.name || pairedRow.modelData.address
            color: Colors.fg1
            font.pixelSize: Style.fontSize
          }
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: pairedRow.modelData.connected
            ? pairedRow.modelData.disconnect()
            : pairedRow.modelData.connect()
        }
      }
    }

    Text {
      visible: root.on
      text: root.adapter && root.adapter.discovering ? "Available (searching…)" : "Available"
      color: Colors.fg3
      font.pixelSize: Style.fontSize - 2
      font.bold: true
      topPadding: root.pairedDevices.length > 0 ? 6 : 0
    }

    Repeater {
      model: root.availableDevices

      delegate: Rectangle {
        id: availableRow
        required property BluetoothDevice modelData

        implicitWidth: availableContent.implicitWidth
        implicitHeight: availableContent.implicitHeight + 8
        color: "transparent"

        Row {
          id: availableContent
          spacing: 8

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: availableRow.modelData.name || availableRow.modelData.address
            color: Colors.fg1
            font.pixelSize: Style.fontSize
          }

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: availableRow.modelData.pairing ? "Pairing…" : "Pair"
            color: Colors.accent
            font.pixelSize: Style.fontSize - 2
          }
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: availableRow.modelData.pairing
            ? availableRow.modelData.cancelPair()
            : availableRow.modelData.pair()
        }
      }
    }

    Text {
      visible: root.on && root.availableDevices.length === 0 && !(root.adapter && root.adapter.discovering)
      text: "No devices found nearby"
      color: Colors.fg4
      font.pixelSize: Style.fontSize
    }
  }
}
