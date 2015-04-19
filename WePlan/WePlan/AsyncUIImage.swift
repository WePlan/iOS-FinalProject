//
//  AsyncUIImage.swift
//  WePlan
//
//  Created by Kan Chen on 4/19/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class AsyncUIImage: UIImageView {
    
    var defaultImageName: String? {
        didSet{
            if objectId == nil {
                self.image = UIImage(named: defaultImageName!)
            }
        }
    }
    
    var objectId: String? {
        didSet{
            ParseImageAction.getImage(objectId!, completion: { (returnImage: UIImage) -> Void in
                self.image = returnImage
            })
        }
    }
   
}
