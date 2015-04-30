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
        var pfTask = PFObject(className: TaskConstants.taskClass)
        //basic
        pfTask[TaskConstants.taskTitle] = task.taskName
        pfTask[TaskConstants.taskDate] = task.dueTime
        pfTask[TaskConstants.taskDescription] = task.descript
        pfTask[TaskConstants.taskLocation] = task.location
        //advanced
        pfTask[TaskConstants.taskSort] = 1
        pfTask[TaskConstants.uid] = PFUser.currentUser()!.objectId!
        pfTask[TaskConstants.taskOwner] = PFUser.currentUser()!.objectId!
        

        
        pfTask.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                println("self Task Obj created with id: \(pfTask.objectId)")
                completion(pfTask.objectId!)
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
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                //the find succeeded.
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        //basic
                        let id = object.objectId
                        let title = object.objectForKey(TaskConstants.taskTitle) as! String
                        let due = object.objectForKey(TaskConstants.taskDate) as! NSDate
                        let descript = object.objectForKey(TaskConstants.taskDescription) as! String

                        let kindInt = object.objectForKey(TaskConstants.taskSort) as? Int
                        let owner = object.objectForKey(TaskConstants.taskOwner) as? String
                        var item: TaskItem
                        assert(kindInt != nil && owner != nil, "both sort and owner have value")
                        if kindInt != nil && owner != nil{
                            let kind = TaskKind(rawValue: kindInt!)
                            item = TaskItem(name: title, id:id!,due: due ,taskOwner:owner!,kind:kind!,descript:descript)
                        }else {
                            item = TaskItem(name: title, id:id!,due: due, descript: descript)
                        }
                        
                        
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
