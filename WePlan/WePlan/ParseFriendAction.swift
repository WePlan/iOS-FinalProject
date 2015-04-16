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
        static let friendVerified = "verified"
    }
    
    private struct UserConstants{
        static let userClass = "_User"
        static let userNickname = "nickname"
        static let userEmail = "email"
    }
    
    class func searchPeopleByNickname (nickname : String, friendSet : Set<String>, complete : ([User]) -> Void) {
        if !nickname.isEmpty {
            var resultList : [User] = []
            var query = PFQuery(className: UserConstants.userClass)
            query.whereKey(UserConstants.userNickname, hasPrefix: nickname)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects as? [PFUser] {
                        for object in objects {
                            var item = User(name: object.objectForKey(UserConstants.userNickname) as! String, uemail: object.email!)
                            if !friendSet.contains(object.email!) {
                                resultList.append(item)
                            }
                        }
                        complete(resultList)
                    }
                }else {
                    println("Error \(error) \(error!.userInfo)")
                }
            }
        }
    }
    
    class func searchPeopleByEmail (email : String, friendSet : Set<String>, complete : ([User]) -> Void) {
        var resultList : [User] = []
        var query = PFQuery(className: UserConstants.userClass)
        query.whereKey(UserConstants.userEmail, equalTo: email)
        query.findObjectsInBackgroundWithBlock {
            (objects : [AnyObject]?, error : NSError?) -> Void in
            if error == nil{
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        var item = User(name: object.objectForKey(UserConstants.userNickname) as! String, uemail: object.email!)
                        if !friendSet.contains(object.email!) {
                            resultList.append(item)
                        }
                    }
                    complete(resultList)
                }
            }
            else{
                println("Error \(error) \(error!.userInfo)")
            }
        }
    }
    
    class func getFriendList (complete : ([User]) -> Void) {
        var friendSet = [String : String]()
        var friendList : [User] = []
        var userIDList : [String] = []
        
        var check_uid1_query = PFQuery(className: FriendConstants.friendClass)
        check_uid1_query.whereKey(FriendConstants.friendOne, equalTo: PFUser.currentUser()!.objectId!)
        check_uid1_query.findObjectsInBackgroundWithBlock { (objects : [AnyObject]?, error : NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        if object.objectForKey(FriendConstants.friendVerified) as! Bool {
                            var tmp = object.objectForKey(FriendConstants.friendTwo) as! String
                            userIDList.append(tmp)
                        }
                    }
                    var check_uid2_query = PFQuery(className: FriendConstants.friendClass)
                    check_uid2_query.whereKey(FriendConstants.friendTwo, equalTo: PFUser.currentUser()!.objectId!)
                    check_uid2_query.findObjectsInBackgroundWithBlock {
                        (objects : [AnyObject]?, error : NSError?) -> Void in
                        if error == nil {
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    if object.objectForKey(FriendConstants.friendVerified) as! Bool {
                                        var tmp = object.objectForKey(FriendConstants.friendOne) as! String
                                        userIDList.append(tmp)
                                    }
                                }
                                var extract_userinform_query = PFQuery(className: UserConstants.userClass)
                                extract_userinform_query.whereKey("objectId", containedIn: userIDList)
                                extract_userinform_query.findObjectsInBackgroundWithBlock {
                                    (objects : [AnyObject]?, error : NSError?) -> Void in
                                    if error == nil {
                                        if let objects = objects as? [PFUser] {
                                            for object in objects {
                                                var item = User(name: object.objectForKey(UserConstants.userNickname) as! String, uemail: object.email!)
                                                friendList.append(item)
                                                friendSet.updateValue(object.objectForKey(UserConstants.userNickname) as! String, forKey: object.email!)
                                            }
                                            complete(friendList)
                                        }
                                    }
                                    else{
                                        println("Error \(error) \(error!.userInfo)")
                                    }
                                }
                            }
                        }
                        else{
                            println("Error \(error) \(error!.userInfo)")
                        }
                    }
                }
            }
            else{
                println("Error \(error) \(error!.userInfo)")
            }
        }
    }
    
    class func addFriend () {
        
    }
    
    class func deleteFriend(objectId : String) {
        var first_predicate = NSPredicate(format: "uid1 == %@ AND uid2 == %@", objectId, PFUser.currentUser()!.objectId!)
        var first_query = PFQuery(className: FriendConstants.friendClass, predicate: first_predicate)
        first_query.getFirstObjectInBackgroundWithBlock { (result : PFObject?, error : NSError?) -> Void in
            if error == nil {
                result!.deleteInBackgroundWithBlock(nil)
            }
            else{
                var second_predicate = NSPredicate(format: "uid1 == %@ AND uid2 == %@", PFUser.currentUser()!.objectId!, objectId)
                var second_query = PFQuery(className: FriendConstants.friendClass, predicate: second_predicate)
                second_query.getFirstObjectInBackgroundWithBlock({ (result : PFObject?, error : NSError?) -> Void in
                    if error == nil {
                        result!.deleteInBackgroundWithBlock(nil)
                    }
                })
            }
        }
    }
    
}

protocol ParseFriend {
    static func searchPeopleByNickname (nickname : String, friendSet : Set<String>, complete : ([User]) -> Void)
    static func searchPeopleByEmail (email : String, friendSet : Set<String>, complete : ([User]) -> Void)
    static func getFriendList (complete : ([User]) -> Void)
    static func deleteFriend (objectId : String)
}