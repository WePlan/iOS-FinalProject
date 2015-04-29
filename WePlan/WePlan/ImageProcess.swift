//
//  ImageProcess.swift
//  WePlan
//
//  Created by Kan Chen on 4/29/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation

class ImageProcess {
    //MARK: - FixImageShape
    class func changeImageViewToCircle(imageView: UIImageView) {
        changeImageView(imageView, radiusRatio: 2)
    }
    
    class func changeImageViewRounded(imageView: UIImageView) {
        changeImageView(imageView, radiusRatio: 10)
    }
    
    private class func changeImageView(imageView: UIImageView, radiusRatio: CGFloat){
        let size = imageView.frame.size
        let radius: CGFloat
        if size.height == size.width {
            radius = size.height/radiusRatio
        }else{
            println("Aspect ratio of image is not 1:1.")
            radius = 0
        }
        imageView.layer.cornerRadius = radius
        imageView.layer.masksToBounds = true
    }
    //MARK: Misc.
    
    class func resizeImage(image: UIImage , size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}
