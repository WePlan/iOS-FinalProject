//
//  LocalUser.swift
//  WePlan
//
//  Created by Kan Chen on 4/7/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

class LocalUser {
    var uniqueId: String
    
    class var singleInstance:LocalUser {
        struct Static {
            static let instance: LocalUser = LocalUser()
        }
        
        return Static.instance
    }
    
    private init () {
        uniqueId = ""
    }
    
    func setUniqueId (newId: String) {
        self.uniqueId = newId
    }
}

