//
//  JitCell.swift
//  Jirassic
//
//  Created by Cristian Baluta on 01/02/2018.
//  Copyright © 2018 Imagin soft. All rights reserved.
//

import Cocoa
import RCPreferences

class JitCell: NSTableRowView {

    static let height = CGFloat(135)
    
    @IBOutlet private var statusImageView: NSImageView!
    @IBOutlet private var statusImageViewGapToButEnableConstraint: NSLayoutConstraint!
    @IBOutlet private var textField: NSTextField!
    @IBOutlet private var butInstall: NSButton!
    @IBOutlet private var butEnable: NSButton!

    private let prefs = RCPreferences<LocalPreferences>()

    override func awakeFromNib() {
        super.awakeFromNib()
        butEnable.isHidden = true
        statusImageView.isHidden = false
    }

    func save() {

    }
    
    func setJitStatus (compatibility: Compatibility) {
        
        if compatibility.available {
            statusImageView.image = compatibility.compatible
                ? NSImage(named: NSImage.statusAvailableName)
                : NSImage(named: "WarningButton")
            statusImageViewGapToButEnableConstraint.constant = compatibility.compatible ? -14 : 5
            
            textField.stringValue = compatibility.compatible
                ? "Jit \(compatibility.currentVersion) installed, type 'jit' in Terminal for more info"
                : "Version \(compatibility.currentVersion) installed, min required is \(compatibility.minVersion), please update"
            
            butEnable.state = prefs.bool(.enableJit) ? .on : .off
        } else {
            statusImageView.image = NSImage(named: NSImage.statusUnavailableName)
            textField.stringValue = "Cannot determine Jit compatibility, install shell support first!"
        }
        butInstall.isHidden = compatibility.available && compatibility.compatible
        butEnable.isHidden = !compatibility.available
        statusImageView.isHidden = compatibility.available && compatibility.compatible
    }

    @IBAction func handleInstallButton (_ sender: NSButton) {
        #if APPSTORE
        AppDelegate.sharedApp().openApplicationScripts()
        #else
//      presenter?.installJit()
        #endif
    }
    
    @IBAction func handleEnableButton (_ sender: NSButton) {
        prefs.set(sender.state == .on, forKey: .enableJit)
    }
}

