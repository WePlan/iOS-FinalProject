//
//  LocalList.swift
//  WePlan
//
//  Created by Kan Chen on 5/4/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

class LocalList {
    static let sharedInstance = LocalList()
    var taskList: [TaskItem]
    var count: Int{
        return taskList.count
    }
    private init () {
        taskList = []
    }
    
    func updateAll(completion: ()->Void) {
        ParseAction.getInitialDataFromParse { (data:[TaskItem]) -> Void in
            self.taskList = data
            self.sortList()
            completion()
        }
    }
    
    func sortList() {
        //sort verified
        var index = 0
        for var i = 0; i < self.count; i++ {
            if self.taskList[index].checked == true {
                let tmp = taskList[index]
                taskList.removeAtIndex(index)
                taskList.append(tmp)
            }else{
                index++
            }
        }
        //sort due
    }
    
    
    func update() {
        //only insert new task
    }
    
    func removeAt(index: Int){
        taskList.removeAtIndex(index)
    }
    
    func swap(# from: Int,  to:Int) {
        let tmp = taskList[from]
        taskList.removeAtIndex(from)
        taskList.insert(tmp, atIndex: to)
    }
}