//
//  ParseAction.swift
//  WePlan
//
//  Created by Kan Chen on 4/1/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation
import Parse

class ParseAction : ParseLogin, ParseTask{
    private struct ParseConstants {
        static let taskClass = "TaskItems"
        static let taskTitle = "TaskTitle"
    }
    class func addTaskItem(taskname: String, completion: (String) -> Void) {
        var taskItems = PFObject(className: ParseConstants.taskClass)
        taskItems[ParseConstants.taskTitle] = taskname
        
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
        var pfQuery = PFQuery(className: ParseConstants.taskClass)
        pfQuery.getObjectInBackgroundWithId(objectId, block: { (result: PFObject! , error: NSError!) -> Void in
            if error == nil {
                result.deleteInBackground()
            }
        })
    }
    
    class func updateTask(completion: Void -> Void) {
        //TODO:
    }
    
    class func getInitialDataFromParse(completion: ([TaskItem]) -> Void) {
        var data:[TaskItem] = []
        var query = PFQuery(className: ParseConstants.taskClass)
        query.whereKeyExists(ParseConstants.taskTitle)
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //the find succeeded.
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var item = TaskItem(name: object.objectForKey(ParseConstants.taskTitle) as String, id: object.objectId,tagcolor: "")
                        
                        data.append(item)
                    }
                    completion(data)
                }
            }else {
                println("Error \(error)     \(error.userInfo)")
            }
        }
    }

    
    class func signIn(email: String, password: String, completion: (result: String) -> Void) {
        completion(result: "success")
        
    }
    
    class func signUp(email: String, username: String, password: String, completion: (result: String) -> Void) {
    
    }
    
}


protocol ParseLogin {
    /**
    Send a new user request
    
    :param: email,username,password
    
    :returns: result
    */
    class func signUp (email: String, username: String, password: String, completion: (result: String) -> Void)
//    {
//    var result:String = ""
//    // result: "ok","invalid email","invalid username","invalid pwd",etc.
//    // TODO: newUserSignUp
//    
//    return result
//    }
    
    /**
    Sign in
    
    :param: email,password
    
    :returns: result
    */
    class func signIn(email: String, password:String, completion: (result: String) -> Void )
//    {
//    var result:String = ""
//    //result:"ok","timeout",etc.
//    // TODO: User SignUp
//    
//    return result
//    }

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

protocol ParseFriend {
    
}

protocol ParseGroup {
    
}
