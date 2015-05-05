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
    func swipeLeft(task: TaskItem )
    func swipeRight(task: TaskItem )
//    func checkEditButtonPressed(task:TaskItem,index:NSIndexPath)
    func moveToEnd(task: TaskItem )
    func moveToFirst(task: TaskItem)
    
    func deleteCell(task:TaskItem)
    
    func clickGroupDetail(task:TaskItem)
}

class TasksTableViewCell: UITableViewCell {
    var taskItem:TaskItem? {
        didSet{
            updateCell()
            let w = self.frame.size.width
            lineLength = w - 60
//            println("linelength \(lineLength)")
        }
    }
    var endIndex: Int!
    
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var taskDescribLabel: UILabel!
    @IBOutlet weak var taskDueDate: UILabel!
    
    @IBOutlet weak var taskTitle: UILabel!
//    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var taskKindLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var kindCircleView: UIView!
    
    @IBOutlet weak var expandCellGroupImage: UIImageView!
    @IBOutlet weak var expandCellScheduleImage: UIImageView!
    
    @IBOutlet weak var expandCellEditImage: UIImageView!
    
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteCellButton: UIButton!
    
    func updateCell() {
        if let item = self.taskItem {
            let preImage = UIImage(named: "AddPeople")
            let tintedImage = preImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.expandCellGroupImage.image = tintedImage
            self.expandCellGroupImage.tintColor = UIColor.lightGrayColor()
            self.groupButton.enabled = false
            
            self.scheduleButton.enabled = false
            
            let editTintedImage = UIImage(named: "Edit")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.expandCellEditImage.image = editTintedImage
            self.expandCellEditImage.tintColor = UIColor.lightGrayColor()
            self.editButton.enabled = false
            
            
            if item.kind == TaskKind.Group {
                self.expandCellGroupImage.image = UIImage(named: "AddPeople")
//                self.expandCellGroupImage.tintColor = WePlanColors.blueColor()
                self.groupButton.enabled = true
                
            }
            if item.kind == TaskKind.Individual {
                self.expandCellEditImage.image = UIImage(named: "Edit")
                self.scheduleButton.enabled = true
                self.editButton.enabled = true
            }
            
            //description
            if item.descript == "" {
                taskDescribLabel.text = "No Description!"
            }else {
                taskDescribLabel.text = item.descript
            }
            let id = item.owner
            
            //cal the date diff
            let format = NSDateFormatter()
            let currentDate = NSDate()
            format.timeStyle = NSDateFormatterStyle.ShortStyle
            let diffDays = item.dueTime.daysDiff(currentDate)
            let hourMins = format.stringFromDate(item.dueTime)
            
            let result = currentDate.compare(item.dueTime)
            if result == NSComparisonResult.OrderedDescending {
                let diff = -diffDays
                taskDueDate.text = "past"
                taskDueDate.textColor = UIColor.redColor()
            }
            else if diffDays == 0 {
                
                taskDueDate.text = "\(hourMins)"
            }else if diffDays == 1 {
                taskDueDate.text = "Tomorrow"
            }else if diffDays >= 2 && diffDays <= 7 {
                taskDueDate.text = "In \(diffDays) days"
            }else if diffDays >= 8 && diffDays <= 30 {
                let diffWeeks = item.dueTime.weeksDiff(currentDate)
                taskDueDate.text = "In \(diffWeeks) weeks"
            }else if diffDays >= 31 && diffDays <= 366 {
                let diffMonths = item.dueTime.monthsDiff(currentDate)
                taskDueDate.text = "In \(diffMonths) months"
            }
//            if diffDays < 0 {
//                let diff = -diffDays
//                taskDueDate.text = "\(diff) days before"
//                taskDueDate.textColor = UIColor.redColor()
//            }else if diffDays == 0 {
//                
//                taskDueDate.text = "Today at \(hourMins)"
//            }else if diffDays == 1 {
//                taskDueDate.text = "Tomorrow"
//            }else if diffDays >= 2 && diffDays <= 7 {
//                taskDueDate.text = "In \(diffDays) days"
//            }else if diffDays >= 8 && diffDays <= 30 {
//                let diffWeeks = item.dueTime.weeksDiff(currentDate)
//                taskDueDate.text = "In \(diffWeeks) weeks"
//            }else if diffDays >= 31 && diffDays <= 366 {
//                let diffMonths = item.dueTime.monthsDiff(currentDate)
//                taskDueDate.text = "In \(diffMonths) months"
//            }
//            switch (diffDays) {
//            
//            case 0:
//                taskDueDate.text = "Today at \(hourMins)"
//            case 1:
//                taskDueDate.text = "Tomorrow at \(hourMins)"
//            case 2...7:
//                taskDueDate.text = "In \(diffDays) days at \(hourMins)"
//            case 8...30:
//                let diffWeeks = item.dueTime.weeksDiff(currentDate)
//                taskDueDate.text = "In \(diffWeeks) weeks at \(hourMins)"
//            case 31...366:
//                let diffMonths = item.dueTime.monthsDiff(currentDate)
//                taskDueDate.text = "In \(diffMonths) months"
//            default:
//                let diffMonths = item.dueTime.monthsDiff(currentDate)
//                taskDueDate.text = "In \(diffMonths) months"
//            default:
//                let diffYears = item.dueTime.yearsDiff(currentDate)
//                taskDueDate.text = "In \(diffYears) years"
//            }
            if diffDays == 0 {
                expandCellScheduleImage.image = UIImage(named: "ScheduleNoWordRedDot")
            }else{
                expandCellScheduleImage.image = UIImage(named: "ScheduleNoWord")
            }
            
            
            taskTitle.text = item.taskName
            switch item.kind {
            case .Individual:
                kindLabel.text = ""
                taskKindLabel.text = "Self"
                taskKindLabel.textColor = WePlanColors.blueColor()
                kindCircleView.backgroundColor = WePlanColors.blueColor()
            case .People:
                kindLabel.text = "Friend"
                kindLabel.textColor = WePlanColors.otherPeopleColor()
                taskKindLabel.text = LocalFriendList.sharedInstance.getFriendName(objectId: id)
                taskKindLabel.textColor = WePlanColors.otherPeopleColor()
                kindCircleView.backgroundColor = WePlanColors.otherPeopleColor()
            case .Group:
                kindLabel.text = "Group"
                taskKindLabel.text = LocalGroupList.sharedInstance.getGroupName(objectId: id)
                if taskKindLabel.text == "dismissed" {
                    taskKindLabel.textColor = UIColor.redColor()
                }else{
                    taskKindLabel.textColor = WePlanColors.groupColor()
                }
                kindLabel.textColor = WePlanColors.groupColor()
                kindCircleView.backgroundColor = WePlanColors.groupColor()
                
            }
            
            if item.checked {
                self.taskTitle.textColor = UIColor.grayColor()
                self.deleteImage.hidden = false
                self.deleteCellButton.hidden = false
            }else{
                self.taskTitle.textColor = UIColor.blackColor()
                self.deleteImage.hidden = true
                self.deleteCellButton.hidden = true
            }
            
        }
        
    }

    

