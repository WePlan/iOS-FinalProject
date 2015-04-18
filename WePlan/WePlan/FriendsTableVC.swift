//
//  FriendsTableVC.swift
//  WePlan
//
//  Created by Kan Chen on 3/31/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class FriendsTableVC: UITableViewController {
    
    var friendList: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        ParseFriendAction.getFriendList { (userList:[User]) -> Void in
            self.friendList = userList
            self.tableView.reloadData()
        }
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
    }

    override func viewWillAppear(animated: Bool) {
        DefaultSetting.setNavigationBar(self.navigationController!)
        // Can be improved by add only one user object
        ParseFriendAction.getFriendList { (userList:[User]) -> Void in
            self.friendList = userList
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.friendList.count
    }
    
    private struct StoryBoardConstants {
        static let cell = "friendCellPrototype"
        static let cell2 = "friendCellPrototype2"
        static let cell3 = "FriendListCellPrototype"
        static let pushSegue = "addFriendSegue"
        static let userDetailSegue = "UserDetailView"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardConstants.cell3, forIndexPath: indexPath) as! FriendTableViewCell
        
        // Configure the cell...
//        cell.textLabel?.text = friendList[indexPath.row].name
//        cell.detailTextLabel?.text = friendList[indexPath.row].uemail
//        println("\(friendList[indexPath.row].uid)")
        
        
        //Custom cell configure
        cell.friend = friendList[indexPath.row]
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let deleteId = friendList[indexPath.row].uid
            self.friendList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            ParseFriendAction.deleteFriend(deleteId, complete: { (result :Bool) -> Void in
                if result == true {
                    println("Deleted!")
                }else {
                    println("fail!")
                }
            })
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation
    var selected: Int = 0
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selected = indexPath.row
        self.performSegueWithIdentifier(StoryBoardConstants.userDetailSegue, sender: self)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == StoryBoardConstants.pushSegue {
            var friendIds = Set<String>()
            for friend in self.friendList {
                friendIds.insert(friend.uid)
            }
            let destVC = segue.destinationViewController as! SearchFriendVC
            destVC.myFriendsSet = friendIds
        }
        if segue.identifier == StoryBoardConstants.userDetailSegue {
            if let dvc = segue.destinationViewController as? FriendDetailViewController {
                dvc.user = friendList[selected]
            }
        }
    }
    


}
