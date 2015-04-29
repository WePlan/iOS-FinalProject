//
//  GroupTableViewCell.swift
//  WePlan
//
//  Created by Kan Chen on 4/27/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    var group:Group? {
        didSet{
            if let group = group {
                groupNameLabel.text = group.name
                let count = group.memberIds.count
                memberNumLabel.text = "\(count) members"
                
                let pfFile = group.groupImage
                
                asyncImageView.imageFile = pfFile
            }
        }
    }
    
    @IBOutlet weak var asyncImageView: AsyncUIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var memberNumLabel: UILabel!
    
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ImageProcess.changeImageViewRounded(self.asyncImageView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