    var checkState: Bool? {
        didSet{
            if checkState != nil && checkState!{
                //checked
                self.width.constant = self.lineLength
                self.layoutIfNeeded()
                
//                checkButton.setBackgroundImage(UIImage(named: "checked"), forState: UIControlState())
            }else {
                //unchecked
                self.width.constant = 0
                self.layoutIfNeeded()
//                checkButton.setBackgroundImage(UIImage(named: "unchecked"), forState: UIControlState())
            }
        }
    }
    
    var index: NSIndexPath?
    var delegate: TasksTableViewCellDelegate?
    
//    @IBAction func clickEditButton(sender: UIButton) {
//        if delegate != nil {
//            self.delegate!.checkEditButtonPressed(self.taskItem!,index: self.index!)
//        }
//    }
    
//    @IBAction func clickCheckButton(sender: AnyObject) {
//        if delegate != nil {
//            self.delegate!.checkButtonPressed(self.index!)
//        }
//    }
    @IBAction func clickGroup(sender: AnyObject) {
        if delegate != nil{
            delegate!.clickGroupDetail(self.taskItem!)
        }
        
        
    }
    @IBAction func clickCheckButton(sender: AnyObject) {
        swipeRight()
    }
    
    @IBAction func clickCellDeleteButtonn(sender: AnyObject) {
        if delegate != nil {
            self.delegate!.deleteCell(self.taskItem!)
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
        ImageProcess.kindCircle(self.kindCircleView)
//        self.backgroundView = UIImageView(image: UIImage(named: "CellBackground"))
        setupSwipeGesture()
//        swipe.state =
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    // MARK: - Swipe
    
    func setupSwipeGesture() {
        var swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        swipe.direction = UISwipeGestureRecognizerDirection.Right
        swipe.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipe)
        
        var swipeleft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        swipeleft.direction = UISwipeGestureRecognizerDirection.Left
        swipeleft.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipeleft)
    }
    
    func swipeRight() {
        if checkState == false {
            println("swiped! right")
            crossLine()
            if delegate != nil {
                delegate?.swipeRight(taskItem!)
            }

            checkState = true
        }
    }
    
    func swipeLeft() {
        if checkState == true {
            println("left")
            uncrossLine()
            if delegate != nil {
                delegate?.swipeLeft(taskItem!)
            }
            
            checkState = false
        }
    }
    
    // MARK: Cross out animation

    @IBOutlet weak var line: UIView!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    var lineLength: CGFloat!
    
    private func crossLine() {
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            //
            self.width.constant = self.lineLength
            self.layoutIfNeeded()
            }) { (finished:Bool) -> Void in
            self.deleteCellButton.hidden = false
            self.deleteImage.hidden = false
            self.taskTitle.textColor = UIColor.grayColor()
//                println("going to move")
            self.delegate?.moveToEnd(self.taskItem!)
        }
    }
    
    private func uncrossLine() {
        self.deleteCellButton.hidden = true
        self.deleteImage.hidden = true
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.width.constant = 0
            self.layoutIfNeeded()
            }) { (finished:Bool) -> Void in
            
            self.taskTitle.textColor = UIColor.blackColor()
            self.delegate?.moveToFirst(self.taskItem!)
            
        }
    }
    
}
