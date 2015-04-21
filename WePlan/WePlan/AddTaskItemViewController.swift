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
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
    var format: NSDateFormatter = NSDateFormatter()
    
    func datePickerDateChanged(datepicker: UIDatePicker) {
        dateLabel.text = format.stringFromDate(datePicker.date)
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareDatePicker()
        
        self.taskTitleTextField.delegate = self
        
        format.timeStyle = NSDateFormatterStyle.ShortStyle
        format.dateStyle = NSDateFormatterStyle.MediumStyle
    
        let current = datePicker.date
        dateLabel.text = format.stringFromDate(current)
    }
    
    override func viewWillAppear(animated: Bool) {
        DefaultSetting.setNavigationBar(self.navigationController!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        taskTitleTextField.resignFirstResponder()
    }
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
