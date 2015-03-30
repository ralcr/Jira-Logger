//
//  NotesCellDataSource.swift
//  Jira-Logger
//
//  Created by Baluta Cristian on 28/03/15.
//  Copyright (c) 2015 Cristian Baluta. All rights reserved.
//

import Cocoa

let kTaskCellIdentifier = "TaskCellIdentifier"

class TaskCellDataSource: NSObject, NSTableViewDataSource, NSTableViewDelegate {
	
	var tableView: NSTableView? {
		didSet {
			if let nib = NSNib(nibNamed: "TaskCell", bundle: NSBundle.mainBundle()) {
				tableView?.registerNib( nib, forIdentifier: kTaskCellIdentifier)
			}
		}
	}
	var data: [JiraData]?
	var didSelectRow: ((row: Int) -> ())?
	
	
	func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
		
		if let d = data {
			return d.count
		}
		return 0
	}
	
	func tableView(tableView: NSTableView!,
		viewForTableColumn tableColumn: NSTableColumn!, row: Int) -> NSView! {
			
			let object = data![row] as JiraData
			let view = self.tableView?.makeViewWithIdentifier(kTaskCellIdentifier, owner: self) as TaskCell
			view.issueNrTextField?.stringValue = object.issue_nr!
			view.notesTextField?.stringValue = object.notes!
			
			return view
	}
	
	func tableView(tableView: NSTableView, setObjectValue object: AnyObject?,
		forTableColumn tableColumn: NSTableColumn?, row: Int) {

			RCLog("set object value for row \(row)")
//			data?[row].setObject(object!, forKey: (tableColumn?.identifier)!)
	}
	
	func tableViewSelectionDidChange(aNotification: NSNotification) {
		
		if let rowView: AnyObject = aNotification.object? {
			if didSelectRow != nil {
				didSelectRow!(row: rowView.selectedRow)
			}
		}
	}
	
	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 70.0
	}
	
	
	// Actions
	
	func addObjectWithDate(date: NSDate) {
		
		let d = JiraData()
		d.date_task_finished = date
		d.issue_nr = "AN-0000"
		d.notes = "......"
		
		data?.append( d )
	}
}