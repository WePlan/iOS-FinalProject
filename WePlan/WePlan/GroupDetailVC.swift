//
//  GroupDetailVC.swift
//  WePlan
//
//  Created by Kan Chen on 4/28/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class GroupDetailVC: UIViewController {

    @IBAction func unwindGroupDetail(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickAssign(sender: AnyObject) {
        let taskSB:UIStoryboard = UIStoryboard(name: "Tasks", bundle: NSBundle.mainBundle())
        let vc = taskSB.instantiateViewControllerWithIdentifier("addTaskEntry") as! UINavigationController
        let a = vc.childViewControllers[0] as! AddTaskItemViewController
        a.entrypoint = "Group"
        presentViewController(vc, animated: true, completion: nil)
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
