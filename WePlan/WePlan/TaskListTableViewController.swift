//
//  TaskListTableViewController.swift
//  WePlan
//
//  Created by Kan Chen on 3/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit


class TaskListTableViewController: UITableViewController, TasksTableViewCellDelegate,MBProgressHUDDelegate,UpdateDelegate {
//    var tasks:[TaskItem] = []
    var localTasks = LocalList.sharedInstance
    var initialed = false
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBAction func clickRefresh(sender: AnyObject) {
        refreshList()
    }
    
    func refreshList() {
        var hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud)
        hud.delegate = self
        hud.show(true)
        hud.labelText = "Loading..."
        
        refreshButton.enabled = false
        localTasks.updateAll { () -> Void in
            self.tableView.reloadData()
            self.refreshButton.enabled = true
            
            hud.hide(true)
        }
    }
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
        if initialed {
//            refreshList()
            
            localTasks.sortByDue()
            localTasks.sortByCheck()
            tableView.reloadData()
        }
    }
    
    private func initialLocalFriendAndGroupandTask() {
        var hud = MBProgressHUD(view: self.view)
        self.view.addSubview(hud)
        hud.delegate = self
        hud.show(true)
        hud.labelText = "Loading..."
        
        LocalFriendList.sharedInstance.getFriendListFromParse { () -> Void in
            //
            print("friendlist initial at start")
            LocalGroupList.sharedInstance.updateAll { () -> Void in
                //
                print("grouplist initial at start")
                self.localTasks.updateAll({ () -> Void in
                    self.tableView.reloadData()
                    hud.hide(true)
                    self.initialed = true
                })
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    private struct TaskTableViewConstant {
        static let commonCellHeight: CGFloat = 50 //54
        static let expandingCellHeight: CGFloat = 110 //87
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return localTasks.count + 1
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
        if indexPath.row == localTasks.count {
            let cell =  tableView.dequeueReusableCellWithIdentifier("Empty", forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCellPrototype", forIndexPath: indexPath) as! TasksTableViewCell

        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let item = localTasks.taskList[indexPath.row]
        cell.clipsToBounds = true
        cell.taskItem = item
        cell.checkState = item.checked
        cell.endIndex = localTasks.count-1
        print("cell index: \(indexPath.row) is loading, due: \(item.dueTime)")
        cell.index = indexPath
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if selectedTask == indexPath.row {
            selectedTask = -1
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            return
        }
        else if selectedTask != -1 {
            let prevIndexPath:NSIndexPath = NSIndexPath(forRow: selectedTask, inSection: 0)
            selectedTask = indexPath.row
            tableView.reloadRowsAtIndexPaths([prevIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }else{
            
            selectedTask = indexPath.row
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }

    }
    
    
    // MARK: - expanding cell button delegate
    func clickGroupDetail(task:TaskItem) {
        let groupSB = UIStoryboard(name: "Groups", bundle: NSBundle.mainBundle())
        let vc = groupSB.instantiateViewControllerWithIdentifier("groupMembersTableVC") as! ShowGroupMemberVC
        assert(task.kind == TaskKind.Group, "task sort should be 3")
        let groupId = task.owner
        
        vc.entry = 9
        vc.groupId = groupId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkDeletePressed(indexPath:NSIndexPath) {
        let deleteName = localTasks.taskList[indexPath.row].taskName
        let deleteId = localTasks.taskList[indexPath.row].uniqueId
        //Alert
        var alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete \(deleteName)", preferredStyle: UIAlertControllerStyle.Alert)
        // Delete the row from the data source
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { action in
            self.localTasks.removeAt(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            ParseAction.deleteItem(deleteId)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    func checkButtonPressed(index: NSIndexPath) {
        var tappedItem = localTasks.taskList[index.row]
        tappedItem.checked = !tappedItem.checked
        tableView.reloadRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
    }

    func deleteCell(task: TaskItem) {
        let index = findIndexPath(task)
        localTasks.removeAt(index.row)
        tableView.deleteRowsAtIndexPaths([index], withRowAnimation: UITableViewRowAnimation.Automatic)
        ParseAction.deleteItem(task.uniqueId)
        
    }
    
    func swipeLeft(task: TaskItem) {
        //
        let index = findIndexPath(task)
        let swipedItem = localTasks.taskList[index.row]
        swipedItem.checked = false
        
        ParseAction.changeTaskCheck(swipedItem, checked: false)
        print("cell \(index.row) is unchecked now")
    }
    
    func swipeRight(task: TaskItem) {
        //
        let index = findIndexPath(task)
        let swipedItem = localTasks.taskList[index.row]
        swipedItem.checked = true
        ParseAction.changeTaskCheck(swipedItem, checked: true)
        print("cell \(index.row) is checked now")

    }
    
//    func moveToEnd(index: NSIndexPath)
    func moveToEnd(task: TaskItem)
    {
        let index = findIndexPath(task)
        print("Right move index: \(index.row)")
        let oldPath = index
        var newPath = localTasks.getNewPathForRemove(task)
        tableView.moveRowAtIndexPath(oldPath, toIndexPath: newPath)
        self.tableView(self.tableView, moveRowAtIndexPath: oldPath, toIndexPath: newPath)
//        tableView.reloadData()
    }
    
    
    func moveToFirst(task: TaskItem)
    {
        let index = findIndexPath(task)
        print("Left move index: \(index.row)")
        let oldPath = index
        var newPath = localTasks.getNewPathForBack(task)

        tableView.moveRowAtIndexPath(oldPath, toIndexPath: newPath)
        self.tableView(self.tableView, moveRowAtIndexPath: oldPath, toIndexPath: newPath)
//        tableView.reloadData()
    }
    func updateCell(task: TaskItem) {
        let index = findIndexPath(task)
        tableView.reloadRowsAtIndexPaths([index], withRowAnimation: .Automatic)
    }
    private func findIndexPath(task:TaskItem) -> NSIndexPath {
        var indexPath: NSIndexPath!
        for var index = 0 ; index < localTasks.count ; index++ {
            if localTasks.taskList[index].uniqueId == task.uniqueId {
                indexPath = NSIndexPath(forRow: index, inSection: 0)
                break
            }
        }
        return indexPath
    }
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        print("datasource func invoked")
        for each in self.localTasks.taskList {
            print( each.taskName)
        }
        localTasks.swap(fromIndexPath.row, to: toIndexPath.row)
//        let tmp = tasks[fromIndexPath.row]
//        tasks.removeAtIndex(fromIndexPath.row)
//        tasks.insert(tmp, atIndex: toIndexPath.row)
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return false
    }

    
    
    

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
        if segue.identifier == "SetUpScheduleIdentifier" {
            let dvc = segue.destinationViewController as! SetUpScheduleViewController
            dvc.delegate = self
            dvc.task = localTasks.taskList[selectedTask]
            
        }
        if segue.identifier == "EditTaskIdentifier" {
            let dvc = segue.destinationViewController as! UINavigationController
            let first = dvc.childViewControllers[0] as! AddTaskItemViewController
            first.entrypoint = "Task"
//            if let indexPath = self.tableView.indexPathForCell((sender?.superview!!.superview as! TasksTableViewCell)) {
//                first.newTask = tasks[indexPath.row]
//                
//            }
            first.newTask = localTasks.taskList[selectedTask]
            
            
            
        }
    }
    
    @IBAction func unwindTaskList (segue: UIStoryboardSegue){
//        self.tableView.reloadData()
        var src = segue.sourceViewController as! AddTaskItemViewController
        var task = src.newTask
        if let task = task {
            if task.kind != TaskKind.People {
                localTasks.updateAll({ () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }


}
