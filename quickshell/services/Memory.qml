pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Polls /proc/meminfo for overall memory usage.
Singleton {
  id: root

  property real totalKb: 0
  property real availableKb: 0

  readonly property real usedFraction: totalKb > 0 ? (totalKb - availableKb) / totalKb : 0
  readonly property real usedGiB: (totalKb - availableKb) / (1024 * 1024)
  readonly property real totalGiB: totalKb / (1024 * 1024)

  Process {
    id: proc
    command: ["cat", "/proc/meminfo"]

    stdout: StdioCollector {
      id: collector
      onStreamFinished: {
        let total = 0
        let available = 0
        for (const line of collector.text.split("\n")) {
          if (line.startsWith("MemTotal:"))
            total = parseInt(line.split(/\s+/)[1])
          else if (line.startsWith("MemAvailable:"))
            available = parseInt(line.split(/\s+/)[1])
        }
        root.totalKb = total
        root.availableKb = available
      }
    }
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: proc.running = true
  }
}
