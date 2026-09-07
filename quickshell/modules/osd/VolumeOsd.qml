import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import QtQuick
import qs.config

// A transient on-screen-display that pops up over the currently focused
// monitor whenever the default sink's volume or mute state changes, then
// fades itself back out after a short delay.
Scope {
  id: root

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property real volume: sink ? sink.audio.volume : 0
  readonly property bool muted: sink ? sink.audio.muted : false

  property bool ready: false
  property bool shown: false
  property bool windowVisible: false

  Timer {
    interval: 300
    running: true
    onTriggered: root.ready = true
  }

  onVolumeChanged: if (ready) trigger()
  onMutedChanged: if (ready) trigger()

  function trigger() {
    shown = true
    autoHideTimer.restart()
  }

  onShownChanged: {
    if (shown)
      windowVisible = true
    else
      closeTimer.restart()
  }

  Timer {
    id: autoHideTimer
    interval: 1600
    onTriggered: root.shown = false
  }

  Timer {
    id: closeTimer
    interval: Style.animationDuration
    onTriggered: root.windowVisible = false
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      readonly property bool isFocusedScreen: Hyprland.focusedMonitor !== null
        && Hyprland.focusedMonitor.name === modelData.name

      visible: root.windowVisible && isFocusedScreen
      color: "transparent"

      // Pure overlay: never reserve screen space or nudge tiled windows.
      exclusionMode: ExclusionMode.Ignore
      focusable: false

      anchors.bottom: true
      margins.bottom: Math.round(modelData.height * 0.10)

      implicitWidth: card.implicitWidth
      implicitHeight: card.implicitHeight

      Rectangle {
        id: card

        implicitWidth: Math.max(content.implicitWidth + 48, 135)
        implicitHeight: content.implicitHeight + 28
        radius: height / 2
        color: Colors.bg1

        scale: root.shown ? 1 : 0.85
        opacity: root.shown ? 1 : 0

        Behavior on scale {
          NumberAnimation {
            duration: Style.animationDurationLong
            easing.type: Easing.OutBack
            easing.overshoot: 1.4
          }
        }
        Behavior on opacity {
          NumberAnimation { duration: Style.animationDuration }
        }

        Row {
          id: content
          anchors.centerIn: parent
          spacing: 14

          Text {
            anchors.verticalCenter: parent.verticalCenter
            font.family: Style.iconFontFamily
            font.pixelSize: Style.fontSize + 10
            color: root.muted ? Colors.red : Colors.accent
            text: {
              if (root.muted || root.volume <= 0)
                return ""
              return root.volume <= 0.5 ? "" : ""
            }
          }

          Text {
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: Style.fontSize + 6
            font.bold: true
            color: root.muted ? Colors.red : Colors.fg1
            text: root.muted ? "Muted" : Math.round(root.volume * 100) + "%"
          }
        }
      }
    }
  }
}
