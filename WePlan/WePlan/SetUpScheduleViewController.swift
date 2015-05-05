//
//  SetUpScheduleViewController.swift
//  WePlan
//
//  Created by xi su on 5/3/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit
protocol UpdateDelegate {
    func updateCell(task:TaskItem)
}
class SetUpScheduleViewController: UIViewController {
    var delegate:UpdateDelegate?
    var task:TaskItem?{
        didSet{
            prepare()
        }
    }
//    var currentDate:NSDate?
    var changeToToday:NSDate?
    @IBAction func changeToToday(sender: UIButton) {
        
//        task?.dueTime =
        if changeToToday != nil {
            updateTask(changeToToday!)
        }
        

        
    }
    
    @IBAction func changeToTomorrow(sender: UIButton) {
        if let newDate = changeToToday?.addDays(1) {
            
            updateTask(newDate)
        }
        
        
    }
    
    @IBAction func changeToNextWeek(sender: UIButton) {
        if let newDate = changeToToday?.addDays(7) {
            updateTask(newDate)
        }

    }
    
    @IBAction func changeToNextMonth(sender: UIButton) {
        if let newDate = changeToToday?.addMonths(1) {
            updateTask(newDate)
        }
        

    }
    
    @IBAction func changeToNextQuarter(sender: UIButton) {
        if let newDate = changeToToday?.addMonths(3) {
            updateTask(newDate)
        }
        

    }
    @IBAction func changToNextHalfYear(sender: UIButton) {
        if let newDate = changeToToday?.addMonths(6) {
            updateTask(newDate)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        prepare()
        // Do any additional setup after loading the view.
    }
    func prepare(){
        if let task = self.task {
            let currentDate = NSDate()
            let days = task.dueTime.daysDiff(currentDate)
            self.changeToToday = self.task?.dueTime.addDays(-days)
            

        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateTask(updateDate:NSDate) {
        self.task?.dueTime = updateDate
        ParseAction.updateTask(self.task!, completion: { () -> Void in
            if self.delegate != nil {
                self.delegate!.updateCell(self.task!)
                self.back()
            }
            
        })
    }
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
