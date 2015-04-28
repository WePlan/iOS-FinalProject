//
//  CreateGroupVC.swift
//  WePlan
//
//  Created by Kan Chen on 4/24/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController {

    @IBOutlet weak var gruopNameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var groupImageView: AsyncUIImageView!
    @IBOutlet weak var memberNumLabel: UILabel!
    
    @IBOutlet weak var friendsTableView: UITableView!
    var selectedFriends:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func clickBack(sender: AnyObject) {
    }
    
    @IBAction func clickCreate(sender: AnyObject) {
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
