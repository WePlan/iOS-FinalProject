//
//  ParseAction.swift
//  WePlan
//
//  Created by Kan Chen on 4/1/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation
import Parse

//The whole strutue needs to be modified and updated.
class ParseAction : ParseTask{
    
    private struct TaskConstants {
        static let taskClass = "Task"
        static let taskTitle = "tname"
        static let taskDate = "tdate"
        static let taskLocation = "tlocation"
        static let taskDescription = "tdescription"
        static let taskSort = "tsort"
        static let taskOwner = "towner"
        
        static let uid = "uid"
    }
    
//    private struct UserTaskConstants {
//        static let userid = "uid"
//        static let taskid = "tid"
//    }
    
    class func addTaskItem(task: TaskItem, completion: (String) -> Void) {
        var taskItems = PFObject(className: TaskConstants.taskClass)
        
        taskItems[TaskConstants.taskTitle] = task.taskName
        taskItems[TaskConstants.taskDate] = task.dueTime
        taskItems[TaskConstants.uid] = PFUser.currentUser()!.objectId

        
        taskItems.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                println("Obj created with id: \(taskItems.objectId)")
                completion(taskItems.objectId!)
            }else {
                println("\(error)")
            }
        }
        
        
    }
    
    class func deleteItem(objectId: String) {
        ParseBaseAction.deleteItem(objectId: objectId, inClass: TaskConstants.taskClass)
    }
    
    class func updateTask(completion: Void -> Void) {
        //TODO:
        
        var predicate = NSPredicate(format: "ttitle = 123 AND towner = 321")
        var query = PFQuery(className: TaskConstants.taskClass, predicate: predicate)
        var resultArray = NSArray(array: query.findObjects()!)
        
    }
    
    class func getInitialDataFromParse(completion: ([TaskItem]) -> Void) {
        var data:[TaskItem] = []
        var query = PFQuery(className: TaskConstants.taskClass)
        
        query.whereKey(TaskConstants.uid, equalTo: PFUser.currentUser()!.objectId!)
//        query.whereKeyExists(TaskConstants.taskTitle)
        
        
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                //the find succeeded.
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let title = object.objectForKey(TaskConstants.taskTitle) as! String
                        let due = object.objectForKey(TaskConstants.taskDate) as! NSDate
                        let id = object.objectId
                        
                        var item = TaskItem(name: title, id:id!,due: due ,tagcolor: "")
                        
                        data.append(item)
                    }
                    completion(data)
                }
            }else {
                println("Error \(error)     \(error!.userInfo)")
            }
        }
    }

}


protocol ParseTask {
    static func deleteItem(objectId: String)
    static func getInitialDataFromParse(completion: ([TaskItem]) -> Void)
    static func addTaskItem(task: TaskItem, completion: (String) -> Void)
    /**
    update the task in database
    
    :param: objID?
    
    callback: update task in model
    */
    static func updateTask(completion: Void -> Void)
}
