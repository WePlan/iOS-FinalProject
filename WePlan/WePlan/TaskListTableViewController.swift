//
//  TaskListTableViewController.swift
//  WePlan
//
//  Created by Kan Chen on 3/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController, TasksTableViewCellDelegate {
    var tasks:[TaskItem] = []
    
    @IBAction func unwindTaskList (segue: UIStoryboardSegue){
        var src = segue.sourceViewController as AddTaskItemViewController
        var task = src.newTask
        if task != nil {
            tasks.append(task!)
            self.tableView.reloadData()
            ParseAction.addTaskItem(task!.taskName, completion: { (resultId: String) -> Void in
                task!.uniqueId = resultId
            })
        }
    }
    
    private func initialUISettings() {
        DefaultSetting.setNavigationBar(self.navigationController!)
        
        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "Home"), selectedImage: UIImage.init(named: "Home"))
//        self.tabBarController?.tabBar.tintColor = UIColor.redColor()
//        self.tabBarController?.tabBar.backgroundColor = UIColor.purpleColor()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
        ParseAction.getInitialDataFromParse { (data) -> Void in
            self.tasks = data
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        initialUISettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    private struct TaskTableViewConstant {
        static let cellHeight: CGFloat = 60
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return tasks.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TaskTableViewConstant.cellHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCellPrototype", forIndexPath: indexPath) as TasksTableViewCell

        // Configure the cell...
        var item = tasks[indexPath.row]
        
        cell.checkState = item.checked
        cell.taskTitle.text = item.taskName

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.index = indexPath
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func checkButtonPressed(index: NSIndexPath) {
        var tappedItem = tasks[index.row]
        tappedItem.checked = !tappedItem.checked
        tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
        override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
   
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            ParseAction.deleteItem(self.tasks[indexPath.row].uniqueId)
            self.tasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
