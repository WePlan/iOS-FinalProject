//
//  addGroupToTaskTableViewCell.swift
//  WePlan
//
//  Created by xi su on 4/30/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class addGroupToTaskTableViewCell: UITableViewCell {
    var groupItem:Group?
        {
        didSet {
            updateCell()
        }
    }

    
    
    @IBOutlet weak var groupImagePic: AsyncUIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var grouopMemberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    private struct AddGroupToTaskTableViewCellConstant {
        static let GroupDefaultImage = "GroupDefaultPic"
    }

    func updateCell() {
        if let group = self.groupItem {
            groupImagePic.imageFile = group.groupImage
            groupNameLabel?.text = group.name
            let count = group.memberIds.count
            grouopMemberLabel.text = "\(count) members"
        }
//        else {
//            groupImagePic.defaultImageName = AddGroupToTaskTableViewCellConstant.GroupDefaultImage
//            userNameLabel?.text = nil
//            userEmail
//        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
