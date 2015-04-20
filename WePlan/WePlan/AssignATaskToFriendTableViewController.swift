//
//  AssignATaskToFriendTableViewController.swift
//  WePlan
//
//  Created by xi su on 4/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class AssignATaskToFriendTableViewController: UITableViewController {

    var friend:User?
    var tasks:[TaskItem] = []
    
//    let checkMark = UIImageView(image: UIImage(named: AssignTaskStoryBoard.CheckMarkImageName))
     var format: NSDateFormatter = NSDateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        ParseAction.getInitialDataFromParse { (data) -> Void in
            self.tasks = data
            self.tableView.reloadData()
        }
//        println(tasks[0].taskName)
        self.tableView.allowsMultipleSelectionDuringEditing = true
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
        return tasks.count
    }
    private struct AssignTaskStoryBoard {
        static let AssignTaskCellIdentifier = "TaskList"
        static let AssignTskDefaultCellIdentifier = "taskListDefault"
        static let CheckMarkImageName = "CompleteNoWord"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AssignTaskStoryBoard.AssignTskDefaultCellIdentifier, forIndexPath: indexPath) as! AssignTaskToFriendTableViewCell
        
        //custon cell format
//        cell.taskCheckImage.image = nil
//        format.timeStyle = NSDateFormatterStyle.ShortStyle
        format.dateStyle = NSDateFormatterStyle.MediumStyle
//        cell.taskDate.text = format.stringFromDate(tasks[indexPath.row].dueTime)
//        cell.taskNameLabel.text = tasks[indexPath.row].taskName
//        // Configure the cell...
        
        //Configure default cell
        cell.textLabel?.text = tasks[indexPath.row].taskName
        cell.detailTextLabel?.text = format.stringFromDate(tasks[indexPath.row].dueTime)
        
        return cell
    }
    var selectedIndex = -1
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            var check:Bool = cell.accessoryType == UITableViewCellAccessoryType.Checkmark
            
            println(check)
            
//            cell.accessoryView = checkMark
            if cell.accessoryType != UITableViewCellAccessoryType.Checkmark {
                cell.tintColor = WePlanColors.blueColor()
                cell.contentView.backgroundColor = UIColor.whiteColor()
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                
                //
                
            }else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
//            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
//        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

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
