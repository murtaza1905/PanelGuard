import Foundation

enum Settings {
    private static let d = UserDefaults.standard

    /// Bundle identifier used by PanelGuard 1.0.x. Settings stored under it are
    /// copied into the current domain once, on the first launch of 1.1.0 or later.
    private static let legacyDomain = "com.panelguard.app"

    private enum Key {
        static let filterEnabled = "filterEnabled"
        static let filterLevel = "filterLevel"
        static let idleEnabled = "idleEnabled"
        static let idleMinutes = "idleMinutes"

        static var all: [String] { [filterEnabled, filterLevel, idleEnabled, idleMinutes] }
    }

    static func migrateLegacyDefaultsIfNeeded() {
        guard Bundle.main.bundleIdentifier != legacyDomain,
              Key.all.allSatisfy({ d.object(forKey: $0) == nil }),
              let legacy = d.persistentDomain(forName: legacyDomain), !legacy.isEmpty else { return }
        for key in Key.all {
            if let value = legacy[key] { d.set(value, forKey: key) }
        }
        d.removePersistentDomain(forName: legacyDomain)
    }

    static var filterEnabled: Bool {
        get { d.object(forKey: Key.filterEnabled) as? Bool ?? true }
        set { d.set(newValue, forKey: Key.filterEnabled) }
    }

    static var filterLevel: GammaFilter.Level {
        get { GammaFilter.Level(rawValue: d.integer(forKey: Key.filterLevel)) ?? .medium }
        set { d.set(newValue.rawValue, forKey: Key.filterLevel) }
    }

    static var idleEnabled: Bool {
        get { d.object(forKey: Key.idleEnabled) as? Bool ?? true }
        set { d.set(newValue, forKey: Key.idleEnabled) }
    }

    static var idleMinutes: Int {
        get {
            let v = d.integer(forKey: Key.idleMinutes)
            return v == 0 ? 3 : v
        }
        set { d.set(newValue, forKey: Key.idleMinutes) }
    }
}
