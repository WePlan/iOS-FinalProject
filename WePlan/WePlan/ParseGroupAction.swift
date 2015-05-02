//
//  ParseGroupAction.swift
//  WePlan
//
//  Created by ZhangZhaonan on 15/4/16.
//  Copyright (c) 2015年 WP Group. All rights reserved.
//

import Foundation
import Parse

class ParseGroupAction : ParseGroup{
    
    private struct GroupConstant {
        static let classname = "Group"
        static let grouptitle = "gtitle"
        static let groupDesc = "gdescription"
        static let groupOwner = "gowner"
        static let groupMembers = "members"
        //static let groupCreatedAt = "createdAt"
        static let groupImage = "groupImage"
    }
    
    private struct GroupUserConstant {
        static let classname = "User_Group"
        static let userId = "uid"
        static let groupIds = "groupIds"
    }
    
    private struct UserConstants{
        static let userClass = "_User"
        static let userNickname = "nickname"
        static let userEmail = "email"
    }
    
    private struct TaskConstants{
        static let classname = "Task"
        static let taskTitle = "tname"
        static let taskDate = "tdate"
        static let taskLocation = "tlocation"
        static let taskDescription = "tdescription"
        static let taskType = "tsort"
        static let taskOwner = "towner"
        static let taskUid = "uid"
    }
    //tsort = 3, towner = groupId, uid = member's objectId
    //Add task to Task Class
    class func assignGroupTask (task : TaskItem, groupId : String, members : [String], complete : () -> Void) {
        var objects : [PFObject] = []
        for member in members {
            var newRow = PFObject(className: TaskConstants.classname)
            newRow[TaskConstants.taskTitle] = task.taskName
            newRow[TaskConstants.taskDate] = task.dueTime
            newRow[TaskConstants.taskLocation] = task.location
            newRow[TaskConstants.taskDescription] = task.descript
            newRow[TaskConstants.taskType] = 3
            newRow[TaskConstants.taskOwner] = groupId
            newRow[TaskConstants.taskUid] = member
            objects.append(newRow)
        }
        PFObject.saveAllInBackground(objects) { (success : Bool, error : NSError?) -> Void in
            if success {
                println("Group Task Added! Count: \(objects.count)")
                complete()
            }
            else{
                println(error?.userInfo)
            }
        }
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
                            let file = pfobject[GroupConstant.groupImage] as? PFFile
                            var newGroup = Group(id: pfobject.objectId!, name:str, ownerId: ownerId, memberIds: members,description: desc, groupImage: file)
                            
