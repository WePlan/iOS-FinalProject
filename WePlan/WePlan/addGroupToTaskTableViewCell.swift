//
//  addGroupToTaskTableViewCell.swift
//  WePlan
//
//  Created by xi su on 4/30/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class addGroupToTaskTableViewCell: UITableViewCell {
    var groupItem:Group? {
        didSet {
            updateCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
