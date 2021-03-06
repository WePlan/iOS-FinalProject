//
//  AppDelegate.swift
//  WePlan
//
//  Created by Kan Chen on 3/4/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private struct ParseKey {
        static let appKey = "iFko0h7dIreumEvZQwTKQxejAsOObunUSU37f1up"
        //COMpsvCZLaqeAK424QPBfgUpZlYvUqk33RV5Z4su
        static let clientKey = "bzEclgVBmYZVEQndtW9ummVpOcgtmYawLA03bNrb"
//        ucOzGCY4seQMi4LLH2Wooa0rKrYMcAjNqGr5ZMXh
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId(ParseKey.appKey, clientKey: ParseKey.clientKey)
        // set entry point
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController?
        if PFUser.currentUser() != nil {
            vc = storyboard.instantiateViewControllerWithIdentifier("TabBarEntry") as! TabBarViewController
        }else {
            vc = storyboard.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
        }
        
        
        self.window?.rootViewController = vc
//        if let tbc = self.window?.rootViewController as? UITabBarController {
//            println("123")
//            
//            var tabBar = tbc.tabBar.items?[0] as? UITabBarItem
//            tabBar!.image = UIImage(named:"TapBarFriendGrey")!.imageWithRenderingMode(.AlwaysOriginal)
//            
//        }
        self.window?.makeKeyAndVisible()
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

