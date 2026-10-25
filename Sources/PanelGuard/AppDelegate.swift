import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    private var statusItem: NSStatusItem!
    private let menu = NSMenu()
    private let gamma = GammaFilter()
    private var idleMonitor: IdleMonitor!

    private let idleOptions = [2, 3, 5, 10]

    func applicationDidFinishLaunching(_ notification: Notification) {
        Settings.migrateLegacyDefaultsIfNeeded()
        setupStatusItem()
        setupIdleMonitor()
        applyFilterSetting()
        registerObservers()
    }

    func applicationWillTerminate(_ notification: Notification) {
        gamma.remove()
    }

    // MARK: - Status item & menu

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            if let img = NSImage(named: "MenuBarIcon") {
                img.isTemplate = true
                img.size = NSSize(width: 18, height: 18)
                button.image = img
            } else if let img = NSImage(systemSymbolName: "display", accessibilityDescription: "PanelGuard") {
                img.isTemplate = true
                button.image = img
            } else {
                button.title = "◐"
            }
        }
        menu.delegate = self
        statusItem.menu = menu
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()

        let filterItem = NSMenuItem(title: L10n.filter,
                                    action: #selector(toggleFilter), keyEquivalent: "")
        filterItem.target = self
        filterItem.state = Settings.filterEnabled ? .on : .off
        menu.addItem(filterItem)

        let levelMenu = NSMenu()
        for level in GammaFilter.Level.allCases {
            let item = NSMenuItem(title: level.title, action: #selector(selectLevel(_:)), keyEquivalent: "")
            item.target = self
            item.tag = level.rawValue
            item.state = Settings.filterLevel == level ? .on : .off
            levelMenu.addItem(item)
        }
        let levelItem = NSMenuItem(title: L10n.intensity, action: nil, keyEquivalent: "")
        levelItem.submenu = levelMenu
        menu.addItem(levelItem)

        menu.addItem(.separator())

        let idleItem = NSMenuItem(title: L10n.idleSleep,
                                  action: #selector(toggleIdle), keyEquivalent: "")
        idleItem.target = self
        idleItem.state = Settings.idleEnabled ? .on : .off
        menu.addItem(idleItem)

        let minutesMenu = NSMenu()
        for m in idleOptions {
            let item = NSMenuItem(title: L10n.minutes(m), action: #selector(selectMinutes(_:)), keyEquivalent: "")
            item.target = self
            item.tag = m
            item.state = Settings.idleMinutes == m ? .on : .off
            minutesMenu.addItem(item)
        }
        let minutesItem = NSMenuItem(title: L10n.duration, action: nil, keyEquivalent: "")
        minutesItem.submenu = minutesMenu
        menu.addItem(minutesItem)

        menu.addItem(.separator())

        let about = NSMenuItem(title: L10n.about, action: #selector(showAbout), keyEquivalent: "")
        about.target = self
        menu.addItem(about)

        let quit = NSMenuItem(title: L10n.quit, action: #selector(quitApp), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)
    }

    // MARK: - Actions

    @objc private func toggleFilter() {
        Settings.filterEnabled.toggle()
        applyFilterSetting()
    }

    @objc private func selectLevel(_ sender: NSMenuItem) {
        guard let level = GammaFilter.Level(rawValue: sender.tag) else { return }
        Settings.filterLevel = level
        applyFilterSetting()
    }

    @objc private func toggleIdle() {
        Settings.idleEnabled.toggle()
        applyIdleSetting()
    }

    @objc private func selectMinutes(_ sender: NSMenuItem) {
        Settings.idleMinutes = sender.tag
        applyIdleSetting()
    }

    @objc private func showAbout() {
        AboutPanel.show()
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    // MARK: - Apply settings

    private func applyFilterSetting() {
        if Settings.filterEnabled {
            gamma.apply(level: Settings.filterLevel)
        } else {
            gamma.remove()
        }
    }

    private func setupIdleMonitor() {
        idleMonitor = IdleMonitor(thresholdSeconds: TimeInterval(Settings.idleMinutes * 60)) {
            DisplaySleep.now()
        }
        applyIdleSetting()
    }

    private func applyIdleSetting() {
        idleMonitor.thresholdSeconds = TimeInterval(Settings.idleMinutes * 60)
        if Settings.idleEnabled {
            idleMonitor.start()
        } else {
            idleMonitor.stop()
        }
    }

    // MARK: - Observers (gamma re-apply after wake / display change)

    private func registerObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(screenParamsChanged),
            name: NSApplication.didChangeScreenParametersNotification, object: nil)

        let wc = NSWorkspace.shared.notificationCenter
        wc.addObserver(self, selector: #selector(screenParamsChanged),
                       name: NSWorkspace.screensDidWakeNotification, object: nil)
        wc.addObserver(self, selector: #selector(screenParamsChanged),
                       name: NSWorkspace.didWakeNotification, object: nil)
    }

    @objc private func screenParamsChanged() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.gamma.reapplyIfActive()
        }
    }
}
