//
//  ParseGroupAction2.swift
//  WePlan
//
//  Created by Kan Chen on 4/24/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

class ParseGroupAction2 {
    private struct GroupConstant {
        static let classname = "Group"
        static let name = "gtitle"
        static let desc = "gdescription"
        static let members = "members"
        static let owner = "gowner"
    }
    
    private struct User{
        static let classname = "_User"
    }
    
    private struct UserGroup{
        static let classname = "User_Group"
    }
    
    class func getGroupList() {
        
    }
    
    class func createGroup(name:String, ownerId: String, members:[String], desc: String = "None") {
        var group = PFObject(className: GroupConstant.classname)
        //core
        group[GroupConstant.name] = name
        group[GroupConstant.owner] = ownerId
        group[GroupConstant.members] = members
        //misc
        group[GroupConstant.desc] = desc
        
        //TODO: update id
        group.saveInBackgroundWithBlock { (success:Bool, error: NSError?) -> Void in
            if success {
                let groupId = group.objectId!
                println("group created with id: \(groupId)")
                //completion?
                //TODO: add groupd id to all members
                self.addGroupIdtoUsers2(groupId, userIds: members)
            }else{
                println("##create group error: \(error?.userInfo)")
            }
        }
        
    }
    
    static func addGroupIdtoUsers(groupId: String, userIds:[String]) {
        let predicate = NSPredicate(format: "objectId IN %@", userIds)
        var query = PFQuery(className: User.classname, predicate: predicate)
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil{
                println("we get \(objects?.count)")
                let objects = objects as! [PFObject]
                for object in objects {
                    let str = object["nickname"] as! String
                    println(str)
                    
                    var groups = object["groupIds"] as? [String]
                    if groups == nil {
                        groups = []
                    }
                    groups?.append(groupId)
                    object["groupIds"] = groups!
                }
                PFObject.saveAllInBackground(objects, block: { (success:Bool, error:NSError?) -> Void in
                    if error != nil {
                        println("group update success")
                    }else{
                        println("\(error?.userInfo)")
                    }
                })
            }else{
                println(error?.userInfo)
            }
        }
        
    }
    
    static func addGroupIdtoUsers2(groupId: String, userIds: [String]){
        let predicate = NSPredicate(format: "uid IN %@", userIds)
        //TODO: initial usergroup when signup
        var query = PFQuery(className: UserGroup.classname, predicate: predicate)
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil{
                println("we get \(objects?.count)")
                let objects = objects as! [PFObject]
                for object in objects {
                    
                    var groups = object["groupIds"] as? [String]
                    if groups == nil {
                        groups = []
                    }
                    groups?.append(groupId)
                    object["groupIds"] = groups!
                }
                PFObject.saveAllInBackground(objects, block: { (success:Bool, error:NSError?) -> Void in
                    if error == nil {
                        println("group update success")
                    }else{
                        println("\(error?.userInfo)")
                    }
                })
            }else{
                println(error?.userInfo)
            }
        }

    }
    
    
    class func deleteGroup() {
        
    }
    
    class func updateGroup() {
        
    }
    
}


