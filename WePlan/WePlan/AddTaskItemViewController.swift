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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
