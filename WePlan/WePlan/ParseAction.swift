//
//  ParseAction.swift
//  WePlan
//
//  Created by Kan Chen on 4/1/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation
import Parse

class ParseAction : ParseTask{
    
    private struct TaskConstants {
        static let taskClass = "Task"
        static let taskTitle = "tname"
        static let taskDate = "tdate"
        static let taskLocation = "tlocation"
        static let taskDescription = "tdescription"
        static let taskSort = "tsort"
        static let taskOwner = "towner"
    }
    
    class func addTaskItem(taskname: String, completion: (String) -> Void) {
        var taskItems = PFObject(className: TaskConstants.taskClass)
        taskItems[TaskConstants.taskTitle] = taskname
        
        taskItems.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if success {
                println("Obj created with id: \(taskItems.objectId)")
                completion(taskItems.objectId)
            }else {
                println("\(error)")
            }
        }
    }
    
    class func deleteItem(objectId: String) {
        // TODO:
        var pfQuery = PFQuery(className: TaskConstants.taskClass)
        pfQuery.getObjectInBackgroundWithId(objectId, block: { (result: PFObject! , error: NSError!) -> Void in
            if error == nil {
                result.deleteInBackground()
            }
        })
    }
    
    class func updateTask(completion: Void -> Void) {
        //TODO:
        
        var predicate = NSPredicate(format: "ttitle = 123 AND towner = 321")
        var query = PFQuery(className: TaskConstants.taskClass, predicate: predicate)
        var resultArray = NSArray(array: query.findObjects())
        
    }
    
    class func getInitialDataFromParse(completion: ([TaskItem]) -> Void) {
        var data:[TaskItem] = []
        var query = PFQuery(className: TaskConstants.taskClass)
        query.whereKeyExists(TaskConstants.taskTitle)
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //the find succeeded.
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var item = TaskItem(name: object.objectForKey(TaskConstants.taskTitle) as String, id: object.objectId,tagcolor: "")
                        
                        data.append(item)
                    }
                    completion(data)
                }
            }else {
                println("Error \(error)     \(error.userInfo)")
            }
        }
    }

}


protocol ParseTask {
    class func deleteItem(objectId: String)
    class func getInitialDataFromParse(completion: ([TaskItem]) -> Void)
    class func addTaskItem(taskname: String, completion: (String) -> Void)
    /**
    update the task in database
    
    :param: objID?
    
    callback: update task in model
    */
    class func updateTask(completion: Void -> Void)
}

protocol ParseGroup {
    
}
