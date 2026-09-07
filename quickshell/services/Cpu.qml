pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Polls /proc/stat to compute overall CPU usage as a 0-1 fraction.
Singleton {
  id: root

  readonly property real usage: _usage

  property real _usage: 0
  property real _prevIdle: 0
  property real _prevTotal: 0
  property bool _haveSample: false

  Process {
    id: proc
    command: ["cat", "/proc/stat"]

    stdout: StdioCollector {
      id: collector
      onStreamFinished: {
        const line = collector.text.split("\n")[0]
        const parts = line.trim().split(/\s+/).slice(1).map(Number)
        const idle = parts[3] + parts[4]
        const total = parts.reduce((a, b) => a + b, 0)

        if (root._haveSample) {
          const deltaIdle = idle - root._prevIdle
          const deltaTotal = total - root._prevTotal
          if (deltaTotal > 0)
            root._usage = 1 - deltaIdle / deltaTotal
        }

        root._prevIdle = idle
        root._prevTotal = total
        root._haveSample = true
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: proc.running = true
  }
}
