//
//  SettingsViewController.swift
//  Jirassic
//
//  Created by Baluta Cristian on 06/05/15.
//  Copyright (c) 2015 Cristian Baluta. All rights reserved.
//

import Cocoa
import RCPreferences
import RCLog

extension NSToolbarItem.Identifier {
    static let general = NSToolbarItem.Identifier("General")
    static let scripts = NSToolbarItem.Identifier("Scripts")
    static let calendar = NSToolbarItem.Identifier("Calendar")
    static let browser = NSToolbarItem.Identifier("Browser")
    static let jira = NSToolbarItem.Identifier("Jira")
}

class SettingsViewController: NSViewController {

    private var trackingView: GeneralSettingsView?
    private var inputsScrollView: InputsScrollView?
    private var outputsScrollView: OutputsScrollView?
    private var calendarScrollView: CalendarSettingsView?
    private var browserScrollView: BrowserSettingsView?
    private var storeView: StoreView?
    
    weak var appWireframe: AppWireframe?
    var presenter: SettingsPresenterInput?
    private let localPreferences = RCPreferences<LocalPreferences>()
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        createLayer()

        // Setup toolbar
        let toolbar = NSToolbar(identifier: "SettingsToolbar")
        toolbar.delegate = self
        toolbar.allowsUserCustomization = false
        toolbar.autosavesConfiguration = false
        toolbar.displayMode = .default
        self.view.window?.toolbar = toolbar
        
        trackingView = GeneralSettingsView.instantiateFromXib()
        inputsScrollView = InputsScrollView.instantiateFromXib()
        outputsScrollView = OutputsScrollView.instantiateFromXib()
        calendarScrollView = CalendarSettingsView.instantiateFromXib()
        browserScrollView = BrowserSettingsView.instantiateFromXib()
//        storeView = StoreView.instantiateFromXib()
        
        presenter!.checkExtensions()
        presenter!.showSettings()

        trackingView?.onBackupPressed = { [weak self] isOn in
            self?.presenter?.enableBackup(isOn)
        }

        @IBAction func handleLaunchAtStartupButton (_ sender: NSButton) {
            presenter!.enableLaunchAtStartup(sender.state == NSControl.StateValue.on)
        }
//        inputsScrollView?.onPurchasePressed = { [weak self] in
//            self?.presenter?.selectTab(.store)
//        }
//        outputsScrollView?.onPurchasePressed = { [weak self] in
//            self?.presenter?.selectTab(.store)
//        }
        
        #if !APPSTORE
            butBackup.isEnabled = false
            butBackup.state = NSControl.StateValue.off
            butEnableLaunchAtStartup.isEnabled = false
            butEnableLaunchAtStartup.state = NSControl.StateValue.off
        #endif
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        let settings = Settings(
            enableBackup: trackingView!.butBackup.state == NSControl.StateValue.on,
            settingsTracking: trackingView!.settings(),
            settingsBrowser: browserScrollView!.settings()
        )
        presenter!.saveAppSettings(settings)
        
        trackingView?.save()
        inputsScrollView?.save()
        outputsScrollView?.save()
    }
    
    deinit {
        RCLog("deinit")
    }
    
    func removeSelectedTabView() {
        trackingView!.removeFromSuperview()
        inputsScrollView!.removeFromSuperview()
        outputsScrollView!.removeFromSuperview()
        calendarScrollView!.removeFromSuperview()
        browserScrollView!.removeFromSuperview()
//        storeView!.removeFromSuperview()
    }
}

