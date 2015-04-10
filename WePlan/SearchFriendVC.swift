//
//  SearchFriendVC.swift
//  WePlan
//
//  Created by Kan Chen on 4/9/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class SearchFriendVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate{

    @IBOutlet weak var myTableview: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
   
    var friendsList: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableview.delegate = self
        myTableview.dataSource = self
        
        // Do any additional setup after loading the view.
//        searchDisplayController?.searchResultsDataSource = self
//        searchDisplayController?.searchResultsDelegate = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        ParseFriendAction.searchPeopleByNickname(searchText, complete: { (result:[User]) -> Void in
            self.friendsList = result
            println("Get \(result.count) Users")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                println("main")
//                self.myTableview.reloadData()
                self.searchDisplayController?.searchResultsTableView.reloadData()
            })
           
        })
    }
    
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier
//        tableView.dequeueReusableCellWithIdentifier("protoCell" ) as? UITableViewCell
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("protoCell" ) as? UITableViewCell
//        var cell: FriendTableViewCell? = tableView.dequeueReusableCellWithIdentifier("protoCell", forIndexPath: indexPath) as? FriendTableViewCell
        
        //configure cell
        if cell == nil {
//            println("aa")
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "protoCell") as FriendTableViewCell
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "protoCell")
        }
        
        cell?.textLabel?.text = friendsList[indexPath.row].name
        
        return cell!
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
