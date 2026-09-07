import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.config

// A collapsed pill next to the clock (like the iOS/macOS Dynamic Island)
// that shows the active MPRIS player. Clicking it pops open a small card
// with the cover art, title and artist.
Item {
  id: root

  readonly property MprisPlayer activePlayer: Mpris.players.values.find(p => p.isPlaying) ?? null
  property MprisPlayer player: null

  property bool expanded: false
  property bool popupVisible: false

  visible: player !== null

  // Keep showing the last active player for a while after it's paused,
  // instead of vanishing the instant playback stops.
  onActivePlayerChanged: {
    if (activePlayer !== null) {
      player = activePlayer
      pauseGraceTimer.stop()
    } else if (player !== null) {
      pauseGraceTimer.restart()
    }
  }

  Timer {
    id: pauseGraceTimer
    interval: 30000
    onTriggered: root.player = null
  }

  // If the retained player disappears entirely (app closed), don't wait
  // out the grace period - just hide immediately.
  Connections {
    target: Mpris.players
    function onValuesChanged() {
      if (root.player !== null && !Mpris.players.values.includes(root.player))
        root.player = null
    }
  }
  implicitWidth: pill.implicitWidth
  implicitHeight: pill.implicitHeight
  width: implicitWidth
  height: implicitHeight

  onExpandedChanged: {
    if (expanded)
      popupVisible = true
    else
      closeTimer.restart()
  }

  onPlayerChanged: {
    if (player === null)
      expanded = false
  }

  Timer {
    id: closeTimer
    interval: Style.animationDuration
    onTriggered: root.popupVisible = false
  }

  // MprisPlayer.position doesn't update reactively on its own (to save CPU);
  // this nudges it once a second so the progress bar keeps moving.
  Timer {
    interval: 1000
    repeat: true
    running: root.expanded && root.player !== null && root.player.isPlaying
    onTriggered: root.player.positionChanged()
  }

  function truncate(text, maxLength) {
    if (!text || text.length <= maxLength)
      return text
    return text.slice(0, maxLength - 1) + "…"
  }

  function formatTime(seconds) {
    if (!seconds || seconds < 0 || !isFinite(seconds))
      return "0:00"
    const total = Math.floor(seconds)
    const m = Math.floor(total / 60)
    const s = total % 60
    return m + ":" + (s < 10 ? "0" : "") + s
  }

  Rectangle {
    id: pill

    implicitWidth: content.implicitWidth + 28
    implicitHeight: content.implicitHeight + 16
    width: implicitWidth
    height: implicitHeight
    radius: height / 2
    color: root.expanded ? Colors.bg2 : Colors.bg1

    Behavior on color { ColorAnimation { duration: Style.animationDuration } }

    Row {
      id: content
      anchors.centerIn: parent
      spacing: 8

      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: "♪"
        color: Colors.accent
        font.pixelSize: Style.fontSize + 4
      }

      Column {
        anchors.verticalCenter: parent.verticalCenter
        spacing: -3

        Text {
          text: root.player ? root.truncate(root.player.trackTitle, 100) : ""
          color: Colors.fg1
          font.pixelSize: Style.fontSize
          font.bold: true
        }

        Text {
          text: root.player ? root.player.trackArtist : ""
          color: Colors.fg3
          font.pixelSize: Style.fontSize - 2
        }
      }
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: root.expanded = !root.expanded
    }
  }

  PopupWindow {
    id: popup

    visible: root.popupVisible
    color: "transparent"

    implicitWidth: 420
    implicitHeight: 190

    anchor {
      item: pill
      edges: Edges.Bottom
      gravity: Edges.Bottom
      margins.top: 12
    }

    ClippingRectangle {
      anchors.fill: parent
      radius: Style.radius
      color: Colors.bg1

      scale: root.expanded ? 1 : 0.85
      opacity: root.expanded ? 1 : 0

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
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        ClippingRectangle {
          width: 140
          height: 140
          radius: Style.radius * 0.6
          color: Colors.bg2

          Image {
            anchors.fill: parent
            source: root.player ? root.player.trackArtUrl : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
          }
        }

        Column {
          anchors.verticalCenter: parent.verticalCenter
          spacing: 8
          width: parent.width - 140 - parent.spacing

          Text {
            text: root.player ? root.player.trackTitle : ""
            color: Colors.fg0
            font.pixelSize: Style.fontSize + 5
            font.bold: true
            elide: Text.ElideRight
            width: parent.width
          }

          Text {
            text: root.player ? root.player.trackArtist : ""
            color: Colors.fg3
            font.pixelSize: Style.fontSize + 2
            elide: Text.ElideRight
            width: parent.width
          }

          Column {
            width: parent.width
            spacing: 6
            topPadding: 14

            readonly property real position: root.player ? root.player.position : 0
            readonly property real length: root.player ? root.player.length : 0
            readonly property real progress: length > 0 ? Math.min(position / length, 1) : 0

            Rectangle {
              width: parent.width
              height: 6
              radius: 3
              color: Colors.bg3

              Rectangle {
                height: parent.height
                radius: parent.radius
                width: parent.width * parent.parent.progress
                color: Colors.accent

                Behavior on width { NumberAnimation { duration: 200 } }
              }
            }

            Item {
              width: parent.width
              height: timeLabel.implicitHeight

              Text {
                id: timeLabel
                anchors.left: parent.left
                text: root.formatTime(parent.parent.position)
                color: Colors.fg3
                font.pixelSize: Style.fontSize - 1
              }

              Text {
                anchors.right: parent.right
                text: root.formatTime(parent.parent.length)
                color: Colors.fg3
                font.pixelSize: Style.fontSize - 1
              }
            }
          }
        }
      }
    }
  }
}
