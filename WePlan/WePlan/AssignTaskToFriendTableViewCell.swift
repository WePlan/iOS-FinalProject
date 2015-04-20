//
//  AssignTaskToFriendTableViewCell.swift
//  WePlan
//
//  Created by xi su on 4/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class AssignTaskToFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskCheckImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
