//
//  AddTaskItemViewController.swift
//  WePlan
//
//  Created by Kan Chen on 3/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class AddTaskItemViewController: UIViewController, UITextFieldDelegate,AssignTaskToOtherPeopleDelegate {
    var newTask: TaskItem?
    var group: Group?
    private struct StoryBoardConstants {
        static let backgroundImageName = "BackgroundButtonBlue-50%trans"
        static let assignTaskToOtherPeopleSegue = "AddPeopleToTask"
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
    
    @IBOutlet weak var mySelfButtonLabel: UIButton!
    @IBOutlet weak var groupButtonLabel: UIButton!
    @IBOutlet weak var otherPeopleButtonLabel: UIButton!
    
    @IBOutlet weak var pickerViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pickerViewBottomConstraint: NSLayoutConstraint!
    // MARK: -taskforButoon

    var taskFor = TaskKind.Individual
    var taskOwner = PFUser.currentUser()!.username!
//    var assignTaskToName = PFUser.currentUser()!.username!
    //for assign to other people
    var taskUID:String?
    var assignPeople:User?
    let buttonBackgroundImage = UIImage(named: StoryBoardConstants.backgroundImageName)
    @IBAction func mySelfButton(sender: UIButton) {
        taskFor = TaskKind(rawValue: 1)!
        taskUID = PFUser.currentUser()!.username!
        taskOwner = PFUser.currentUser()!.username!
        taskForMemberLabel.text = PFUser.currentUser()!.username!
       mySelfButtonLabel.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
        groupButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        otherPeopleButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        
    }
    func assignTaskToOtherPeople(assignPeople: User) {
        println("123123123")
        taskOwner = PFUser.currentUser()!.username!
        taskFor = TaskKind(rawValue: 2)!
        mySelfButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        groupButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        otherPeopleButtonLabel.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
        
        self.assignPeople = assignPeople
        taskForMemberLabel.text = assignPeople.name
        taskUID = assignPeople.uid
        
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
    @IBAction func groupButton(sender: UIButton) {
        taskFor = TaskKind(rawValue: 3)!
        taskOwner = group?.name ?? ""
        mySelfButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        groupButtonLabel.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
        otherPeopleButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
    }
    //AbovePart Not Implementd
    
    
    
    //MARK: - DatePicker and its View
    var format: NSDateFormatter = NSDateFormatter()
    var pickerDisplayed: Bool = false
   
    private func prepareDatePicker() {
        let now = NSDate()
        let oneYearTime: NSTimeInterval = 365*24*60*60
        let oneYearFromNow = now.dateByAddingTimeInterval(oneYearTime)
        datePicker.minimumDate = now
        datePicker.maximumDate = oneYearFromNow
        datePicker.addTarget(self, action: "datePickerDateChanged:", forControlEvents: .ValueChanged)
        
        self.pickerViewBackgroundImageView.image = UIImage(named: "PickerBackground")
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
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareDatePicker()
        
        self.taskTitleTextField.delegate = self
        
        format.timeStyle = NSDateFormatterStyle.ShortStyle
        format.dateStyle = NSDateFormatterStyle.MediumStyle
        taskForMemberLabel.text = ""
        if assignPeople != nil && "Friend" == entrypoint{
            mySelfButtonLabel.enabled = false
            groupButtonLabel.enabled = false
            assignTaskToOtherPeople(assignPeople!)
        }
        let current = datePicker.date
        dateLabel.text = format.stringFromDate(current)
        dateLabel.userInteractionEnabled = true
        let singleTap = UITapGestureRecognizer(target: self, action: "tapDateLabel")
        dateLabel.addGestureRecognizer(singleTap)
        
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
        performUnwindSegue(self.addButton)
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
        if sender as? UIButton != self.addButton {
            return
        }
        if count(taskTitleTextField.text) > 0 {
//            newTask = TaskItem(name: taskTitleTextField.text, id: "", due: datePicker.date, tagcolor: "")
            if taskUID != nil  {
                
                newTask = TaskItem(name: taskTitleTextField.text, id: taskUID!, due: datePicker.date, tagcolor: "",taskOwner:taskOwner, kind: taskFor)
            }
            
        }
    }
    
    
    
    
    
}
