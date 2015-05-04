//
//  FriendsTableVC.swift
//  WePlan
//
//  Created by Kan Chen on 3/31/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class FriendsTableVC: UITableViewController , FriendTableCellDeleget,UISearchBarDelegate, UISearchDisplayDelegate, MBProgressHUDDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    var localFriendList = LocalFriendList.sharedInstance
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBAction func clickRefresh(sender: AnyObject) {
        var hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud)
        hud.delegate = self
        hud.show(true)
        hud.labelText = "Loading..."
        
        refreshButton.enabled = false
        localFriendList.getFriendListFromParse { () -> Void in
            self.tableView.reloadData()
            self.refreshButton.enabled = true
            
            hud.hide(true)
        }
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISettings()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.tableView.allowsMultipleSelectionDuringEditing = false
    }

    override func viewWillAppear(animated: Bool) {
        DefaultSetting.setNavigationBar(self.navigationController!)
        initialUISettings()
        // Can be improved by add only one user object
        localFriendList.getFriendListFromParse { () -> Void in
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if searchState {
            return filterFriends.count
        }else{
            return localFriendList.count
        }
    }
    
    private struct StoryBoardConstants {
        static let cell = "friendCellPrototype"
        static let cell2 = "friendCellPrototype2"
        static let cell3 = "FriendListCellPrototype"
        static let pushSegue = "addFriendSegue"
        static let userDetailSegue = "UserDetailView"
        static let assignATaskSegue = "AssignATaskToFriend"
    }
    
    private func initialUISettings() {
        DefaultSetting.setNavigationBar(self.navigationController!)
//        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarTaskGrey"), selectedImage: UIImage.init(named: "TapBarTaskBlue"))
//                self.tabBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "TapBarFriendGrey")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage.init(named: "TapBarFriendBlue")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
//       
//        self.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        //        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarGroupGrey"), selectedImage: UIImage.init(named: "TapBarGroupBlue"))
        //        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarSettingGrey"), selectedImage: UIImage.init(named: "TapBarSettingBlue"))
        self.view.backgroundColor = UIColor.whiteColor()
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardConstants.cell3, forIndexPath: indexPath) as! FriendTableViewCell
        cell.userProfileImage.image = UIImage(named: "UserDefaultPic")
        // Configure the cell...
        cell.clipsToBounds = true;
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //Custom cell configure
//        println("loading friendcell at index: \(indexPath.row)")
        cell.delegate = self
        if searchState {
            cell.friend = filterFriends[indexPath.row]
        }else{
            cell.friend = localFriendList.getFriendAtIndex(indexPath.row)
        }
//        println("with image: \(cell.friend!.imageId)")
//        NSLog("%p", cell.userProfileImage)
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    
//    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.Delete
//    }

    
    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            let deleteId = localFriendList.getFriendAtIndex(indexPath.row)?.uid
//            let deleteName = localFriendList.getFriendAtIndex(indexPath.row)?.name
//            //Alert
//            var alert = UIAlertController(title: "Delete Friend", message: "Are you sure you want to delete \(deleteName)", preferredStyle: UIAlertControllerStyle.Alert)
//            // Delete the row from the data source
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
//            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { action in
//                self.localFriendList.friendList.removeAtIndex(indexPath.row)
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//                ParseFriendAction.deleteFriend(deleteId!, complete: { (result :Bool) -> Void in
//                    if result == true {
//                        println("Deleted!")
//                    }else {
//                        println("fail!")
//                    }
//                })
//            }))
//            self.presentViewController(alert, animated: true, completion: nil)
//            
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    

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
            return 60
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if searchBar.isFirstResponder() {
//            searchState = false
            self.searchBar.showsCancelButton = false
            searchBar.endEditing(true)
        }
        //selet the expanding row
        if selected == indexPath.row {
            selected = -1
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            return
        }
        else if selected != -1 {
            let prevIndexPath:NSIndexPath = NSIndexPath(forRow: selected, inSection: 0)
            selected = indexPath.row
//            tableView.reloadData()
            tableView.reloadRowsAtIndexPaths([prevIndexPath], withRowAnimation: .Fade)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }else{
            
            selected = indexPath.row
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
        //        self.performSegueWithIdentifier(StoryBoardConstants.userDetailSegue, sender: self)
    }
    // MARK: - Navigation
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == StoryBoardConstants.pushSegue {
            let friendIds = localFriendList.friendIds
            let destVC = segue.destinationViewController as! SearchFriendVC
            destVC.myFriendsSet = friendIds
        }
        if segue.identifier == StoryBoardConstants.assignATaskSegue {
            
            if let atdvc = segue.destinationViewController as? AssignATaskToFriendTableViewController {
//                let tmp1 = friendList[selected].name
                let tmp = localFriendList.getFriendAtIndex(selected)?.name
                println(tmp)
                atdvc.friend = localFriendList.getFriendAtIndex(selected)
//                let a = friendList[selected]
            }
        }
//        if segue.identifier == StoryBoardConstants.userDetailSegue {
//            if let dvc = segue.destinationViewController as? FriendDetailViewController {
//                dvc.user = friendList[selected]
//            }
//        }
    }

    
    func removeFriendDelegate(friend:User) {
        let index = findIndexPath(friend)
        
        let deleteId = friend.uid
        let deleteName = friend.name
        
        //Alert
        var alert = UIAlertController(title: "Delete Friend", message: "Are you sure you want to delete \(deleteName)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { action in
            self.localFriendList.friendList.removeAtIndex(self.selected)
            self.tableView.deleteRowsAtIndexPaths([index], withRowAnimation: .Fade)
            // Delete the row from the data source
            ParseFriendAction.deleteFriend(deleteId, complete: { (result :Bool) -> Void in
                if result == true {
                    println("Deleted!")
                }else {
                    println("fail!")
                }
            })
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//
    //MARK: - Navigation
    
    @IBAction func unwindFriendList(segue:UIStoryboardSegue){
        
    }
    
    func toAddTask(friend:User) {
        let taskSB:UIStoryboard = UIStoryboard(name: "Tasks", bundle: NSBundle.mainBundle())
        let vc = taskSB.instantiateViewControllerWithIdentifier("addTaskEntry") as! UINavigationController
        let a = vc.childViewControllers[0] as! AddTaskItemViewController
        a.entrypoint = "Friend"
        a.assignPeople = friend 
        presentViewController(vc, animated: true, completion: nil)
    }
    private func findIndexPath(friend:User) -> NSIndexPath {
        var indexPath: NSIndexPath!
        for var index = 0 ; index < localFriendList.friendList.count ; index++ {
            if localFriendList.friendList[index].uid == friend.uid {
                indexPath = NSIndexPath(forRow: index, inSection: 0)
                break
            }
        }
        return indexPath
    }
    
    // MARK: - Search Bar
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    var filterFriends:[User] = []
    var searchState: Bool = false
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if count(searchText) == 0 {
            self.searchState = false
            self.searchBar.showsCancelButton = false
            self.searchBar.endEditing(true)
            self.tableView.reloadData()
            return
        }
        self.searchState = true
        
        var originArray = NSArray()
        filterFriends = []
        for var i = 0; i < localFriendList.count; i++ {
            let predicate: NSPredicate = NSPredicate(format:"self contains [cd] %@", searchText)
            if predicate.evaluateWithObject(localFriendList.friendList[i].name){
                filterFriends.append(self.localFriendList.friendList[i])
            }
        }
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar(self.searchBar, textDidChange: "")
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //
        selected = -1
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        //
    }
    
}
