//
//  AddTaskItemViewController.swift
//  WePlan
//
//  Created by Kan Chen on 3/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class AddTaskItemViewController: UIViewController, UITextFieldDelegate {
    var newTask: TaskItem?
    private struct StoryBoardConstants {
        static let backgroundImageName = "BackgroundButtonBlue-50%trans"
    }
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIView!
    //Not implemented
    @IBOutlet weak var taskLocationTextField: UITextField!
    @IBOutlet weak var shortDescriptionTextField: UITextField!
    
    @IBOutlet weak var mySelfButtonLabel: UIButton!
    @IBOutlet weak var groupButtonLabel: UIButton!
    @IBOutlet weak var otherPeopleButtonLabel: UIButton!
    
    var taskFor: String = ""
    let buttonBackgroundImage = UIImage(named: StoryBoardConstants.backgroundImageName)
    @IBAction func mySelfButton(sender: UIButton) {
        taskFor = "Myself"
       mySelfButtonLabel.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
        groupButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        otherPeopleButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        
    }
    
    @IBAction func OtherPeopleButton(sender: UIButton) {
        taskFor = "OtherPeople"
        mySelfButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        groupButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        otherPeopleButtonLabel.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
        
    }
    @IBAction func groupButton(sender: UIButton) {
        taskFor = "Group"
        mySelfButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
        groupButtonLabel.setBackgroundImage(buttonBackgroundImage, forState: UIControlState.Normal)
        otherPeopleButtonLabel.setBackgroundImage(nil, forState: UIControlState.Normal)
    }
    //AbovePart Not Implementd
    
    
    //MARK: - DatePicker and its View
    var format: NSDateFormatter = NSDateFormatter()
    var pickerDisplayed: Bool = false
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func prepareDatePicker() {
        let now = NSDate()
        let oneYearTime: NSTimeInterval = 365*24*60*60
        
        let oneYearFromNow = now.dateByAddingTimeInterval(oneYearTime)
        datePicker.minimumDate = now
        datePicker.maximumDate = oneYearFromNow
        datePicker.addTarget(self, action: "datePickerDateChanged:", forControlEvents: .ValueChanged)
    }
    
    func datePickerDateChanged(datepicker: UIDatePicker) {
        dateLabel.text = format.stringFromDate(datePicker.date)
    }
    
    func tapDateLabel() {
        println("tapped")
        if self.pickerDisplayed {
            //hide View
            hidePickerView()
        }else{
            //show View
            showPickerView()
        }
    }
    
    func showPickerView(){
        self.addButton.hidden = true
        self.cancelButton.hidden = true
        println("show")
        let frame = self.view.frame
        println(frame.height)
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.pickerView.frame = CGRectMake(0, frame.height, frame.width, 200)
            }) { (finished:Bool) -> Void in
            //
            self.pickerDisplayed = true
        }
    }
    
    func hidePickerView(){
        println("hide")
        let frame = self.view.frame
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.pickerView.frame = CGRectMake(0, frame.height+200, frame.width, 0)
            }) { (finished:Bool) -> Void in
            //
            self.pickerDisplayed = false
            self.addButton.hidden = false
            self.cancelButton.hidden = false
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
    
        let current = datePicker.date
        dateLabel.text = format.stringFromDate(current)
        dateLabel.userInteractionEnabled = true
        let singleTap = UIGestureRecognizer(target: self, action: "tapDateLabel")
        dateLabel.addGestureRecognizer(singleTap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        DefaultSetting.setNavigationBar(self.navigationController!)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let size = self.view.frame.size
        println(size)
        println(pickerView.frame)
        self.pickerView.frame = CGRectMake(0, size.height+200, 375, 0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        let touch: UITouch = touches.first as! UITouch
//        let touchPoint = touch.locationInView(self.view)
//        let labelBounds = dateLabel.frame
//        println(touchPoint)
//        println(labelBounds)
//        if labelBounds.contains(touchPoint){
//            println("touched")
//            tapDateLabel()
//        }
//        taskTitleTextField.resignFirstResponder()
//    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender as? UIButton != self.addButton {
            return
        }
        if count(taskTitleTextField.text) > 0 {
            newTask = TaskItem(name: taskTitleTextField.text, id: "", due: datePicker.date, tagcolor: "")
        }
    }
    
    
    
}
