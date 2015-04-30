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
    
    private func initialUISettings() {
        DefaultSetting.setNavigationBar(self.navigationController!)
       
//        self.tabBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "TapBarTaskGrey")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage.init(named: "TapBarTaskBlue")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
//        
//        self.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
//        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarFriendGrey"), selectedImage: UIImage.init(named: "TapBarFriendBlue"))
//        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarGroupGrey"), selectedImage: UIImage.init(named: "TapBarGroupBlue"))
//        self.tabBarItem = UITabBarItem.init(title: "as", image: UIImage.init(named: "TapBarSettingGrey"), selectedImage: UIImage.init(named: "TapBarSettingBlue"))
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
//        static let cellHeight: CGFloat = 60
        static let commonCellHeight: CGFloat = 54
        static let expandingCellHeight: CGFloat = 87
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return tasks.count + 1
    }
    var selectedTask: Int = -1
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedTask != -1 && selectedTask == indexPath.row {
            return TaskTableViewConstant.expandingCellHeight
        }else{
            return TaskTableViewConstant.commonCellHeight
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == tasks.count {
            let cell =  tableView.dequeueReusableCellWithIdentifier("Empty", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCellPrototype", forIndexPath: indexPath) as! TasksTableViewCell

        // Configure the cell...
        var item = tasks[indexPath.row]
        cell.clipsToBounds = true
        
        cell.checkState = item.checked
        cell.taskItem = item
        println("kind+\(item.kind.rawValue)")
//        cell.taskTitle.text = item.taskName

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.index = indexPath
        cell.delegate = self
//        cell.taskKindLabel.text = item.owner
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if selectedTask == indexPath.row {
            selectedTask = -1
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            return
        }
        else if selectedTask != -1 {
            let prevIndexPath:NSIndexPath = NSIndexPath(forRow: selectedTask, inSection: 0)
            selectedTask = indexPath.row
            tableView.reloadRowsAtIndexPaths([prevIndexPath], withRowAnimation: .Automatic)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }else{
            
            selectedTask = indexPath.row
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }

    }
    // MARK: - expanding cell button delegate
    func checkDeletePressed(indexPath:NSIndexPath) {
        let deleteName = tasks[indexPath.row].taskName
        let deleteId = self.tasks[indexPath.row].uniqueId
        //Alert
        var alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete \(deleteName)", preferredStyle: UIAlertControllerStyle.Alert)
        // Delete the row from the data source
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { action in
            self.tasks.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            ParseAction.deleteItem(deleteId)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    //deleteButton at task cell
//    @IBAction func deleteTask(sender: UIButton) {
//        let cell = sender.superview?.superview as! TasksTableViewCell
//        //        let tableView = cell.superview?.superview as! UITableView
//
//        if let indexPath = tableView.indexPathForCell(cell) {
//            //            ParseAction.deleteItem(self.tasks[indexPath.row].uniqueId)
//            
//            //            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            let deleteName = tasks[indexPath.row].taskName
//            let deleteId = self.tasks[indexPath.row].uniqueId
//            //Alert
//            var alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete \(deleteName)", preferredStyle: UIAlertControllerStyle.Alert)
//            // Delete the row from the data source
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
//            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { action in
//                self.tasks.removeAtIndex(indexPath.row)
//                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//                ParseAction.deleteItem(deleteId)
//                
//            }))
//            self.presentViewController(alert, animated: true, completion: nil)
//            
//        }
//
//    }
    func checkButtonPressed(index: NSIndexPath) {
        var tappedItem = tasks[index.row]
        tappedItem.checked = !tappedItem.checked
        tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
//        override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//            selectedTask = -1
////            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        return UITableViewCellEditingStyle.Delete
//    }
    
   
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }
    

    
    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        if editingStyle == .Delete {
//            
//            // Delete the row from the data source
//            ParseAction.deleteItem(self.tasks[indexPath.row].uniqueId)
//            self.tasks.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "TaskListToAdd" {
            let dest = segue.destinationViewController as! UINavigationController
            let first = dest.childViewControllers[0] as! AddTaskItemViewController
            first.entrypoint = "Task"
        }
    }
    
    @IBAction func unwindTaskList (segue: UIStoryboardSegue){
        var src = segue.sourceViewController as! AddTaskItemViewController
        var task = src.newTask
        if task != nil {
            tasks.append(task!)
            self.tableView.reloadData()
            ParseAction.addTaskItem(task!, completion: { (resultId: String) -> Void in
                task!.uniqueId = resultId
            })
        }
    }


}