extension SettingsViewController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        switch itemIdentifier {
        case .general:
            toolbarItem.label = "General"
            toolbarItem.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General")
            toolbarItem.target = self
            toolbarItem.action = #selector(switchToGeneralSettings)
        case .scripts:
            toolbarItem.label = "Scripts"
            toolbarItem.image = NSImage(systemSymbolName: "applescript", accessibilityDescription: "Scripts")
            toolbarItem.target = self
            toolbarItem.action = #selector(switchToInputSettings)
        case .jira:
            toolbarItem.label = "Jira"
            toolbarItem.image = NSImage(systemSymbolName: "applescript", accessibilityDescription: "Jira")
            toolbarItem.target = self
            toolbarItem.action = #selector(switchToJiraSettings)
        case .calendar:
            toolbarItem.label = "Calendar"
            toolbarItem.image = NSImage(systemSymbolName: "calendar", accessibilityDescription: "Calendar")
            toolbarItem.target = self
            toolbarItem.action = #selector(switchToCalendarSettings)
        case .browser:
            toolbarItem.label = "Browser"
            toolbarItem.image = NSImage(systemSymbolName: "network", accessibilityDescription: "Browser")
            toolbarItem.target = self
            toolbarItem.action = #selector(switchToBrowserSettings)
        default:
            return nil
        }
        return toolbarItem
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.general, .scripts, .calendar, .browser]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.general, .scripts, .calendar, .browser]
    }

    @objc func switchToGeneralSettings() {
        selectTab(.general)
    }

    @objc func switchToInputSettings() {
        selectTab(.scripts)
    }

    @objc func switchToCalendarSettings() {
        selectTab(.calendar)
    }

    @objc func switchToBrowserSettings() {
        selectTab(.browser)
    }

    @objc func switchToJiraSettings() {
        selectTab(.jira)
    }
}

extension SettingsViewController: Animatable {
    
    func createLayer() {
        view.layer = CALayer()
        view.wantsLayer = true
    }
}

extension SettingsViewController: SettingsPresenterOutput {
    
    func setShellStatus (compatibility: Compatibility) {
        inputsScrollView?.setShellStatus (compatibility: compatibility)
    }
    
    func setJirassicStatus (compatibility: Compatibility) {
        inputsScrollView?.setJirassicStatus (compatibility: compatibility)
    }
    
    func setJitStatus (compatibility: Compatibility) {
        inputsScrollView?.setJitStatus (compatibility: compatibility)
    }
    
    func setGitStatus (available: Bool) {
        inputsScrollView?.setGitStatus (available: available)
    }
    
    func setBrowserStatus (compatibility: Compatibility) {
        browserScrollView?.setBrowserStatus (compatibility: compatibility)
    }
    
    func setHookupStatus (available: Bool) {
        outputsScrollView?.setHookupStatus (available: available)
    }
    
    func showAppSettings (_ settings: Settings) {
        trackingView?.showSettings(settings.settingsTracking)
        trackingView?.butBackup.state = settings.enableBackup ? NSControl.StateValue.on : NSControl.StateValue.off
        browserScrollView?.showSettings(settings.settingsBrowser)
    }
    
    func enableLaunchAtStartup (_ enabled: Bool) {
        trackingView!.butEnableLaunchAtStartup.state = enabled ? NSControl.StateValue.on : NSControl.StateValue.off
    }
    
    func enableBackup (_ enabled: Bool, title: String) {
        trackingView!.butBackup.state = enabled ? NSControl.StateValue.on : NSControl.StateValue.off
        trackingView!.butBackup.title = title
    }
    
    func selectTab (_ tab: SettingsTab) {
        removeSelectedTabView()
        switch tab {
        case .general:
            view.addSubview(trackingView!)
            trackingView!.constrainToSuperview()
        case .scripts:
            view.addSubview(inputsScrollView!)
            inputsScrollView!.constrainToSuperview()
        case .jira:
            view.addSubview(outputsScrollView!)
            outputsScrollView!.constrainToSuperview()
        case .calendar:
            view.addSubview(calendarScrollView!)
            calendarScrollView!.constrainToSuperview()
        case .browser:
            view.addSubview(browserScrollView!)
            browserScrollView!.constrainToSuperview()
        }
    }
}
