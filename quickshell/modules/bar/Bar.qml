import Quickshell
import Quickshell.Widgets
import QtQuick
import qs.config

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      margins.top: Style.barMargin

      implicitHeight: Style.barHeight
      color: "transparent"

      WrapperRectangle {
        anchors.left: parent.left
        anchors.leftMargin: Style.edgeMargin
        anchors.verticalCenter: parent.verticalCenter

        margin: 5
        radius: height / 2
        color: Colors.bg1

        Workspaces {
          screen: modelData
        }
      }

      Row {
        anchors.centerIn: parent
        spacing: Style.spacing

        WrapperRectangle {
          anchors.verticalCenter: parent.verticalCenter

          margin: 10
          radius: height / 2
          color: Colors.bg1

          Clock {}
        }

        MediaIsland {
          anchors.verticalCenter: parent.verticalCenter
        }
      }

      Row {
        anchors.right: parent.right
        anchors.rightMargin: Style.edgeMargin
        anchors.verticalCenter: parent.verticalCenter
        spacing: Style.spacing / 2

        WrapperRectangle {
          anchors.verticalCenter: parent.verticalCenter
          margin: 10
          radius: height / 2
          color: Colors.bg1

          CpuIndicator {}
        }

        WrapperRectangle {
          anchors.verticalCenter: parent.verticalCenter
          margin: 10
          radius: height / 2
          color: Colors.bg1

          MemoryIndicator {}
        }

        // Kinda useless tbh.
        // WrapperRectangle {
        //   anchors.verticalCenter: parent.verticalCenter
        //   margin: 10
        //   radius: height / 2
        //   color: Colors.bg1
        //
        //   DiskIndicator {}
        // }

        WrapperRectangle {
          anchors.verticalCenter: parent.verticalCenter
          margin: 10
          radius: height / 2
          color: Colors.bg1

          NetworkIndicator {}
        }

        WrapperRectangle {
          anchors.verticalCenter: parent.verticalCenter
          margin: 10
          radius: height / 2
          color: Colors.bg1

          BluetoothIndicator {}
        }

        WrapperRectangle {
          anchors.verticalCenter: parent.verticalCenter
          margin: 10
          radius: height / 2
          color: Colors.bg1

          Battery {}
        }

        WrapperRectangle {
          anchors.verticalCenter: parent.verticalCenter
          margin: 10
          radius: height / 2
          color: Colors.bg1

          PowerIndicator {}
        }
      }
    }
  }
}
