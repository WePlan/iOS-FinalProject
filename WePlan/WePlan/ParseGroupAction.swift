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
        static let groupClass = "Group"
        static let groupName = "gtitle"
        static let groupDesc = "gdescription"
        static let groupOwner = "gowner"
        static let groupCreatedAt = "createdAt"
        
    }
    
    private struct GroupUserConstant {
        static let groupUserClass = "User_Group"
        static let groupVerified = "verified"
        static let groupId = "gid"
        static let userId = "uid"
    }
    
    private struct UserConstants{
        static let userClass = "_User"
        static let userNickname = "nickname"
        static let userEmail = "email"
    }
    
    func getGroupList (complete : ([Group]) -> Void ) {
        var groupList : [Group] = []
        var groupIdList : [String] = []
        var query = PFQuery(className: GroupUserConstant.groupUserClass)
        query.whereKey(GroupUserConstant.userId, equalTo: PFUser.currentUser()!.objectId!)
        query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, error : NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        if object.objectForKey(GroupUserConstant.groupVerified) as! Bool {
                            var tmp = object.objectForKey(GroupUserConstant.groupId) as! String
                            groupIdList.append(tmp)
                        }
                    }
                    var queryForDetail = PFQuery(className: GroupConstant.groupClass)
                    queryForDetail.whereKey("objectId", containedIn: groupIdList)
                    queryForDetail.findObjectsInBackgroundWithBlock({ (objects : [AnyObject]?, error : NSError?) -> Void in
                        if error == nil {
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    ////////////Stuck! Stop her one Sec!!!!! ----- By Mark
                                }
                            }
                        }
                    })
                }
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
    
    func getGroupMembers (groupId : String, complete : ([User]) -> Void) {
        var memberList : [User] = []
        var memberIdList : [String] = []
        var query = PFQuery(className: GroupUserConstant.groupUserClass)
        query.whereKey(GroupUserConstant.groupId, equalTo: groupId)
        query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, error : NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var tmp = object.objectForKey(GroupUserConstant.userId) as! String
                        memberIdList.append(tmp)
                    }
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
        }
    }
    
    
    
}

//protocol ParseGroup {
//    
//}