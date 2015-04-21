//
//  DefaultSetting.swift
//  WePlan
//
//  Created by Kan Chen on 3/31/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import Foundation
import UIKit

class DefaultSetting {
    
    class func setNavigationBar(navigationController: UINavigationController) {
        
        navigationController.navigationBar.barTintColor = WePlanColors.blueColor()
        navigationController.navigationBar.tintColor = UIColor.whiteColor()
        navigationController.navigationItem.titleView?.backgroundColor = UIColor.redColor()
    }
    
    class func setTabbar(tabBarController: UITabBarController) {
//        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "Home"), selectedImage: UIImage.init(named: "Home"))
        
        
        tabBarController.tabBar.tintColor = UIColor.redColor()
        tabBarController.tabBar.backgroundColor = UIColor.purpleColor()
    }
}
