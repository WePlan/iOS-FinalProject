//
//  FriendSelectTableViewCell.swift
//  WePlan
//
//  Created by Kan Chen on 4/28/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

protocol FriendSelectTableDelegate {
    func selectFriend(uid: String)
    func deselectFriend(uid: String)
}

class FriendSelectTableViewCell: UITableViewCell {
    var delegate: FriendSelectTableDelegate?
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var friendImageView: AsyncUIImageView!
    
    var uid: String = ""
    var chose: Bool? {
        didSet{
            if chose == true {
                selectButton.setBackgroundImage(UIImage(named: "checked"), forState: UIControlState())
                delegate?.selectFriend(uid)
            }else{
                selectButton.setBackgroundImage(UIImage(named: "unchecked"), forState: UIControlState())
                delegate?.deselectFriend(uid)
            }
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chose = false
        ImageProcess.changeImageViewToCircle(self.friendImageView)
    }
    
    @IBAction func clickButton(sender: AnyObject) {
        if chose! {
            chose = false
        }else{
            chose = true
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
