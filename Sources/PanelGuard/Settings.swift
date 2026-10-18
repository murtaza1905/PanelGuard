import Foundation

enum Settings {
    private static let d = UserDefaults.standard

    private enum Key {
        static let filterEnabled = "filterEnabled"
        static let filterLevel = "filterLevel"
        static let idleEnabled = "idleEnabled"
        static let idleMinutes = "idleMinutes"
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
