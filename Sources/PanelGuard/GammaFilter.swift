import CoreGraphics
import Foundation

final class GammaFilter {

    enum Level: Int, CaseIterable {
        case light = 0
        case medium = 1
        case strong = 2

        var title: String {
            switch self {
            case .light: return L10n.levelLight
            case .medium: return L10n.levelMedium
            case .strong: return L10n.levelStrong
            }
        }

        var scale: CGGammaValue {
            switch self {
            case .light: return 0.92
            case .medium: return 0.88
            case .strong: return 0.84
            }
        }
    }

    private(set) var isActive = false
    private var currentLevel: Level = .medium

    func apply(level: Level) {
        currentLevel = level
        CGDisplayRestoreColorSyncSettings()
        for display in activeDisplays() {
            scaleDisplay(display, by: level.scale)
        }
        isActive = true
    }

    func remove() {
        guard isActive else { return }
        CGDisplayRestoreColorSyncSettings()
        isActive = false
    }

    func reapplyIfActive() {
        guard isActive else { return }
        apply(level: currentLevel)
    }

    private func activeDisplays() -> [CGDirectDisplayID] {
        var count: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &count)
        guard count > 0 else { return [] }
        var ids = [CGDirectDisplayID](repeating: 0, count: Int(count))
        CGGetActiveDisplayList(count, &ids, &count)
        return Array(ids.prefix(Int(count)))
    }

    private func scaleDisplay(_ display: CGDirectDisplayID, by scale: CGGammaValue) {
        let capacity = CGDisplayGammaTableCapacity(display)
        guard capacity > 0 else { return }

        var red = [CGGammaValue](repeating: 0, count: Int(capacity))
        var green = [CGGammaValue](repeating: 0, count: Int(capacity))
        var blue = [CGGammaValue](repeating: 0, count: Int(capacity))
        var sampleCount: UInt32 = 0

        let readResult = CGGetDisplayTransferByTable(display, capacity, &red, &green, &blue, &sampleCount)
        guard readResult == .success, sampleCount > 0 else { return }

        let n = Int(sampleCount)
        for i in 0..<n {
            red[i] *= scale
            green[i] *= scale
            blue[i] *= scale
        }

        CGSetDisplayTransferByTable(display, sampleCount, red, green, blue)
    }
}
