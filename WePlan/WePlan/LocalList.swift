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
    
    func getNewPathForRemove(task:TaskItem) -> NSIndexPath {
        var index = 0
        let due = task.dueTime
        for var i=0; i < self.count;i++ {
            if !taskList[i].checked || taskList[i].uniqueId == task.uniqueId{
                index++
                continue
            }else{
                let result = due.compare(taskList[i].dueTime)
                if result == NSComparisonResult.OrderedDescending {
                    //due is latter
                    index++
                    continue
                }else{
                    index--
                    break
                }
            }
        }
        if index == self.count {
            index--
        }
//        println("insert index is:\(index)" )
        return NSIndexPath(forRow: index, inSection: 0)
    }

    func getNewPathForBack(task: TaskItem) -> NSIndexPath {
        var index = 0
        let due = task.dueTime
        for var i = 0; i < self.count;i++ {
            if taskList[i].checked {
                break
            }else{
                let result = due.compare(taskList[i].dueTime)
                if result == NSComparisonResult.OrderedDescending {
                    //due is latter
                    index++
                    continue
                }else{
                    break
                }
            }
            
        }
//        println("insert index: \(index)")
        return NSIndexPath(forRow: index, inSection: 0)
    }
    
    func update() {
        //only insert new task
    }
    
    func removeAt(index: Int){
        taskList.removeAtIndex(index)
    }
    
    func swap(from: Int,  to:Int) {
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