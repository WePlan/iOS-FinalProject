//
//  TaskItem.swift
//  WePlan
//
//  Created by Kan Chen on 3/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

class TaskItem {
    var taskName: String
    var dueTime: NSDate
    var tagColorName: String
    var checked: Bool
    init (name: String, tagcolor: String){
        taskName = name
        dueTime = NSDate()
        tagColorName = tagcolor
        checked = false
    }
    
}