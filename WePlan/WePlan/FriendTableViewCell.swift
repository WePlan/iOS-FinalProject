//
//  FriendTableViewCell.swift
//  WePlan
//
//  Created by Kan Chen on 4/9/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    var friend: User? {
        didSet{
            updateCell()
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!

    @IBOutlet weak var userDetailButton: UIButton!
    
    @IBAction func userDetail(sender: UIButton) {
    }
    
    private struct StoryBoardConstant{
        static let UserDetaultImage = "UserDefaultPic"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateCell() {
        userNameLabel?.text = nil
        userProfileImage?.image = UIImage(named: StoryBoardConstant.UserDetaultImage)
        userEmailLabel?.text = nil
        
        if let user = self.friend {
            userNameLabel?.text = user.name
            userEmailLabel?.text = user.uemail
            //UserImage part
//            if let userImage = user.image {
//            userProfileImage?.image = UIImage()
//            }
        
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
