//
//  FriendSelectTableViewCell.swift
//  WePlan
//
//  Created by Kan Chen on 4/28/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class FriendSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var friendImageView: AsyncUIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func clickButton(sender: AnyObject) {
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
