//
//  Report.swift
//  Jirassic
//
//  Created by Cristian Baluta on 06/11/2016.
//  Copyright © 2016 Cristian Baluta. All rights reserved.
//

import Foundation

/// This is one Task converted to Report
struct Report {
    
    var taskNumber: String
    var title: String
    var notes: String?
    var duration: TimeInterval
}

/// All occurences of the same Report
struct CombinedReports {

    var taskNumber: String
    var title: String
    var notes: [String]
    var duration: TimeInterval
}
