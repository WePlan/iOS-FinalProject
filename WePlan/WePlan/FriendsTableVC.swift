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
        cell.clipsToBounds = true;
        
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
            let deleteId = friendList[indexPath.row].uid
            let deleteName = friendList[indexPath.row].name
            //Alert
            var alert = UIAlertController(title: "Delete Friend", message: "Are you sure you want to delete \(deleteName)", preferredStyle: UIAlertControllerStyle.Alert)
            // Delete the row from the data source
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { action in
                self.friendList.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                ParseFriendAction.deleteFriend(deleteId, complete: { (result :Bool) -> Void in
                    if result == true {
                        println("Deleted!")
                    }else {
                        println("fail!")
                    }
                })
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
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
// cell Height = 55 
    //expanding cell height = 90
    var selected: Int = -1
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selected != -1 && selected == indexPath.row {
            return 90
        }else{
            return 55
        }
        
    }
    
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        //selet the expanding row
        if selected == indexPath.row {
            selected = -1
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            return
        }
        else if selected != -1 {
            let prevIndexPath:NSIndexPath = NSIndexPath(forRow: selected, inSection: 0)
            selected = indexPath.row
            tableView.reloadRowsAtIndexPaths([prevIndexPath], withRowAnimation: .Fade)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }else{
        
            selected = indexPath.row
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
       
//        self.performSegueWithIdentifier(StoryBoardConstants.userDetailSegue, sender: self)
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
//        if segue.identifier == StoryBoardConstants.userDetailSegue {
//            if let dvc = segue.destinationViewController as? FriendDetailViewController {
//                dvc.user = friendList[selected]
//            }
//        }
    }
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        (cell as! FriendTableViewCell).noticeCell()
//    }
//    
//    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        (cell as! FriendTableViewCell).endNoticeCell()
//    }
//
}
