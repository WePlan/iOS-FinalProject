//
//  AddTaskItemViewController.swift
//  WePlan
//
//  Created by Kan Chen on 3/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class AddTaskItemViewController: UIViewController, UITextFieldDelegate,AssignTaskToOtherPeopleDelegate, AssignTaskToGroupDelegate , MBProgressHUDDelegate {
    var newTask: TaskItem?

    private struct StoryBoardConstants {
        static let backgroundImageName = "BackgroundButtonBlue-50%trans"
        static let assignTaskToOtherPeopleSegue = "AddPeopleToTask"
        static let assignTaskToGroupSegue = "AddGroupToNewTask"
    }
    var entrypoint:String?
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var taskForMemberLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var pickerViewBackgroundImageView: UIImageView!
    //Not implemented
    @IBOutlet weak var taskLocationTextField: UITextField!
    @IBOutlet weak var shortDescriptionTextField: UITextField!
    
    @IBOutlet weak var mySelfButton: UIButton!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var otherPeopleButton: UIButton!
    
    @IBOutlet weak var pickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerViewBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDatePicker()
        
        self.taskTitleTextField.delegate = self

        taskForMemberLabel.text = ""
        if assignPeople != nil && "Friend" == entrypoint{
            mySelfButton.enabled = false
            groupButton.enabled = false
            assignTaskToOtherPeople(assignPeople!)
        }
        if "Group" == entrypoint && assignGroup != nil {
            mySelfButton.enabled = false
            otherPeopleButton.enabled = false
            assignTaskToGroup(assignGroup!)
        }
        if newTask != nil && "Task" == entrypoint{
            taskTitleTextField.text = newTask?.taskName ?? ""
            taskLocationTextField.text = newTask?.location ?? ""
            shortDescriptionTextField.text = newTask?.descript ?? ""
            groupButton.enabled = false
            otherPeopleButton.enabled = false
            assignTaskToMyself()
            format.timeStyle = NSDateFormatterStyle.ShortStyle
            format.dateStyle = NSDateFormatterStyle.MediumStyle

            if let prevDueDate = newTask?.dueTime {
                dateLabel.text = format.stringFromDate(prevDueDate)
            }
            addButton.setTitle("Save", forState: UIControlState.Normal)
            
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        DefaultSetting.setNavigationBar(self.navigationController!)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let size = self.view.frame.size
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TaskforButoon

    var taskFor = TaskKind.Individual
    var taskOwner = PFUser.currentUser()!.username!
//    var assignTaskToName = PFUser.currentUser()!.username!
    //for assign to other people
    var taskUID:String?
    var assignPeople:User?
    var assignGroup:Group?
    let buttonBackgroundImage = UIImage(named: StoryBoardConstants.backgroundImageName)
    @IBAction func mySelfButton(sender: UIButton) {
        assignTaskToMyself()
//        taskFor = TaskKind(rawValue: 1)!
////        taskUID = PFUser.currentUser()!.objectId!
//        taskOwner = PFUser.currentUser()!.username!
//        taskForMemberLabel.text = PFUser.currentUser()!.username!
//        
//       mySelfButton.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
//        groupButton.setBackgroundImage(nil, forState: UIControlState.Normal)
//        otherPeopleButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        
    }
    func assignTaskToMyself(){
        taskFor = TaskKind(rawValue: 1)!
        //        taskUID = PFUser.currentUser()!.objectId!
        taskOwner = PFUser.currentUser()!.username!
        taskForMemberLabel.text = PFUser.currentUser()!.username!
        
        mySelfButton.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
        groupButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        otherPeopleButton.setBackgroundImage(nil, forState: UIControlState.Normal)
    }
    
    func assignTaskToOtherPeople(assignPeople: User) {
        println("123123123")
//        taskFor = TaskKind(rawValue: 2)!   modified by ck
        taskFor = TaskKind.People
        taskOwner = PFUser.currentUser()!.username!
        
        self.assignPeople = assignPeople
        taskForMemberLabel.text = assignPeople.name
//        taskUID = assignPeople.uid
        mySelfButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        groupButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        otherPeopleButton.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
    }
    
    func assignTaskToGroup(assignGroup:Group) {
//        taskFor = TaskKind(rawValue: 3)!   modified by ck
        taskFor = TaskKind.Group
        taskOwner = assignGroup.name ?? ""
        
        self.assignGroup = assignGroup
        taskForMemberLabel.text = assignGroup.name
        //        taskUID = assignGroup.id
        mySelfButton.setBackgroundImage(nil, forState: UIControlState.Normal)
        groupButton.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
        otherPeopleButton.setBackgroundImage(nil, forState: UIControlState.Normal)
    }
//    @IBAction func OtherPeopleButton(sender: UIButton) {
//        
//        taskOwner = PFUser.currentUser()!.username!
//        taskFor = TaskKind(rawValue: 2)!
//        mySelfButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
//        groupButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
//        otherPeopleButtonLabel.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
////        performSegueWithIdentifier(StoryBoardConstants.assignTaskToOtherPeopleSegue, sender: self)
////        if taskUID == nil {
////            return
////        }else{
////            
////        }
//        
//    }

//    @IBAction func groupButton(sender: UIButton) {
//        taskFor = TaskKind(rawValue: 3)!
//        taskOwner = assignGroup?.name ?? ""
//        mySelfButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
//        groupButtonLabel.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
//        otherPeopleButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
//    }
    //AbovePart Not Implementd
    

    
    //MARK: - Misc
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        let touch: UITouch = touches.first as! UITouch
//        let touchPoint = touch.locationInView(self.view)
//        let labelBounds = dateLabel.frame
//        println(touchPoint)
//        println(labelBounds)
//        if labelBounds.contains(touchPoint){
//            println("touched")
//            tapDateLabel()
//        }
        taskLocationTextField.resignFirstResponder()
        shortDescriptionTextField.resignFirstResponder()
        taskTitleTextField.resignFirstResponder()
    }
    // MARK: - Navigation
    @IBAction func clickAddButton(sender: AnyObject) {
        if count(taskTitleTextField.text) < 1 {
            return
        }
        var hub = MBProgressHUD(view: self.view)
        self.view.addSubview(hub)
        hub.delegate = self
        hub.show(true)
        hub.labelText = "Processing..."
        
        newTask = TaskItem(name: taskTitleTextField.text, due: datePicker.date, descript: shortDescriptionTextField.text)
        switch self.taskFor {
            case .Individual:
                newTask!.kind = TaskKind.Individual
                newTask!.owner = PFUser.currentUser()!.objectId!
                ParseAction.addTaskItem(newTask!, completion: { (id:String) -> Void in
                    //
                    hub.hide(true)
                    self.performUnwindSegue(self.addButton)
                })
            case .People:
                assert(assignPeople != nil, "assignPeople is nil")
                newTask!.kind = TaskKind.People
                newTask!.owner = assignPeople!.uid
                ParseFriendAction.addFriendTask(newTask!, toFriendId: assignPeople!.uid, completion: { (id: String) -> Void in
                    //
                    hub.hide(true)
                    self.performUnwindSegue(self.addButton)
                })
            
            case .Group:
                assert(assignGroup != nil, "assign group is nil") // TODO: segue group assign value
                newTask!.kind = TaskKind.Group
                newTask!.owner = assignGroup!.id
                ParseGroupAction.assignGroupTask(newTask!, groupId: assignGroup!.id, members: assignGroup!.memberIds, complete: { () -> Void in
                    //
                    hub.hide(true)
                    self.performUnwindSegue(self.addButton)
                })
        }
        
    }
    
    @IBAction func clickBackButton(sender: AnyObject) {
        performUnwindSegue(self)
    }
    
    @IBAction func clickCancelButton(sender: UIButton) {
        performUnwindSegue(self.cancelButton)
    }
    private func performUnwindSegue(sender: AnyObject?) {
        if "Task" == entrypoint {
            performSegueWithIdentifier("unwindTaskList", sender: sender)
        }
        if "Group" == entrypoint {
            performSegueWithIdentifier("unwindGroupDetail", sender: sender)
        }
        if "Friend" == entrypoint {
            performSegueWithIdentifier("unwindFriendList", sender: sender)
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == StoryBoardConstants.assignTaskToOtherPeopleSegue {
            if let vc = segue.destinationViewController as? AddPeopleToTaskTableViewController {
                println("1234")
                vc.delegate = self
                if assignPeople != nil {
                    vc.alreadyAssignedPeople = assignPeople
                }
            }
        }
        if segue.identifier == StoryBoardConstants.assignTaskToGroupSegue {
            if let tvc = segue.destinationViewController as? AddGroupToTaskTableViewController {
                tvc.delegate = self
                if assignGroup != nil {
                    tvc.alreadyAssignedGroup = assignGroup
                }
            }
        }
        
        if sender as? UIButton != self.addButton {
            return
        }

        

    }
    
    
    
    
    //MARK: - DatePicker and its View
    var format: NSDateFormatter = NSDateFormatter()
    var pickerDisplayed: Bool = false
    
    private func prepareDatePicker() {
        format.timeStyle = NSDateFormatterStyle.ShortStyle
        format.dateStyle = NSDateFormatterStyle.MediumStyle
        let now = NSDate()
        let oneYearTime: NSTimeInterval = 365*24*60*60
        let oneYearFromNow = now.dateByAddingTimeInterval(oneYearTime)
        datePicker.minimumDate = now
        datePicker.maximumDate = oneYearFromNow
        datePicker.addTarget(self, action: "datePickerDateChanged:", forControlEvents: .ValueChanged)
        
        self.pickerViewBackgroundImageView.image = UIImage(named: "PickerBackground")
        
        let current = datePicker.date
        dateLabel.text = format.stringFromDate(current)
        dateLabel.userInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: "tapDateLabel")
        dateLabel.addGestureRecognizer(singleTap)
    }
    
    func datePickerDateChanged(datepicker: UIDatePicker) {
        dateLabel.text = format.stringFromDate(datePicker.date)
    }
    
    @IBAction func clickDoneInPicker(sender: AnyObject) {
        hidePickerView()
    }
    
    func tapDateLabel() {
        if self.pickerDisplayed {
            hidePickerView()
        }else{
            showPickerView()
        }
    }
    
    func showPickerView(){
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5,options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.pickerViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            }) { (finished:Bool) -> Void in
                self.pickerDisplayed = true
        }
    }
    
    func hidePickerView(){
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5,options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.pickerViewBottomConstraint.constant = 200
            self.view.layoutIfNeeded()
            }) { (finished:Bool) -> Void in
                self.pickerDisplayed = false
        }
        
    }

    
}
