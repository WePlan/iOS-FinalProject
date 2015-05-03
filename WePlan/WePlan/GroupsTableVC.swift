//
//  GroupsTableVC.swift
//  WePlan
//
//  Created by Kan Chen on 3/31/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class GroupsTableVC: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    

    var groups = LocalGroupList.sharedInstance
    
    //SearchBar
    var Filtergroups:[Group]=[]
    var selected: Int = 0
    var searchState: Bool = false
    
    
    var IndexChosen:Int!
    
    private struct StoryBoard {
        static let cell = "groupCellPrototype"
        static let cell2 = "groupCellPrototype2"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    private func initialUISettings() {
        DefaultSetting.setNavigationBar(self.navigationController!)
        //        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarTaskGrey"), selectedImage: UIImage.init(named: "TapBarTaskBlue"))
        //        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarFriendGrey"), selectedImage: UIImage.init(named: "TapBarFriendBlue"))
        //                self.tabBarItem = UITabBarItem.init(title:nil, image: UIImage.init(named: "TapBarGroupGrey")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage.init(named: "TapBarGroupBlue")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
        //
        //        self.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        //        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarSettingGrey"), selectedImage: UIImage.init(named: "TapBarSettingBlue"))
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        initialUISettings()
        DefaultSetting.setNavigationBar(self.navigationController!)
        groups.updateAll { () -> Void in
            self.tableView.reloadData()
        }
    }

    
    // MARK: - Search Bar
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchBar.showsCancelButton = true
        if count(searchText) == 0 {
            self.searchState = false
            self.searchBar.showsCancelButton = false
            self.tableView.reloadData()
            return
        }
        self.searchState = true
        
        var originArray = NSArray()
        self.Filtergroups = []
        for var i = 0; i < groups.count; i++ {
            let predicate: NSPredicate = NSPredicate(format:"self contains [cd] %@", searchText)
            if predicate.evaluateWithObject(groups.groupList[i].name){
                self.Filtergroups.append(self.groups.groupList[i])
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
    

    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return groups.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cell, forIndexPath: indexPath) as! UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.cell2, forIndexPath: indexPath) as! GroupTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
//        cell.textLabel?.text = groups.groupList[indexPath.row].name
//        cell.detailTextLabel?.text = groups.groupList[indexPath.row].i
        cell.group = groups.groupList[indexPath.row]
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        IndexChosen = indexPath.row
        performSegueWithIdentifier("GroupDetail", sender: self)
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

    
    // MARK: - Navigation
    @IBAction func unwindGroupTable(segue: UIStoryboardSegue) {
        groups.updateAll { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier=="GroupDetail"{
            var nextvc=segue.destinationViewController as! GroupDetailTableVC
            nextvc.group=groups.groupList[IndexChosen]
        }
    }

}
