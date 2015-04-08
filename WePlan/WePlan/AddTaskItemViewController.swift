//
//  AddTaskItemViewController.swift
//  WePlan
//
//  Created by Kan Chen on 3/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class AddTaskItemViewController: UIViewController {
    var newTask: TaskItem?
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var format: NSDateFormatter = NSDateFormatter()
    
    func datePickerDateChanged(datepicker: UIDatePicker) {
        dateLabel.text = format.stringFromDate(datePicker.date)
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
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
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
        if countElements(taskTitleTextField.text) > 0 {
            newTask = TaskItem(name: taskTitleTextField.text, id: "", tagcolor: "")
        }
    }
    
    
    
}
