//
//  TaskListTableViewController.swift
//  WePlan
//
//  Created by Kan Chen on 3/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController, TasksTableViewCellDelegate,MBProgressHUDDelegate {
    var tasks:[TaskItem] = []
    
    private func initialUISettings() {
        DefaultSetting.setNavigationBar(self.navigationController!)
       
//        self.tabBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: "TapBarTaskGrey")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage.init(named: "TapBarTaskBlue")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
//        
//        self.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.initialLocalFriendAndGroupandTask()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        initialUISettings()
    }
    
    private func initialLocalFriendAndGroupandTask() {
        var hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud)
        hud.delegate = self
        hud.show(true)
        hud.labelText = "Loading..."
        
        LocalFriendList.sharedInstance.getFriendListFromParse { () -> Void in
            //
            println("friendlist initial at start")
            LocalGroupList.sharedInstance.updateAll { () -> Void in
                //
                println("grouplist initial at start")
                ParseAction.getInitialDataFromParse { (data) -> Void in
                    self.tasks = data
                    self.tableView.reloadData()
                    hud.hide(true)
                }

            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    private struct TaskTableViewConstant {
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
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCellPrototype", forIndexPath: indexPath) as! TasksTableViewCell

        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let item = tasks[indexPath.row]
        cell.clipsToBounds = true
        cell.taskItem = item
        cell.checkState = item.checked
        
//        println("kind+\(item.kind.rawValue)")
        
        cell.index = indexPath
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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
    

    func checkButtonPressed(index: NSIndexPath) {
        var tappedItem = tasks[index.row]
        tappedItem.checked = !tappedItem.checked
        tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
    }

    func swipeLeft(index: NSIndexPath) {
        //
        let swipedItem = tasks[index.row]
        swipedItem.checked = false
        println("cell \(index.row) is unchecked now")
    }
    
    func swipeRight(index: NSIndexPath) {
        //
        let swipedItem = tasks[index.row]
        swipedItem.checked = true
        println("cell \(index.row) is checked now")

    }
   
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
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
    func move() {
        //
//        tableView.moveRowAtIndexPath(indexPath: NSIndexPath, toIndexPath: NSIndexPath)
    }
    
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
        if segue.identifier == "EditTaskIdentifier" {
            let dvc = segue.destinationViewController as! UINavigationController
            let first = dvc.childViewControllers[0] as! AddTaskItemViewController
            first.entrypoint = "Task"
//            if let indexPath = self.tableView.indexPathForCell((sender?.superview!!.superview as! TasksTableViewCell)) {
//                first.newTask = tasks[indexPath.row]
//                
//            }
            first.newTask = tasks[selectedTask]
            
            
            
        }
    }
    
    @IBAction func unwindTaskList (segue: UIStoryboardSegue){
        var src = segue.sourceViewController as! AddTaskItemViewController
        var task = src.newTask
        if let task = task {
            if task.kind != TaskKind.People {
                ParseAction.getInitialDataFromParse { (data) -> Void in
                    self.tasks = data
                    self.tableView.reloadData()
                }
            }
        }
    }


}
