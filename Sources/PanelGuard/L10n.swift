import Foundation

enum L10n {
    private static let isTurkish: Bool = {
        guard let lang = Locale.preferredLanguages.first else { return false }
        return lang.lowercased().hasPrefix("tr")
    }()

    private static func t(_ en: String, _ tr: String) -> String {
        isTurkish ? tr : en
    }

    static var appName: String { "PanelGuard" }
    static var filter: String { t("White Softening Filter", "Beyaz Yumuşatma Filtresi") }
    static var intensity: String { t("Intensity", "Yoğunluk") }
    static var levelLight: String { t("Light (8%)", "Hafif (%8)") }
    static var levelMedium: String { t("Medium (12%)", "Orta (%12)") }
    static var levelStrong: String { t("Strong (16%)", "Güçlü (%16)") }
    static var idleSleep: String { t("Sleep Display When Idle", "Boşta Ekranı Uyut") }
    static var duration: String { t("Delay", "Süre") }
    static func minutes(_ m: Int) -> String { t("\(m) minutes", "\(m) dakika") }
    static var about: String { t("About PanelGuard…", "PanelGuard Hakkında…") }
    static var quit: String { t("Quit", "Çıkış") }

    // About window
    static var aboutTagline: String {
        t("Reduces image retention on IPS displays.", "IPS ekranlarda görüntü tutulmasını azaltır.")
    }
    static var aboutDeveloper: String { t("Developer", "Geliştirici") }
    static var aboutSource: String { t("Source code and issues on GitHub", "Kaynak kod ve hata bildirimi: GitHub") }
    static var aboutLicense: String {
        t("Open source under the MIT License.", "MIT Lisansı ile açık kaynak.")
    }
}
