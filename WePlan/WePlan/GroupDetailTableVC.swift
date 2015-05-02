//
//  GroupDetailTableVC.swift
//  WePlan
//
//  Created by Huibo Li on 4/29/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class GroupDetailTableVC: UITableViewController {

    var user = PFUser.currentUser()!
    var group:Group!
    var MemberList:[User]!
    //TODO: Local User is pfuser.currentuser
    //TODO: something wrong with using Parse callback func
    func getGroupMembersListFromParse(completion: () -> Void) {
        ParseGroupAction.getGroupMembers(group.memberIds, complete: { (UserList:[User]) -> Void in
            self.MemberList=UserList
            completion()
        })
    }
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupDetailLabel: UILabel!
    @IBOutlet weak var groupMemberCount: UILabel!
    
    @IBOutlet weak var DismissButton: UIButton!
    @IBOutlet weak var QuitButton: UIButton!
    @IBOutlet weak var GroupImage: AsyncUIImageView!
    
    private struct StoryBoardConstant{
        static let TopreviousView="BacktoGroupList"
        static let ToNextView="ShowGroupMember"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getGroupMembersListFromParse { () -> Void in
            println("Init current members")
        }
        
        //Group image
        GroupImage.imageFile = group.groupImage
        self.GroupImage.layer.borderWidth = 3.0
        self.GroupImage.layer.borderColor = UIColor.whiteColor().CGColor
        //self.GroupImage.layer.cornerRadius = 20.0
        ImageProcess.changeImageViewRounded(self.GroupImage)
        
        var currentID=user.objectId
        println("\(group.ownerId) and \(currentID)")
        //Button
        if group.ownerId == currentID{   //Owner of the group
            //QuitButton.hidden=true
            //QuitButton.titleLabel?.textColor=UIColor.grayColor()
            QuitButton.enabled=false
            QuitButton.alpha=0.6
            DismissButton.enabled=true

        }
        else{
            //DismissButton.hidden=true
            //DismissButton.titleLabel?.textColor=UIColor.grayColor()
            DismissButton.enabled=false
            DismissButton.alpha=0.6
            QuitButton.enabled=true
        }
        groupNameLabel.text=group.name
        groupDetailLabel.text=group.description
        groupMemberCount.text=String(group.memberIds.count)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func ToShowGroupMembers(sender: AnyObject) {
        performSegueWithIdentifier("ShowGroupMember", sender: self)
    }
    
    
    @IBAction func DismisGroup(sender: AnyObject) {
        var DismissAlert = UIAlertController(title: "Sure to Dismiss?", message:
            "The group will not exist.", preferredStyle: UIAlertControllerStyle.Alert)
        DismissAlert.addAction(UIAlertAction(title: "Cancle", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            println("choose cancle")
            return
        }))
        DismissAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
            println("choose yes!!")
            //Dismiss Group
            ParseGroupAction.dismissGroup(self.group.id)
        }))
        self.presentViewController(DismissAlert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func QuitGroup(sender: AnyObject) {
        var QuitAlert = UIAlertController(title: "Sure to Quit?", message:
            "You will not get task send form this group.", preferredStyle: UIAlertControllerStyle.Alert)
        QuitAlert.addAction(UIAlertAction(title: "Cancle", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            println("choose cancle")
        }))
        QuitAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
            println("choose yes!!")
            //Quit Group
            ParseGroupAction.quitGroup(self.group.id)
        }))
        self.presentViewController(QuitAlert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section==1{
            //Go to GroupMemberView
            if indexPath.row==1{
                performSegueWithIdentifier("ShowGroupMember", sender: self)
            }
            //Go to Assign a Task
            if indexPath.row==2{
                let taskSB:UIStoryboard = UIStoryboard(name: "Tasks", bundle: NSBundle.mainBundle())
                let vc = taskSB.instantiateViewControllerWithIdentifier("addTaskEntry") as! UINavigationController
                let a = vc.childViewControllers[0] as! AddTaskItemViewController
                a.entrypoint = "Group"
                a.assignGroup = group
                presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
    @IBAction func unwindGroupDetail(segue: UIStoryboardSegue){
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier=="ShowGroupMember"{
            var nextvc=segue.destinationViewController as! ShowGroupMemberVC
            nextvc.group=group
            nextvc.MemberList=self.MemberList
        }
        
    }
    

}
