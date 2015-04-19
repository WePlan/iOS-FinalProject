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
    
    private struct ParseContants{
        static let photosClass = "Photos"
        static let colImageFile = "imageFile"
    }
    
    static func uploadImage(image: UIImage) {
        let imageData: NSData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name:"image.png", data:imageData)
        
        var userPhoto = PFObject(className: ParseContants.photosClass)
        userPhoto["imageName"] = "Test pic"
        userPhoto[ParseContants.colImageFile] = imageFile
//        let start = NSDate()
//        println("start:" + "\(start)" )
        userPhoto.saveInBackgroundWithBlock { (successed: Bool, error:NSError?) -> Void in
            if error == nil {
//                println("uploaded")
//                let end = NSDate()
//                println("end:" + "\(end)" )
                println("image saved with id:"+userPhoto.objectId!)
                
            }else {
                let errorString = error!.userInfo!["error"] as! String
                println(errorString)
            }
            
        }
    }
    
    
    static func changeImageId(# newId: String) {
        
    }
    
    static func getImage(objectId: String, completion: (UIImage) -> Void) {
        var targer: PFFile?
        
        var query = PFQuery(className: ParseContants.photosClass)
        query.whereKey("objectId", equalTo: objectId)
//        query.whereKey("objectId", equalTo: "bKAM0X4jma")
        query.findObjectsInBackgroundWithBlock { (results:[AnyObject]?, error:NSError?) -> Void in
            if error == nil {
                if let results = results as? [PFObject] {
                    println("\(results.count)   result should be 1")
                    
                    let object:PFObject = results[0]
                    let file = object.objectForKey(ParseContants.colImageFile) as! PFFile
                    file.getDataInBackgroundWithBlock{ (imageData: NSData?, error: NSError?) -> Void in
                        if error == nil {
                            // have got the image from Parse
                            if let image = UIImage(data: imageData!) {
                                completion(image)
                            }
//                            self.image2.image = image
                        }
                    }
                }
            }else {
                println("Error: \(error!.userInfo)")
            }
        }
        
    }
}
