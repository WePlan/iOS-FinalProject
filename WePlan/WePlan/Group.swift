//
//  Group.swift
//  WePlan
//
//  Created by Kan Chen on 4/1/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

struct Group {
    var id: String
    var name: String
    var owner: User
    var members: [User]
    var description: String
//    var createdDate: NSDate
}