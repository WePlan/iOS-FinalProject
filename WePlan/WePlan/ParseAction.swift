//
//  ParseAction.swift
//  WePlan
//
//  Created by Kan Chen on 4/1/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation
import Parse

class ParseAction : ParseLogin {
    
    class func addTaskItem(taskname: String)  {
        var taskItems = PFObject(className: "TaskItems")
        taskItems["TaskTitle"] = taskname
        taskItems.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if success {
                println("Obj created with id: \(taskItems.objectId)")
            }else {
                println("\(error)")
            }
        }
    }
    class func deleteTaskItem() {
        
    
    }
    
    class func getInitialDataFromParse(completion: ([TaskItem]) -> Void) {
        var data:[TaskItem] = []
        var query = PFQuery(className: "TaskItems")
        query.whereKeyExists("TaskTitle")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //the find succeeded.
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var item = TaskItem(name: object.objectForKey("TaskTitle") as String, tagcolor: "")
                        
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
    class func deleteItem()
}

protocol ParseFriend {
    
}

protocol ParseGroup {
    
}
