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
        self.searchDisplayController?.searchResultsTableView.registerClass(SearchFriendTableViewCell.classForCoder(), forCellReuseIdentifier: "proto2")
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
//                println("main")
                self.searchDisplayController?.searchResultsTableView.reloadData()
//                NSLog("ad: search %p", self.searchDisplayController!.searchResultsTableView!)
            })
           
        })
    }
    
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell:SearchFriendTableViewCell? = tableView.dequeueReusableCellWithIdentifier("protoCell" ) as? SearchFriendTableViewCell
//        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("protoCell" ) as? UITableViewCell

//        var cell: SearchFriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("protoCell", forIndexPath: indexPath) as! SearchFriendTableViewCell
        //configure cell
//        if cell == nil {
//            println("got a nil cell")
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "protoCell") as FriendTableViewCell

//            cell = SearchFriendTableViewCell(style: UITableViewStyle.Plain, reuseIdentifier: "protoCell") as? SearchFriendTableViewCell
//            cell!.user = friendsList[indexPath.row]
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "protoCell")
//        }else {
//            cell!.user = friendsList[indexPath.row]
//        }
//        cell.user = friendsList[indexPath.row]
        
//        cell?.textLabel?.text = friendsList[indexPath.row].name
//        NSLog("address of tableview: %p", self.myTableview)
        
//        return cell!
//        var cell: UITableViewCell?
        if tableView == self.myTableview {
            var cell = tableView.dequeueReusableCellWithIdentifier("protoCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        
        }else {
            var cell: SearchFriendTableViewCell? = tableView.dequeueReusableCellWithIdentifier("proto2", forIndexPath: indexPath) as! SearchFriendTableViewCell
//            cell.emailLabel.text = friendsList[indexPath.row].uemail
//            cell.nickNameLabel.text = friendsList[indexPath.row].name
            if cell != nil {
                println("cell != nil")
                cell!.uemail = friendsList[indexPath.row].uemail
                cell!.nickname = friendsList[indexPath.row].name
//                cell!.update()
            }
            return cell!
        }
        
//        return cell!
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
