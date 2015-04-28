//
//  ParseGroupAction.swift
//  WePlan
//
//  Created by ZhangZhaonan on 15/4/16.
//  Copyright (c) 2015年 WP Group. All rights reserved.
//

import Foundation
import Parse

class ParseGroupAction : ParseGroup {
    private struct GroupConstant {
        static let classname = "Group"
        static let grouptitle = "gtitle"
        static let groupDesc = "gdescription"
        static let groupOwner = "gowner"
        static let groupMembers = "members"
        //static let groupCreatedAt = "createdAt"
    }
    
    private struct GroupUserConstant {
        static let classname = "User_Group"
        static let userId = "uid"
        static let groupId = "groupIds"
    }
    
    private struct UserConstants{
        static let userClass = "_User"
        static let userNickname = "nickname"
        static let userEmail = "email"
    }
    
    class func getGroupList(completion: ([Group]) -> Void) {
        let userId = PFUser.currentUser()!.objectId!
        let query = PFQuery(className: GroupUserConstant.classname)
        query.whereKey("uid", equalTo: userId)
        query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let array = object!["groupIds"] as? [String] {
                    // find all groups belong to current user
                    let subQuery = PFQuery(className: GroupConstant.classname)
                    subQuery.whereKey("objectId", containedIn: array)
                    subQuery.findObjectsInBackgroundWithBlock({ (objects:[AnyObject]?, error: NSError?) -> Void in
                        let pfobjects = objects as! [PFObject]
                        var titles:[String] = []
                        var result: [Group] = []
                        for pfobject in pfobjects {
                            let str = pfobject["gtitle"] as! String
                            titles.append(str)
                            
                            let ownerId = pfobject[GroupConstant.groupOwner] as! String
                            let members = pfobject[GroupConstant.groupMembers] as! [String]
                            let desc = pfobject[GroupConstant.groupDesc] as! String
                            var newGroup = Group(id: pfobject.objectId!, name:str, ownerId: ownerId, memberIds: members,description: desc)
                            result.append(newGroup)
                        }
                        completion(result)
                    })
                }
            }
        }
    }
    
    class func createGroup(name:String, ownerId: String, members:[String], desc: String = "None") {
        var group = PFObject(className: GroupConstant.classname)
        //core
        group[GroupConstant.grouptitle] = name
        group[GroupConstant.groupOwner] = ownerId
        group[GroupConstant.groupMembers] = members
        //misc
        group[GroupConstant.groupDesc] = desc
        
        //TODO: update id
        group.saveInBackgroundWithBlock { (success:Bool, error: NSError?) -> Void in
            if success {
                let groupId = group.objectId!
                println("group created with id: \(groupId)")
                //completion?
                //TODO: add groupd id to all members
                self.addGroupIdtoUsers(groupId, userIds: members)
            }else{
                println("##create group error: \(error?.userInfo)")
            }
        }
        
    }
    
    static func addGroupIdtoUsers(groupId: String, userIds: [String]){
        let predicate = NSPredicate(format: "uid IN %@", userIds)
        //TODO: initial usergroup when signup
        var query = PFQuery(className: GroupUserConstant.classname, predicate: predicate)
        
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
    
    func getGroupOwnerDetail (ownerId : String, complete : (User) -> Void) {
        var query = PFQuery(className: UserConstants.userClass)
        query.whereKey("objectId", equalTo: ownerId)
        query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, error : NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        let imgId = object["imageId"] as? String
                        var tmp = User(uid : ownerId, name : object.objectForKey(UserConstants.userNickname) as! String, uemail : object.email!, imageId: imgId)
                        complete(tmp)
                    }
                }
            }
        }
    }
    
    func getGroupMembers (memberIdList : [String], complete : ([User]) -> Void) {
        var memberList : [User] = []
        var queryForDetail = PFQuery(className: UserConstants.userClass)
        queryForDetail.whereKey("objectId", containedIn: memberIdList)
        queryForDetail.findObjectsInBackgroundWithBlock({ (objects : [AnyObject]?, error : NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        let imgId = object["imageId"] as? String
                        var tmp = User(uid : object.objectId!, name : object.objectForKey(UserConstants.userNickname) as! String, uemail : object.email!, imageId: imgId)
                        memberList.append(tmp)
                    }
                    complete(memberList)
                }
            }
        })
    }
    
    
    
}

//protocol ParseGroup {
//    
//}