//
//  ParseBaseAction.swift
//  WePlan
//
//  Created by Kan Chen on 4/24/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

class ParseBaseAction {
    
    class func deleteItem(objectId: String, inClass classname: String) {
        var pfQuery = PFQuery(className: classname)
        
        pfQuery.getObjectInBackgroundWithId(objectId, block: { (result: PFObject? , error: NSError?) -> Void in
            if error == nil {
                result!.deleteInBackground()
            }else {
                let str = error?.userInfo
                print("### delete object in parse error")
                print(str)
            }
        })
    }
    
}
