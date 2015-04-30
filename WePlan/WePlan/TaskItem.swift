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
    //attributes
   
    var taskName: String
    var dueTime: NSDate
    var location: String = ""
    var descript: String = ""
    var kind: TaskKind
    var owner: String = ""
    //ui attributes
    var checked: Bool
    var tagColorName: String
    
    var uniqueId: String
    
    init (name: String, id: String ,due: NSDate,tagcolor: String,taskOwner:String = "", kind: TaskKind = TaskKind.Individual,descript:String = ""){
        taskName = name
        dueTime = due
        tagColorName = tagcolor
        checked = false
        uniqueId = id
        owner = taskOwner
        self.kind = kind
        self.descript = descript
    }
    
}