//
//  AddPeopleToTaskTableViewCell.swift
//  WePlan
//
//  Created by xi su on 4/20/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class AddPeopleToTaskTableViewCell: UITableViewCell {
    
    var friend:User? {
        didSet{
            updateCell()
        }
    }
    @IBOutlet weak var userProfileImage: AsyncUIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    private struct StoryBoardConstant{
        static let UserDetaultImage = "UserDefaultPic"
    }
    func updateCell() {
        
        
        if let user = self.friend {
            userNameLabel?.text = user.name
            userEmailLabel?.text = user.uemail
            userProfileImage.imageObjectId = user.imageId
            //UserImage part
            //            if let userImage = user.image {
            //            userProfileImage?.image = UIImage()
            //            }
        }else{
            userNameLabel?.text = nil
            userEmailLabel?.text = nil
            //            userProfileImage?.image = UIImage(named: StoryBoardConstant.UserDetaultImage)
            userProfileImage.defaultImageName = StoryBoardConstant.UserDetaultImage
            
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
