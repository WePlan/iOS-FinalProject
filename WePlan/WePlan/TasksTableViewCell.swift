//
//  TasksViewCell.swift
//  WePlan
//
//  Created by Kan Chen on 3/30/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

protocol TasksTableViewCellDelegate {
    func checkButtonPressed(index: NSIndexPath)
    func checkDeletePressed(index: NSIndexPath)
}

class TasksTableViewCell: UITableViewCell {
    var taskItem:TaskItem? {
        didSet{
            updateCell()
        }
    }
    
    
    @IBOutlet weak var taskDueDate: UILabel!
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var taskKindLabel: UILabel!
    @IBOutlet weak var expandCellGroupImage: UIImageView!
    @IBOutlet weak var groupButton: UIButton!
    var checkState: Bool? {
        didSet{
            if checkState != nil && checkState!{
                checkButton.setBackgroundImage(UIImage(named: "checked"), forState: UIControlState())
            }else {
                checkButton.setBackgroundImage(UIImage(named: "unchecked"), forState: UIControlState())
            }
        }
    }
    
    func updateCell() {
        if let item = self.taskItem {
            if item.kind != TaskKind.Group {
                let preImage = UIImage(named: "AddPeople")
                let tintedImage = preImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.expandCellGroupImage.image = tintedImage
                self.expandCellGroupImage.tintColor = UIColor.grayColor()
                self.groupButton.enabled = false
    
            }else{
                self.expandCellGroupImage.image = UIImage(named: "AddPeople")
                self.groupButton.enabled = true
            }
            if item.descript == "" {
//                taskDescribLabel.text = "No Description!"
            }else {
//                taskDescribLabel.text = item.descript
            }
            let id = item.owner
            
            //cal the date diff
            let format = NSDateFormatter()
            let currentDate = NSDate()
            format.timeStyle = NSDateFormatterStyle.ShortStyle
            let diffDays = item.dueTime.daysDiff(currentDate)
            let hourMins = format.stringFromDate(item.dueTime)
            
            switch (diffDays) {
            case 0:
                taskDueDate.text = "Due today at \(hourMins)"
            case 1:
                taskDueDate.text = "Due tomorrow at \(hourMins)"
            case 2...7:
                taskDueDate.text = "Due in \(diffDays) days at \(hourMins)"
            case 8...30:
                let diffWeeks = item.dueTime.weeksDiff(currentDate)
                taskDueDate.text = "Due in \(diffWeeks) weeks at \(hourMins)"
            case 31...366:
                let diffMonths = item.dueTime.monthsDiff(currentDate)
                taskDueDate.text = "Due in \(diffMonths) months"
            default:
                let diffYears = item.dueTime.yearsDiff(currentDate)
                taskDueDate.text = "Due in \(diffYears) years"
            }
            
            
            taskTitle.text = item.taskName
            switch item.kind {
            case .Individual:
                taskKindLabel.text = "Self"
                taskKindLabel.textColor = WePlanColors.blueColor()
            case .People:
                taskKindLabel.text = LocalFriendList.sharedInstance.getFriendName(objectId: id)
                taskKindLabel.textColor = WePlanColors.otherPeopleColor()
            case .Group:
                taskKindLabel.text = LocalGroupList.sharedInstance.getGroupName(objectId: id)
                taskKindLabel.textColor = WePlanColors.groupColor()
            
            }
            
            
        }
        
    }
    var index: NSIndexPath?
    var delegate: TasksTableViewCellDelegate?
    
    @IBAction func clickCheckButton(sender: AnyObject) {
        if delegate != nil {
            self.delegate!.checkButtonPressed(self.index!)
        }
    }
    // MARK: -ExpandCellButtonFunction
    
    @IBAction func deleteTask(sender: UIButton) {
        if delegate != nil {
            self.delegate!.checkDeletePressed(self.index!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.backgroundView = UIImageView(image: UIImage(named: "CellBackground"))
        var swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipe")
        swipe.direction = UISwipeGestureRecognizerDirection.Right
        swipe.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipe)
//        swipe.state =
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func swipe() {
        println("swiped!")
        if delegate != nil {
            self.delegate!.checkButtonPressed(self.index!)
        }
    }
    
//    func swipe2(gesture: UISwipeGestureRecognizer) {
//        switch gesture.state {
//            case .
//        }
//    }
    
    

}
