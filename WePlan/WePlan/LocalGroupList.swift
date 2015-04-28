//
//  LocalGroupList.swift
//  WePlan
//
//  Created by Kan Chen on 4/24/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

class LocalGroupList {
    static let sharedInstance = LocalGroupList()
    
    var groupList: [Group]
    var count: Int {
        return groupList.count
    }
    
    private init(){
        groupList = []
    }
    
    func updateAll(completion: ()-> Void) {
        ParseGroupAction.getGroupList { (groups:[Group]) -> Void in
            self.groupList = groups
            completion()
        }
    }
}