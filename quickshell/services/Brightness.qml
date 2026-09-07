pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Tracks and controls screen backlight brightness via brightnessctl. Polls
// rather than watching sysfs for changes, since Qt's file-watch didn't
// reliably pick up backlight brightness writes in testing.
Singleton {
  id: root

  property string deviceName: ""
  property int currentBrightness: 0
  property int maxBrightness: 1

  readonly property real fraction: maxBrightness > 0 ? currentBrightness / maxBrightness : 0
  readonly property bool available: deviceName !== ""

  function setFraction(frac) {
    const clamped = Math.max(0, Math.min(1, frac))
    setProc.command = ["brightnessctl", "set", Math.round(clamped * 100) + "%"]
    setProc.startDetached()
  }

  Process {
    id: setProc
  }

  Process {
    id: pollProc
    command: ["brightnessctl", "-m"]

    stdout: StdioCollector {
      onStreamFinished: {
        const fields = text.trim().split("\n")[0].split(",")
        if (fields.length >= 5 && fields[1] === "backlight") {
          root.deviceName = fields[0]
          root.currentBrightness = parseInt(fields[2])
          root.maxBrightness = parseInt(fields[4]) || 1
        }
      }
    }
  }

  Timer {
    interval: 300
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: pollProc.running = true
  }
}
