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
            if item.kind.rawValue != 3 {
                let preImage = UIImage(named: "AddPeople");
                let tintedImage = preImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                expandCellGroupImage.image = tintedImage
                expandCellGroupImage.tintColor = UIColor.grayColor()
                groupButton.enabled = false
            }
            taskKindLabel.text = item.owner
            taskTitle.text = item.taskName
            switch (item.kind.rawValue) {
            case 1:
                taskKindLabel.textColor = WePlanColors.blueColor()
            case 2:
                taskKindLabel.textColor = WePlanColors.otherPeopleColor()
            case 3:
                taskKindLabel.textColor = WePlanColors.groupColor()
            default:
                taskKindLabel.textColor = WePlanColors.blueColor()
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
