//
//  JirassicCell.swift
//  Jirassic
//
//  Created by Cristian Baluta on 17/02/2018.
//  Copyright © 2018 Imagin soft. All rights reserved.
//

import Cocoa

class JirassicCell: NSTableRowView {
    
    static let height = CGFloat(60)
    
    @IBOutlet private var statusImageView: NSImageView!
    @IBOutlet private var textField: NSTextField!
    @IBOutlet private var butInstall: NSButton!
    
    func setJirassicStatus (compatibility: Compatibility) {
        
        if compatibility.available {
            statusImageView.image = compatibility.compatible
                ? NSImage(named: NSImage.statusAvailableName)
                : NSImage(named: "WarningButton")
            textField.stringValue = compatibility.compatible
                ? "Jirassic \(compatibility.currentVersion) installed, type 'jirassic' in Terminal for more info"
                : "Version \(compatibility.currentVersion) installed, min required is \(compatibility.minVersion), please update"
        } else {
            statusImageView.image = NSImage(named: NSImage.statusUnavailableName)
            textField.stringValue = "Not installed, please follow instructions!"
        }
        butInstall.isHidden = compatibility.available && compatibility.compatible
    }
    
    func save() {
        
    }
    
    @IBAction func handleInstallButton (_ sender: NSButton) {
        #if APPSTORE
        AppDelegate.sharedApp().openApplicationScripts()
        #else
//      presenter?.installJirassic()
        #endif
    }
    
}