                            result.append(newGroup)
                        }
                        completion(result)
                    })
                }
            }
        }
    }
    
    class func createGroup(name:String, ownerId: String, members:[String], desc: String = "None",groupImage: UIImage?, completion: () -> Void) {
        let imageFile: PFFile?
        if groupImage != nil {
            let data = UIImagePNGRepresentation(groupImage)
            imageFile = PFFile(name: "GroupImage.png", data: data)
        }else{
            imageFile = nil
        }
        
        var pfGroup = PFObject(className: GroupConstant.classname)
        //core
        pfGroup[GroupConstant.grouptitle] = name
        pfGroup[GroupConstant.groupOwner] = ownerId
        pfGroup[GroupConstant.groupMembers] = members
        //misc
        pfGroup[GroupConstant.groupDesc] = desc
        if let file = imageFile {
            pfGroup[GroupConstant.groupImage] = file
        }
        pfGroup.saveInBackgroundWithBlock { (success:Bool, error: NSError?) -> Void in
            if success {
                let groupId = pfGroup.objectId!
                println("group created with id: \(groupId)")
                
                self.addGroupIdtoUsers(groupId, userIds: members, completion: completion)
            }else{
                println("##create group error: \(error?.userInfo)")
            }
        }
        
    }
    
    private static func addGroupIdtoUsers(groupId: String, userIds: [String], completion: ()-> Void){
        var tmpUserIds = Set<String>()
        var query = PFQuery(className: GroupUserConstant.classname)
        query.whereKey(GroupUserConstant.userId, containedIn: userIds)
        
        //find all User in this group and update their gIds
        query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, error : NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        var tmpUserId = object[GroupUserConstant.userId] as! String
                        tmpUserIds.insert(tmpUserId)
                        
                        var groups = object[GroupUserConstant.groupIds] as! [String]
                        groups.append(groupId)
                        object[GroupUserConstant.groupIds] = groups
                        
                    }
                    PFObject.saveAllInBackground(objects, block: { (success : Bool, error : NSError?) -> Void in
                        if success {
                            println("groupIds update successfully")
                            completion()
                        }
                        else{
                            println(error?.userInfo)
                        }
                    })
                }
                assert(tmpUserIds.count == userIds.count, "user's count != tmp's count")
                if tmpUserIds.count != userIds.count {
                    for userId in userIds {
                        if !tmpUserIds.contains(userId) {
                            self.createNewRowForGroupUser(userId, groupId: groupId)
                        }
                    }
                }
            }
            else{
                assert(tmpUserIds.count == userIds.count, "user's count != tmp's count")
                for userId in userIds {
                    self.createNewRowForGroupUser(userId, groupId: groupId)
                }
            }
        }
    }
    
    static func createNewRowForGroupUser (userId : String, groupId : String) {
        var newGroupIds : [String] = []
        newGroupIds.append(groupId)
        var subquery = PFObject(className: GroupUserConstant.classname)
        subquery[GroupUserConstant.userId] = userId
        subquery[GroupUserConstant.groupIds] = newGroupIds
        subquery.saveInBackgroundWithBlock({ (success : Bool, error : NSError?) -> Void in
            if success {
                println("Record with uid \(userId) has been added.")
            }
            else{
                println("\(error?.userInfo)")
            }
        })
    }
    
    class func getGroupOwnerDetail (ownerId : String, complete : (User) -> Void) {
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
    
    class func getGroupMembers (memberIdList : [String], complete : ([User]) -> Void) {
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
    
    class func updateGroup (groupId : String, name : String, members : [String], desc : String) {
        var query = PFQuery(className: GroupConstant.classname)
        query.getObjectInBackgroundWithId(groupId) { (object : PFObject?, error : NSError?) -> Void in
            if error == nil {
                if let object = object {
                    object[GroupConstant.grouptitle] = name
                    object[GroupConstant.groupDesc] = desc
                    object[GroupConstant.groupMembers] = members
                    object.saveInBackgroundWithBlock({ (success : Bool, error : NSError?) -> Void in
                        if success {
                            println("Group with ID \(groupId) has been updated")
                        }
                        else{
                            println("\(error?.userInfo)")
                        }
                    })
                }
            }
        }
    }
    
    class func quitGroup (groupId : String) {
        var uid = PFUser.currentUser()?.objectId
        var query_Group = PFQuery(className: GroupConstant.classname)
        query_Group.getObjectInBackgroundWithId(groupId, block: { (object : PFObject?, error : NSError?) -> Void in
            if error == nil {
                if let object = object {
                    var members = object[GroupConstant.groupMembers] as! [String]
                    var index = 0
                    for each in members {
                        if each == uid {
                            break
                        }
                        else{
                            index++
                        }
                    }
                    members.removeAtIndex(index)
                    object[GroupConstant.groupMembers] = members
                    object.saveInBackgroundWithBlock({ (success : Bool, error : NSError?) -> Void in
                        if success {
                            println("User \(uid) has quit the group \(groupId)")
                            self.handleUserGroupWhenQuit(groupId)
                        }
                        else{
                            println(error?.userInfo)
                        }
                    })
                }
            }
        })
    }
    
    static func handleUserGroupWhenQuit (groupId : String) {
        var uid = PFUser.currentUser()?.objectId
        var query = PFQuery(className: GroupUserConstant.classname)
        query.whereKey(GroupUserConstant.userId, equalTo: uid!)
        query.getFirstObjectInBackgroundWithBlock { (object : PFObject?, error : NSError?) -> Void in
            if error == nil {
                if let object = object {
                    var groups = object[GroupUserConstant.groupIds] as! [String]
                    var index = 0
                    println("---------\(uid),")
                    for each in groups {
                        if each == groupId{
                            break
                        }
                        else{
                            index++
                        }
                    }
                    groups.removeAtIndex(index)
                    object[GroupUserConstant.groupIds] = groups
                    object.saveInBackgroundWithBlock({ (success : Bool, error : NSError?) -> Void in
                        if success {
                            println("UG has been midified on user \(uid)")
                        }
                        else{
                            println(error?.userInfo)
                        }
                    })
                }
            }
        }
    }
    
    class func dismissGroup (groupId : String) {
        var query = PFQuery(className: GroupConstant.classname)
        query.getObjectInBackgroundWithId(groupId, block: { (object : PFObject?, error : NSError?) -> Void in
            if error == nil {
                if let object = object {
                    var members = object[GroupConstant.groupMembers] as! [String]
                    object.deleteInBackground()
                    self.handleUserGroupWhenDismiss(groupId, members : members)
                }
            }
        })
    }
    
    static func handleUserGroupWhenDismiss(groupId : String, members : [String]) {
        for member in members {
            var query = PFQuery(className: GroupUserConstant.classname)
            query.whereKey(GroupUserConstant.userId, equalTo: member)
            query.getFirstObjectInBackgroundWithBlock({ (object : PFObject?, error : NSError?) -> Void in
                if error == nil {
                    if let object = object {
                        var groups = object[GroupUserConstant.groupIds] as! [String]
                        var index = 0
                        for each in groups {
                            if each == groupId {
                                break
                            }
                            else{
                                index++
                            }
                        }
                        groups.removeAtIndex(index)
                        object[GroupUserConstant.groupIds] = groups
                        object.saveInBackgroundWithBlock({ (success : Bool, error : NSError?) -> Void in
                            if success {
                                println("UG has been modified when group \(groupId) was dismissed")
                            }
                            else{
                                println(error?.userInfo)
                            }
                        })
                    }
                }
            })
        }
    }
    
    
}

protocol ParseGroup {
    static func getGroupList(completion: ([Group]) -> Void)
//    static func createGroup(name:String, ownerId: String, members:[String], desc: String)
//    static func addGroupIdtoUsers(groupId: String, userIds: [String])
}