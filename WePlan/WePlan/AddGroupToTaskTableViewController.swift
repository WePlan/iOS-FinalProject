//
//  AddGroupToTaskTableViewController.swift
//  WePlan
//
//  Created by xi su on 4/30/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit
protocol AssignTaskToGroupDelegate {
    func assignTaskToGroup(assignGroup:Group)
}
class AddGroupToTaskTableViewController: UITableViewController {
    var delegate:AssignTaskToGroupDelegate?
    var alreadyAssignedGroup:Group?
    var groupList:[Group] = LocalGroupList.sharedInstance.groupList
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    private struct AddGroupToTastConstants {
        static let cellIdentifier = "addGroupToTaskCellIdentifier"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.groupList.count
    }
    var selectedIndex:NSIndexPath?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if selectedIndex == indexPath {
                cell.accessoryType = UITableViewCellAccessoryType.None
                selectedIndex = nil
                alreadyAssignedGroup = nil
                return
            }
            if selectedIndex != nil {
                //                selectedIndex = indexPath
                if let prevCell = tableView.cellForRowAtIndexPath(selectedIndex!) {
                    prevCell.accessoryType = UITableViewCellAccessoryType.None
                    
                    
                }
                
            }
            selectedIndex = indexPath
            alreadyAssignedGroup = groupList[indexPath.row]
            cell.tintColor = WePlanColors.blueColor()
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            var myBackView = UIView(frame: cell.frame)
            myBackView.backgroundColor = WePlanColors.blueColor()
            cell.selectedBackgroundView = myBackView
            if delegate != nil {
                delegate!.assignTaskToGroup(groupList[indexPath.row])
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: update UI interaction, 1: deselected animation, 2:select the same one
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AddGroupToTastConstants.cellIdentifier, forIndexPath: indexPath) as! addGroupToTaskTableViewCell
        cell.groupItem = groupList[indexPath.row]
        if alreadyAssignedGroup != nil && alreadyAssignedGroup?.id == cell.groupItem?.id {
                cell.tintColor = WePlanColors.blueColor()
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                var myBackView = UIView(frame: cell.frame)
                myBackView.backgroundColor = WePlanColors.blueColor()
                cell.selectedBackgroundView = myBackView
                selectedIndex = indexPath
        }
        // Configure the cell...

        return cell
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
