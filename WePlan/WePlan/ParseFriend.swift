//
//  ParseFriend.swift
//  WePlan
//
//  Created by ZhangZhaonan on 15/4/9.
//  Copyright (c) 2015年 WP Group. All rights reserved.
//

import Foundation
import Parse

class ParseFriendAction : ParseFriend {
    private struct FriendConstants{
        static let friendClass = "Friends"
        static let friendOne = "uid1"
        static let friendTwo = "uid2"
    }
    
    private struct UserConstants{
        static let userClass = "_User"
        static let userNickname = "nickname"
        static let userEmail = "email"
    }
    
    class func searchPeopleByNickname (nickname : String, complete : ([User]) -> Void) {
        var resultList : [User] = []
        var query = PFQuery(className: UserConstants.userClass)
        query.whereKey(UserConstants.userNickname, equalTo: nickname)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        var item = User(name: object.objectForKey(UserConstants.userNickname) as String, uemail: object.email)
                        resultList.append(item)
                    }
                    complete(resultList)
                }
            }else {
                println("Error \(error) \(error.userInfo)")
            }
        }
    }
    
    class func searchPeopleByEmail (email : String, complete : ([User]) -> Void) {
        var resultList : [User] = []
        var query = PFQuery(className: UserConstants.userClass)
        query.whereKey(UserConstants.userEmail, equalTo: email)
        query.findObjectsInBackgroundWithBlock {
            (objects : [AnyObject]!, error : NSError!) -> Void in
            if error == nil{
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        var item = User(name: object.objectForKey(UserConstants.userNickname) as String, uemail: object.email)
                        resultList.append(item)
                    }
                    complete(resultList)
                }
            }
            else{
                println("Error \(error) \(error.userInfo)")
            }
        }
    }
    
    class func getFriendList (complete : ([User]) -> Void) {
        var friendList : [User] = []
        var userIDList : [String] = []
        
        var check_uid1_query = PFQuery(className: FriendConstants.friendClass)
        check_uid1_query.whereKey(FriendConstants.friendOne, equalTo: "ZdohhG7VbV")
        check_uid1_query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]!, error : NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        if object.objectForKey(FriendConstants.friendVerified) as Bool {
                            var tmp = object.objectForKey(FriendConstants.friendTwo) as String
                            userIDList.append(tmp)
                        }
                    }
                    var check_uid2_query = PFQuery(className: FriendConstants.friendClass)
                    check_uid2_query.whereKey(FriendConstants.friendTwo, equalTo: "ZdohhG7VbV")
                    check_uid2_query.findObjectsInBackgroundWithBlock {
                        (objects : [AnyObject]!, error : NSError!) -> Void in
                        if error == nil {
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    if object.objectForKey(FriendConstants.friendVerified) as Bool {
                                        var tmp = object.objectForKey(FriendConstants.friendOne) as String
                                        userIDList.append(tmp)
                                    }
                                }
                                var extract_userinform_query = PFQuery(className: UserConstants.userClass)
                                extract_userinform_query.whereKey("objectId", containedIn: userIDList)
                                extract_userinform_query.findObjectsInBackgroundWithBlock {
                                    (objects : [AnyObject]!, error : NSError!) -> Void in
                                    if error == nil {
                                        if let objects = objects as? [PFUser] {
                                            for object in objects {
                                                var item = User(name: object.objectForKey(UserConstants.userNickname) as String, uemail: object.email)
                                                friendList.append(item)
                                            }
                                            complete(friendList)
                                        }
                                    }
                                    else{
                                        println("Error \(error) \(error.userInfo)")
                                    }
                                }
                            }
                        }
                        else{
                            println("Error \(error) \(error.userInfo)")
                        }
                    }
                }
            }
            else{
                println("Error \(error) \(error.userInfo)")
            }
        }
    }
    
    class func addFriend () {
        
    }
    
    
}

protocol ParseFriend {
    class func searchPeopleByNickname (nickname : String, complete : ([User]) -> Void)
    class func searchPeopleByEmail (email : String, complete : ([User]) -> Void)
    class func getFriendList (complete : [User] -> Void)
}