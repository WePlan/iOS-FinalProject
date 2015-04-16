//
//  SearchFriendVC.swift
//  WePlan
//
//  Created by Kan Chen on 4/9/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class SearchFriendVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AddFriendsDelegate{

    @IBOutlet weak var myTableview: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    var friendsList: [User] = []
    
    var myFriendsSet = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableview.delegate = self
        myTableview.dataSource = self
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        ParseFriendAction.searchPeopleByNickname(searchText, friendSet: self.myFriendsSet ,complete: { (result:[User]) -> Void in
            self.friendsList = result
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.myTableview.reloadData()
            })
           
        })
    }
    
    func addNewFriendWithId(id: String) {
        ParseFriendAction.addFriend()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: SearchFriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("protoCell", forIndexPath: indexPath) as! SearchFriendTableViewCell
        
        cell.emailLabel.text = friendsList[indexPath.row].uemail
        cell.nickNameLabel.text = friendsList[indexPath.row].name
        cell.delegate = self
        
        return cell
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
