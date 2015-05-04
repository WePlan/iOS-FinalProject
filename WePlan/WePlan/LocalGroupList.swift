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
    
    func getGroup(# objectId:String) -> Group{
        var agroup: Group?
        for group in groupList {
            if group.id == objectId {
                agroup = group
                break
            }
        }
        assert(agroup != nil, "group should exist")
        return agroup!
    }
    
    func getGroupName(# objectId: String) -> String{
        var name:String?
        for group in groupList {
            if group.id == objectId {
                name = group.name
                break
            }
        }
//        assert(name != nil, "group name should exist")
        if name == nil {
            name = "dismissed"
        }
        return name!
    }
}