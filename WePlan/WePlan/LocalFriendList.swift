//
//  LocalFriendList.swift
//  WePlan
//
//  Created by Kan Chen on 4/24/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

class LocalFriendList {
    static let sharedInstance = LocalFriendList()
    
    var friendList: [User]
    var count: Int{
        get{
            return friendList.count
        }
    }
    
    private init(){
        friendList = []
    }
    
    func updateAllWith(userlist:[User]){
        friendList = userlist
    }
    
    func getFriendAtIndex(index:Int) -> User?{
        return friendList[index]
    }
}