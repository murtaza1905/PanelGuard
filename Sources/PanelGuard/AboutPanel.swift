import AppKit

/// Shows the standard macOS About window with the app's credits.
/// Version, build number and copyright are read from Info.plist by AppKit.
enum AboutPanel {

    static let author = "Murat Onurcu"
    static let email = "muratonurcu@outlook.com"
    static let repository = URL(string: "https://github.com/murtaza1905/PanelGuard")!

    static func show() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(options: [.credits: credits()])
    }

    private static func credits() -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.paragraphSpacing = 3

        let base: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize),
            .foregroundColor: NSColor.labelColor,
            .paragraphStyle: paragraph
        ]
        let secondary: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize),
            .foregroundColor: NSColor.secondaryLabelColor,
            .paragraphStyle: paragraph
        ]

        let text = NSMutableAttributedString()

        func line(_ string: String, attributes: [NSAttributedString.Key: Any], link: URL? = nil) {
            var attrs = attributes
            if let link { attrs[.link] = link }
            text.append(NSAttributedString(string: string + "\n", attributes: attrs))
        }

        line(L10n.aboutTagline, attributes: secondary)
        line("\n" + L10n.aboutDeveloper + ": " + author, attributes: base)
        line(email, attributes: base, link: URL(string: "mailto:\(email)"))
        line(L10n.aboutSource, attributes: base, link: repository)
        line("\n" + L10n.aboutLicense, attributes: secondary)
        return text
    }
}
