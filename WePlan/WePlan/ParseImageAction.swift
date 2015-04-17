//
//  ParseImageAction.swift
//  WePlan
//
//  Created by Kan Chen on 4/17/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

protocol ImageAction {
    
}

class ParseImageAction : ImageAction{
    
    static func uploadImage(image: UIImage) {
        let imageData: NSData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name:"image.png", data:imageData)
        
        var userPhoto = PFObject(className:"Photos")
        userPhoto["imageName"] = "Test pic"
        userPhoto["imageFile"] = imageFile
//        let start = NSDate()
//        println("start:" + "\(start)" )
        userPhoto.saveInBackgroundWithBlock { (successed: Bool, error:NSError?) -> Void in
            if error == nil {
//                println("uploaded")
//                let end = NSDate()
//                println("end:" + "\(end)" )
                
            }else {
                let errorString = error!.userInfo!["error"] as! String
                println(errorString)
            }
            
        }

    }
}
