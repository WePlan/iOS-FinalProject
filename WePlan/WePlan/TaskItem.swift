//
//  TaskItem.swift
//  WePlan
//
//  Created by Kan Chen on 3/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation
enum TaskKind: Int {
    case Individual = 1, People, Group
}

//Task struture needs to be modified and updated, it's outdated.
class TaskItem {
    //basic
    var taskName: String
    var dueTime: NSDate
    var location: String = ""
    var descript: String = ""
    //advance
    var kind: TaskKind
    var owner: String = ""
    //ui attributes
    var checked: Bool
//    var tagColorName: String
    
    var uniqueId: String // objectId in Parse
    
    init (name: String, id: String = "",due: NSDate,taskOwner:String = "", kind: TaskKind = TaskKind.Individual,descript:String = ""){
        taskName = name
        dueTime = due
        self.descript = descript
        
        uniqueId = id
        owner = taskOwner
        self.kind = kind
        
        
        checked = false
    }
    
}