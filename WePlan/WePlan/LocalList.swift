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
            self.sortByDue()
            self.sortByCheck()
            completion()
        }
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
    
    func sortByDue() {
        taskList.sort { (a: TaskItem, b: TaskItem) -> Bool in
            let aDate = a.dueTime
            let bDate = b.dueTime
            let result = aDate.compare(bDate)
            if result == NSComparisonResult.OrderedAscending {
                 //a < b
                return true
            }else{
                return false
            }
            
        }
    }
    
    func sortByCheck() {
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
    }
    
}