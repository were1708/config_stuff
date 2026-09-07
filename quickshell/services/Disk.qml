pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Polls disk usage for the root filesystem. Checked infrequently since it
// changes slowly.
Singleton {
  id: root

  property real totalKb: 0
  property real usedKb: 0

  readonly property real usedFraction: totalKb > 0 ? usedKb / totalKb : 0
  readonly property real usedGiB: usedKb / (1024 * 1024)
  readonly property real totalGiB: totalKb / (1024 * 1024)

  Process {
    id: proc
    command: ["df", "-k", "--output=size,used", "/"]

    stdout: StdioCollector {
      id: collector
      onStreamFinished: {
        const lines = collector.text.trim().split("\n")
        if (lines.length < 2)
          return
        const parts = lines[1].trim().split(/\s+/)
        root.totalKb = parseInt(parts[0])
        root.usedKb = parseInt(parts[1])
      }
    }
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: proc.running = true
  }
}
