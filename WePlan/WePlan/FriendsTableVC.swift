//
//  FriendsTableVC.swift
//  WePlan
//
//  Created by Kan Chen on 3/31/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class FriendsTableVC: UITableViewController {
    
    var Titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Titles.append("Frinds jin")
        Titles.append("Friends fuck")
        self.tableView.rowHeight = 60
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        DefaultSetting.setNavigationBar(self.navigationController!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Titles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "friendCellPrototype"
        var cell: SWTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? SWTableViewCell
        
        // Configure the cell...
        if cell == nil {
            cell = SWTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
            
//            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell!.rightUtilityButtons = self.rightButtons()
            cell!.setRightUtilityButtons(cell!.rightUtilityButtons, withButtonWidth: 40)
    //        cell.leftUtilityButtons = self.leftButtons()
    //        cell.setLeftUtilityButtons(cell.leftUtilityButtons, withButtonWidth: 20)
                //        cell.delegate = self
        }
        cell!.textLabel?.text = Titles[indexPath.row]

        return cell!
    }
    
    func rightButtons() -> NSArray {
        var rightUtilityButtons: NSMutableArray = []
        
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), icon: UIImage(named: "deleteIcon"))
        
        return rightUtilityButtons
    }
    
    func leftButtons() -> NSArray {
        var leftUtilityButtons: NSMutableArray = []
        leftUtilityButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), icon: UIImage(named: "deleteIcon"))
        
        return leftUtilityButtons
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
