//
//  ShowGroupMemberVC.swift
//  WePlan
//
//  Created by Huibo Li on 4/30/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class ShowGroupMemberVC: UITableViewController {

    var group:Group!
    var MemberList:[User]!
    
    var groupId: String?{
        didSet{
            let group = LocalGroupList.sharedInstance.getGroup(groupId!)
            ParseGroupAction.getGroupMembers(group.memberIds) { (userList:[User]) -> Void in
                self.MemberList = userList
                self.hasData = true
                self.tableView.reloadData()
                
            }
            
        }
    }
    var hasData = false
    var entry = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if let list=MemberList{
            print("Nice!!")
        }
        else{
            print("NothingT T")
        }
//        println("Get Member\(MemberList.count)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        if entry == 9 {
            if hasData {
                return MemberList.count
            }else{
                return 0
            }
        }else{
            return group.memberIds.count
        }
    }

    private struct StoryBoard{
        static let GroupMemberCell="Cell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.GroupMemberCell, forIndexPath: indexPath) as! ShowGroupMemberCell

        // Configure the cell...
        cell.Member=self.MemberList[indexPath.row]
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
