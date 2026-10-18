import CoreGraphics
import Foundation

final class IdleMonitor {

    var thresholdSeconds: TimeInterval
    var onIdle: () -> Void

    private var timer: Timer?
    private var hasFired = false

    private static let anyInputEvent = CGEventType(rawValue: ~0)!

    init(thresholdSeconds: TimeInterval, onIdle: @escaping () -> Void) {
        self.thresholdSeconds = thresholdSeconds
        self.onIdle = onIdle
    }

    var isRunning: Bool { timer != nil }

    func start() {
        guard timer == nil else { return }
        hasFired = false
        let t = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        t.tolerance = 0.5
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        hasFired = false
    }

    private func tick() {
        let idle = CGEventSource.secondsSinceLastEventType(.combinedSessionState,
                                                           eventType: IdleMonitor.anyInputEvent)
        if idle >= thresholdSeconds {
            if !hasFired {
                hasFired = true
                onIdle()
            }
        } else {
            hasFired = false
        }
    }
}

enum DisplaySleep {
    static func now() {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        p.arguments = ["displaysleepnow"]
        p.standardOutput = nil
        p.standardError = nil
        try? p.run()
    }
}
