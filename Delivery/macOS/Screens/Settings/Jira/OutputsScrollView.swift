//
//  OutputsTableView.swift
//  Jirassic
//
//  Created by Cristian Baluta on 01/02/2018.
//  Copyright © 2018 Imagin soft. All rights reserved.
//

import Cocoa

class OutputsScrollView: NSScrollView {
    
    @IBOutlet fileprivate var tableView: NSTableView!
    var dataSource: OutputTableViewDataSource?// If not declared, the reference is released
    var onPurchasePressed: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.selectionHighlightStyle = .none
        tableView.backgroundColor = .clear
        tableView.intercellSpacing = NSSize(width: 0, height: 30)
        
        dataSource = OutputTableViewDataSource(tableView: tableView)
        dataSource?.onPurchasePressed = { [weak self] in
            self?.onPurchasePressed?()
        }
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        tableView.reloadData()
    }
    
    func save() {
        dataSource?.jiraCell?.save()
        dataSource?.cliHookupCell?.save()
        dataSource?.cocoaHookupCell?.save()
    }
    
    func setHookupStatus (available: Bool) {
        dataSource?.cliHookupCell?.presenter.isShellScriptInstalled = available
        dataSource?.cocoaHookupCell?.presenter.isShellScriptInstalled = available
    }
}
