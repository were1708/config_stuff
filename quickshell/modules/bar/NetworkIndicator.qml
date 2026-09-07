import QtQuick
import Quickshell.Networking
import qs.config

// Network status pill. Click it to open a small manager showing the active
// connection and nearby Wi-Fi networks, with tap-to-connect/disconnect.
Item {
  id: root

  readonly property var wiredDevice: {
    for (const d of Networking.devices.values)
      if (d.type === DeviceType.Wired)
        return d
    return null
  }

  readonly property var wifiDevice: {
    for (const d of Networking.devices.values)
      if (d.type === DeviceType.Wifi)
        return d
    return null
  }

  readonly property bool wiredConnected: wiredDevice !== null && wiredDevice.connected
  readonly property bool wifiConnected: wifiDevice !== null && wifiDevice.connected
  readonly property bool connected: wiredConnected || wifiConnected

  readonly property string activeName: {
    if (wiredConnected)
      return "Ethernet"
    if (wifiConnected) {
      const net = wifiDevice.networks.values.find(n => n.connected)
      return net ? net.name : "Wi-Fi"
    }
    return "Not connected"
  }

  property bool expanded: false

  // The network currently showing an inline password prompt, if any.
  property var passwordTarget: null

  // Only scan for nearby networks while the manager is actually open.
  onExpandedChanged: {
    if (wifiDevice)
      wifiDevice.scannerEnabled = expanded
    if (!expanded)
      passwordTarget = null
  }

  function needsPassword(network) {
    return !network.known
      && network.security !== WifiSecurityType.Open
      && network.security !== WifiSecurityType.Owe
  }

  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight
  width: implicitWidth
  height: implicitHeight

  Row {
    id: row
    spacing: 4

    Text {
      anchors.verticalCenter: parent.verticalCenter
      text: root.wiredConnected ? "" : ""
      font.family: Style.iconFontFamily
      font.pixelSize: Style.fontSize
      color: root.connected ? Colors.aqua : Colors.fg4
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
    grabFocus: root.expanded

    Text {
      text: "Network"
      font.bold: true
      font.pixelSize: Style.fontSize + 1
      color: Colors.fg0
    }

    Text {
      text: root.activeName
      color: root.connected ? Colors.aqua : Colors.fg4
      font.pixelSize: Style.fontSize
    }

    Repeater {
      model: root.wifiDevice
        ? root.wifiDevice.networks.values.slice().sort((a, b) => b.signalStrength - a.signalStrength).slice(0, 6)
        : []

      delegate: Column {
        id: netRow
        required property var modelData

        readonly property bool showPassword: root.passwordTarget === modelData

        spacing: 4

        Connections {
          target: netRow.modelData
          function onConnectionFailed(reason) {
            if (netRow.showPassword)
              errorText.message = ConnectionFailReason.toString(reason)
          }
          function onConnectedChanged() {
            if (netRow.modelData.connected && netRow.showPassword)
              root.passwordTarget = null
          }
        }

        Rectangle {
          implicitWidth: netContent.implicitWidth
          implicitHeight: netContent.implicitHeight + 8
          color: "transparent"

          Row {
            id: netContent
            spacing: 8

            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: netRow.modelData.connected ? "●" : "○"
              color: netRow.modelData.connected ? Colors.accent : Colors.fg4
              font.pixelSize: Style.fontSize - 2
            }

            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: netRow.modelData.name
              color: Colors.fg1
              font.pixelSize: Style.fontSize
            }

            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: Math.round(netRow.modelData.signalStrength * 100) + "%"
              color: Colors.fg3
              font.pixelSize: Style.fontSize - 2
            }
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              if (netRow.modelData.connected) {
                netRow.modelData.disconnect()
              } else if (root.needsPassword(netRow.modelData)) {
                errorText.message = ""
                root.passwordTarget = netRow.showPassword ? null : netRow.modelData
              } else {
                netRow.modelData.connect()
              }
            }
          }
        }

        Rectangle {
          id: passwordBox
          visible: netRow.showPassword
          width: passwordRow.implicitWidth + 16
          height: passwordRow.implicitHeight + 12
          radius: 6
          color: Colors.bg2

          onVisibleChanged: if (visible) pwField.forceActiveFocus()

          Row {
            id: passwordRow
            anchors.centerIn: parent
            spacing: 8

            Rectangle {
              width: 130
              height: pwField.implicitHeight + 8
              radius: 4
              color: Colors.bg0
              border.width: 1
              border.color: Colors.bg3

              TextInput {
                id: pwField
                anchors.fill: parent
                anchors.margins: 6
                clip: true
                color: Colors.fg1
                font.pixelSize: Style.fontSize
                echoMode: TextInput.Password

                Keys.onReturnPressed: {
                  netRow.modelData.connectWithPsk(pwField.text)
                  pwField.text = ""
                }
                Keys.onEscapePressed: root.passwordTarget = null
              }
            }

            Text {
              anchors.verticalCenter: parent.verticalCenter
              text: "Connect"
              color: Colors.accent
              font.pixelSize: Style.fontSize

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  netRow.modelData.connectWithPsk(pwField.text)
                  pwField.text = ""
                }
              }
            }
          }
        }

        Text {
          id: errorText
          property string message: ""
          visible: netRow.showPassword && message.length > 0
          text: message
          color: Colors.red
          font.pixelSize: Style.fontSize - 2
        }
      }
    }

    Text {
      visible: !root.wifiDevice
      text: "No Wi-Fi adapter"
      color: Colors.fg4
      font.pixelSize: Style.fontSize
    }
  }
}
