//
//  AddPeopleToTaskTableViewController.swift
//  WePlan
//
//  Created by xi su on 4/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

protocol AssignTaskToOtherPeopleDelegate {
    func assignTaskToOtherPeople(assignPeople:User)
}
class AddPeopleToTaskTableViewController: UITableViewController {
    var alreadyAssignedPeople: User?
    var friendList:[User] = []
    var delegate: AssignTaskToOtherPeopleDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        ParseFriendAction.getFriendList { (userList:[User]) -> Void in
            self.friendList = userList
            self.tableView.reloadData()
        }
        
        self.tableView.allowsMultipleSelectionDuringEditing = true
    }
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.whiteColor()
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
        return self.friendList.count
    }

    private struct AddPeopleToTastConstants {
        static let cellIdentifier = "AddPelpleListCell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AddPeopleToTastConstants.cellIdentifier, forIndexPath: indexPath) as! AddPeopleToTaskTableViewCell

        // Configure the cell...
        
        cell.friend = friendList[indexPath.row]
        if alreadyAssignedPeople != nil && alreadyAssignedPeople?.uid == cell.friend?.uid {
            cell.tintColor = WePlanColors.blueColor()
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            var myBackView = UIView(frame: cell.frame)
            myBackView.backgroundColor = WePlanColors.blueColor()
            cell.selectedBackgroundView = myBackView
            selectedIndex = indexPath
//            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    var selectedIndex:NSIndexPath?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if selectedIndex == indexPath {
                cell.accessoryType = UITableViewCellAccessoryType.None
                selectedIndex = nil
                alreadyAssignedPeople = nil
                return
            }
            if selectedIndex != nil {
//                selectedIndex = indexPath
                if let prevCell = tableView.cellForRowAtIndexPath(selectedIndex!) {
                    prevCell.accessoryType = UITableViewCellAccessoryType.None
                    
                    
                }

            }
            
            selectedIndex = indexPath
            alreadyAssignedPeople = friendList[indexPath.row]
            cell.tintColor = WePlanColors.blueColor()
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
            var myBackView = UIView(frame: cell.frame)
            myBackView.backgroundColor = WePlanColors.blueColor()
            cell.selectedBackgroundView = myBackView
                
//            let taskItemChecked = friendList[indexPath.row]
            
            println("12")
            if delegate != nil {
                println("122")
                delegate!.assignTaskToOtherPeople(friendList[indexPath.row])
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        
    }

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
