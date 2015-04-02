//
//  ParseAction.swift
//  WePlan
//
//  Created by Kan Chen on 4/1/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation
import Parse

class ParseAction {
    
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
    
    class func getTaskItemsFromParse(inout tasks: [TaskItem]) {
        
        var query = PFQuery(className: "TaskItems")
        query.whereKeyExists("TaskTitle")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //the find succeeded.
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        tasks.append(TaskItem(name: object.objectForKey("TaskTitle") as String, tagcolor: ""))
                    }
                }
            }else {
                println("Error \(error)     \(error.userInfo)")
            }
        }
//        println("Data is ready")
    }
    
    // MARK: - Login
    /**
    Send a new user request
    
    :param: email,username,password
    
    :returns: result
    */
    class func signUp (email: String, username: String, password: String) -> String {
        var result:String = ""
        // result: "ok","invalid email","invalid username","invalid pwd",etc.
        // TODO: newUserSignUp
        
        return result
    }
    
    /**
    Sign in
    
    :param: email,password
    
    :returns: result
    */
    class func signIn(email: String, password:String) -> String {
        var result:String = ""
        //result:"ok","timeout",etc.
        // TODO: User SignUp
        
        return result
    }
    
    // MARK: - TaskItems
    /**
    
    */
}