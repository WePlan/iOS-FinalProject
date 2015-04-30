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
    var friendIds: Set<String> {
        get{
            var idSet = Set<String>()
            for friend in friendList {
                idSet.insert(friend.uid)
            }
            return idSet
        }
    }
    
    private init(){
        friendList = []
    }
    
    func updateAllWith(userlist:[User]){
        friendList = userlist
    }
    
    func getFriendAtIndex(index:Int) -> User?{
        if index < count {
            return friendList[index]
        }else{
            return nil
        }
    }
    
    func getFriendListFromParse(completion: () -> Void) {
        ParseFriendAction.getFriendList { (userList: [User]) -> Void in
            self.updateAllWith(userList)
            completion()
        }
    }
    
    func getFriendName(# objectId: String) -> String {
        var name:String?
        for friend in friendList {
            if friend.uid == objectId {
                name = friend.name
                break
            }
        }
        assert(name != nil, "friend name should exist")
        return name!
    }
    
}