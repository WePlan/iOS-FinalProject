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
    
    class func searchPeopleByNickname (nickname : String, complete : ([User]) -> Void) {
        var resultList : [User] = []
        var query = PFQuery(className: "_User")
        query.whereKey("nickname", equalTo: nickname)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        var item = User(name: object.objectForKey("nickname") as String, uemail: object.email)
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
        var query = PFQuery(className: "_User")
        query.whereKey("email", equalTo: email)
        query.findObjectsInBackgroundWithBlock {
            (objects : [AnyObject]!, error : NSError!) -> Void in
            if error == nil{
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        var item = User(name: object.objectForKey("nickname") as String, uemail: object.email)
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
    
    
}

protocol ParseFriend {
    
}