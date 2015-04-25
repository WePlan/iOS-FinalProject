//
//  CreateGroupVC.swift
//  WePlan
//
//  Created by Kan Chen on 4/24/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showList(sender: AnyObject) {
//        ParseGroupAction2.getGroupList { (titles:[String]) -> Void in
//            for title in titles {
//                println(title)
//            }
//        }
    }

    @IBAction func createGroup(sender: AnyObject) {
        let ownerId = PFUser.currentUser()!.objectId!
        let members:[String] = ["lOPPuMksKd","OxNKZWaHCV"]
        ParseGroupAction2.createGroup("groupTest1", ownerId: ownerId, members: members)
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
