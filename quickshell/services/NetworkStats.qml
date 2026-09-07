pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Polls /proc/net/dev to compute live upload/download rates per interface.
Singleton {
  id: root

  // interfaceName -> { rx: bytesPerSec, tx: bytesPerSec }
  property var rates: ({})

  property var _prevBytes: ({})
  property real _prevTime: 0

  function rateFor(name) {
    return rates[name] || { rx: 0, tx: 0 }
  }

  function formatRate(bytesPerSec) {
    if (bytesPerSec >= 1024 * 1024)
      return (bytesPerSec / (1024 * 1024)).toFixed(1) + " MB/s"
    if (bytesPerSec >= 1024)
      return (bytesPerSec / 1024).toFixed(0) + " KB/s"
    return Math.round(bytesPerSec) + " B/s"
  }

  Process {
    id: proc
    command: ["cat", "/proc/net/dev"]

    stdout: StdioCollector {
      id: collector
      onStreamFinished: {
        const now = Date.now() / 1000
        const newBytes = {}

        for (const rawLine of collector.text.split("\n").slice(2)) {
          const line = rawLine.trim()
          if (!line)
            continue
          const colonIdx = line.indexOf(":")
          if (colonIdx < 0)
            continue
          const name = line.slice(0, colonIdx).trim()
          const fields = line.slice(colonIdx + 1).trim().split(/\s+/).map(Number)
          newBytes[name] = { rx: fields[0], tx: fields[8] }
        }

        const dt = root._prevTime > 0 ? now - root._prevTime : 0
        const newRates = {}
        if (dt > 0) {
          for (const name in newBytes) {
            const prev = root._prevBytes[name]
            newRates[name] = prev
              ? {
                  rx: Math.max(0, (newBytes[name].rx - prev.rx) / dt),
                  tx: Math.max(0, (newBytes[name].tx - prev.tx) / dt)
                }
              : { rx: 0, tx: 0 }
          }
        }

        root._prevBytes = newBytes
        root._prevTime = now
        root.rates = newRates
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
