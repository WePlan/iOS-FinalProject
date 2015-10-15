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
//        static let photosClass = "Photos"
        static let groupImageClass = "GroupImages"
        static let colImageFile = "imageFile"
    }
    
    static func uploadGroupImage(image: UIImage , groupId: String){
        let imageData: NSData = UIImagePNGRepresentation(image)!
        let imageFile = PFFile(name:"image.png", data:imageData)
        
        var groupImage = PFObject(className: ParseContants.groupImageClass)
        groupImage["imageName"] = "GroupImage"
        groupImage[ParseContants.colImageFile] = imageFile
        groupImage["groupId"] = groupId
        groupImage.saveInBackgroundWithBlock { (successed: Bool, error:NSError?) -> Void in
            if error == nil {
                print("group image saved with id:"+groupImage.objectId!)
//                self.changeImageId(newId: groupImage.objectId!)
            }else {
                let errorString = error!.userInfo["error"] as! String
                print(errorString)
            }
            
        }

    }
    
//    static func uploadImage(image: UIImage) {
//        let imageData: NSData = UIImagePNGRepresentation(image)
//        let imageFile = PFFile(name:"image.png", data:imageData)
//        
//        var userPhoto = PFObject(className: ParseContants.photosClass)
//        userPhoto["imageName"] = "UserPhoto"
//        userPhoto[ParseContants.colImageFile] = imageFile
//        userPhoto["userId"] = PFUser.currentUser()?.objectId
//        userPhoto.saveInBackgroundWithBlock { (successed: Bool, error:NSError?) -> Void in
//            if error == nil {
//                println("image saved with id:"+userPhoto.objectId!)
//                self.changeImageId(newId: userPhoto.objectId!)
//            }else {
//                let errorString = error!.userInfo!["error"] as! String
//                println(errorString)
//            }
//            
//        }
//    }
    
//    static func changeImageId(# newId: String) {
//        let localUser = PFUser.currentUser()!
//        let oldImageId = localUser["imageId"] as? String
//        
//        localUser["imageId"] = newId
//        localUser.saveInBackground()
//        
//        if oldImageId != nil {
//            ParseBaseAction.deleteItem(objectId: oldImageId!, inClass: ParseContants.photosClass)
//        }
//    }
    
    class func uploadImageToUser(image: UIImage) {
        let imageData: NSData = UIImagePNGRepresentation(image)!
        let imageFile = PFFile(name:"image.png", data:imageData)
        
        let localUser = PFUser.currentUser()!
        localUser["photo"] = imageFile
        localUser.saveInBackgroundWithBlock { (success:Bool,error: NSError?) -> Void in
            if success {
                
            }else{
                print("##upload photo error: \(error?.userInfo)")
            }
        }
    }
    
    class func changeNickname(name: String) {
        let localuser = PFUser.currentUser()!
        localuser["nickname"] = name
        localuser.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                print("nickname changed")
            }else{
                print("##changename error: \(error?.userInfo)")
            }
        }
    }

//    static func getImage(objectId: String, completion: (UIImage) -> Void) {
//        var targer: PFFile?
//        
//        var query = PFQuery(className: ParseContants.photosClass)
//        query.whereKey("objectId", equalTo: objectId)
//        query.findObjectsInBackgroundWithBlock { (results:[AnyObject]?, error:NSError?) -> Void in
//            if error == nil {
//                if let results = results as? [PFObject] {
//                    if results.count != 1{
//                        println("\(results.count)   result should be 1")
//                    }
//                    let object:PFObject = results[0]
//                    let file = object.objectForKey(ParseContants.colImageFile) as! PFFile
//                    file.getDataInBackgroundWithBlock{ (imageData: NSData?, error: NSError?) -> Void in
//                        if error == nil {
//                            // have got the image from Parse
//                            if let image = UIImage(data: imageData!) {
//                                completion(image)
//                            }
//                        }
//                    }
//                }
//            }else {
//                println("Error: \(error!.userInfo)")
//            }
//        }
//    }
    
    static func getImage(imageFile: PFFile, completion: (UIImage) -> Void) {
        imageFile.getDataInBackgroundWithBlock { (imageData:NSData?, error: NSError?) -> Void in
            if error == nil {
                if let image = UIImage(data: imageData!) {
                    completion(image)
                }
            }
        }
    }
}
