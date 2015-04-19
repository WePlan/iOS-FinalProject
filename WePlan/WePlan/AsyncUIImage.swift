//
//  AsyncUIImage.swift
//  WePlan
//
//  Created by Kan Chen on 4/19/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class AsyncUIImageView: UIImageView {
    
    var defaultImageName: String? {
        didSet{
            if imageObjectId == nil {
                self.image = UIImage(named: defaultImageName!)
            }
        }
    }
    
    var imageObjectId: String? {
        didSet{
            ParseImageAction.getImage(imageObjectId!, completion: { (returnImage: UIImage) -> Void in
                self.image = returnImage
            })
        }
    }
   
}
