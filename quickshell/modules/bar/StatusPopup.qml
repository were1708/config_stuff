import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.config

// Shared "small manager" popup shell used by bar indicators that need more
// than a passive readout (Bluetooth, network, ...). Anchors below whatever
// item triggered it and pops open/closed with the same animation language
// as the media island's expanded card.
PopupWindow {
  id: root

  required property Item anchorItem
  property bool expanded: false
  property bool windowVisible: false

  default property alias content: contentColumn.data

  visible: windowVisible
  color: "transparent"

  implicitWidth: card.implicitWidth
  implicitHeight: card.implicitHeight

  anchor {
    item: anchorItem
    edges: Edges.Bottom
    gravity: Edges.Bottom
    margins.top: 10
  }

  onExpandedChanged: {
    if (expanded)
      windowVisible = true
    else
      closeTimer.restart()
  }

  Timer {
    id: closeTimer
    interval: Style.animationDuration
    onTriggered: root.windowVisible = false
  }

  ClippingRectangle {
    id: card

    implicitWidth: Math.max(contentColumn.implicitWidth + 32, 220)
    implicitHeight: contentColumn.implicitHeight + 24
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

    Column {
      id: contentColumn
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.margins: 16
      spacing: 6
    }
  }
}
