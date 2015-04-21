//
//  TabBarViewController.swift
//  WePlan
//
//  Created by Kan Chen on 3/5/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private struct viewControllers {
        static let mainVC = "TasksEntry"
        static let friendVC = "FriendsEntry"
        static let groupVC = "GroupEntry"
        static let settingVC = "SettingsEntry"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        var vcs:[UIViewController] = []
        
        let settingsSB: UIStoryboard = UIStoryboard(name: "Setting", bundle: NSBundle.mainBundle())
        let friendsSB: UIStoryboard = UIStoryboard(name: "Friends", bundle: NSBundle.mainBundle())
        let taskSB:UIStoryboard = UIStoryboard(name: "Tasks", bundle: NSBundle.mainBundle())
        let groupSB:UIStoryboard = UIStoryboard(name: "Groups", bundle: NSBundle.mainBundle())
        
        let vc1: UIViewController = settingsSB.instantiateViewControllerWithIdentifier(viewControllers.settingVC) as! UINavigationController
        let vc2: UIViewController = friendsSB.instantiateViewControllerWithIdentifier(viewControllers.friendVC) as! UINavigationController
        let vc3: UIViewController = taskSB.instantiateViewControllerWithIdentifier(viewControllers.mainVC) as! UINavigationController
        let vc4: UIViewController = groupSB.instantiateViewControllerWithIdentifier(viewControllers.groupVC) as! UINavigationController

        vcs.append(vc3)
        vcs.append(vc2)
        vcs.append(vc4)
        vcs.append(vc1)
//        self.tabBar.items = [UITabBarItem]
//        println(self.tabBar.items)
//        for var i = 0; i < 4; i++ {
////            let tabBarItem = self.tabBar.items![i] as! UITabBarItem
//            
//            // Adjust tab images (Like mstysf says, these values will vary)
//            
//            
//            // Let's find and set the icon's default and selected states
//            // (use your own image names here)
//            var imageName = ""
//            switch (i) {
//            case 0: imageName = "TapBarTask"
//            case 1: imageName = "TapBarFriend"
//            case 2: imageName = "TapBarGroup"
//            case 3: imageName = "TapBarSetting"
//            
//            default: break
//            }
//             let tabBarItem = UITabBarItem.init(title: nil, image: nil, selectedImage: nil)
//            tabBarItem.image = UIImage(named:imageName + "Grey")!.imageWithRenderingMode(.AlwaysOriginal)
//            tabBarItem.selectedImage = UIImage(named:imageName + "Blue")!.imageWithRenderingMode(.AlwaysOriginal)
//            tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -6, 0);
//            self.tabBar.items!.append(tabBarItem)
//        }
        
        self.setViewControllers(vcs, animated: false)
        self.selectedIndex = 0
        self.tabBar.tintColor = WePlanColors.blueColor()
        
//        self.tabBar.backgroundColor = UIColor.redColor()
        
    }
    override func viewDidAppear(animated: Bool) {
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
