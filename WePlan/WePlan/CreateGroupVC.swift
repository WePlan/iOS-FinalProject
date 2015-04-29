//
//  CreateGroupVC.swift
//  WePlan
//
//  Created by Kan Chen on 4/24/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController ,UITableViewDataSource, UITableViewDelegate, FriendSelectTableDelegate{
    var localFriendsList = LocalFriendList.sharedInstance
    @IBOutlet weak var gruopNameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var groupImageView: AsyncUIImageView!
    @IBOutlet weak var memberNumLabel: UILabel!
    
    @IBOutlet weak var friendsTableView: UITableView!
    var selectedFriends:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localFriendsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendSelectedCell", forIndexPath: indexPath) as! FriendSelectTableViewCell
        cell.nameLabel.text = localFriendsList.friendList[indexPath.row].name
        cell.friendImageView.imageObjectId = localFriendsList.friendList[indexPath.row].imageId
        cell.uid = localFriendsList.friendList[indexPath.row].uid
        cell.delegate = self
        return cell
    }
    
    func selectFriend(uid: String) {
        selectedFriends.append(uid)
        memberNumLabel.text = "\(selectedFriends.count)"
    }
    func deselectFriend(uid: String) {
        var find = -1
        for index in 0..<selectedFriends.count {
            if selectedFriends[index] == uid {
                find = index
                break
            }
        }
        
        if find != -1{
            selectedFriends.removeAtIndex(find)
            memberNumLabel.text = "\(selectedFriends.count)"
        }
    }
    // MARK: - Misc.
    @IBAction func clickBack(sender: AnyObject) {
    }
    
    @IBAction func clickCreate(sender: AnyObject) {
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
