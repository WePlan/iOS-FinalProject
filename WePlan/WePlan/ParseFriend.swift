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
        static let friendTwo = "udi2"
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
    
    class func getFriendList (complete : [User] -> Void) {
        var friendList : [User] = []
        var userIDList : [String] = []
        var first_query = PFQuery(className: FriendConstants.friendClass)
        first_query.whereKey(FriendConstants.friendOne, equalTo: PFUser.currentUser().objectId)
        first_query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]!, error : NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var tmp = object.objectForKey(FriendConstants.friendTwo) as String
                        userIDList.append(tmp)
                    }
                }
            }
            else{
                println("Error \(error) \(error.userInfo)")
            }
        }
        
        var second_query = PFQuery(className: FriendConstants.friendClass)
        second_query.whereKey(FriendConstants.friendTwo, equalTo: PFUser.currentUser().objectId)
        second_query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]!, error : NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var tmp = object.objectForKey(FriendConstants.friendOne) as String
                        userIDList.append(tmp)
                    }
                }
            }
            else{
                println("Error \(error) \(error.userInfo)")
            }
        }
        
        let predicate = NSPredicate(format: "objectID IN \(userIDList)")
        var third_query = PFQuery(className: UserConstants.userClass, predicate: predicate)
        third_query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]!, error : NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        var item = User(name: object.objectForKey(UserConstants.userNickname) as String, uemail: UserConstants.userEmail)
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

protocol ParseFriend {
    class func searchPeopleByNickname (nickname : String, complete : ([User]) -> Void)
    class func searchPeopleByEmail (email : String, complete : ([User]) -> Void)
    class func getFriendList (complete : [User] -> Void)
}