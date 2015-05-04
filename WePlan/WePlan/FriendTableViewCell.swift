//
//  FriendTableViewCell.swift
//  WePlan
//
//  Created by Kan Chen on 4/9/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

protocol FriendTableCellDeleget {
    func toAddTask(friend:User)
    func removeFriendDelegate(friend:User)
}

class FriendTableViewCell: UITableViewCell {
    var delegate: FriendTableCellDeleget?
    var friend: User? {
        didSet{
            updateCell()
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImage: AsyncUIImageView!
    @IBOutlet weak var userEmailLabel: UILabel!

    @IBOutlet weak var userDetailButton: UIButton!
    
    @IBAction func clickAssign(sender: AnyObject) {
        if let friend = self.friend {
            self.delegate?.toAddTask(friend)
        }
    }

    @IBAction func clickRemoveFriend(sender: UIButton) {
        if delegate != nil {
            self.delegate!.removeFriendDelegate(self.friend!)
        }
        
    }
    @IBAction func userDetail(sender: UIButton) {
    }
    
   
    
    private struct StoryBoardConstant{
        static let UserDetaultImage = "UserDefaultPic"
        static let expandingHeight:CGFloat = 90
        static let commonHeight:CGFloat = 55
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ImageProcess.changeImageViewToCircle(self.userProfileImage)
    }
    func updateCell() {
        if let user = self.friend {
            userNameLabel?.text = user.name
            userEmailLabel?.text = user.uemail
            userProfileImage.imageFile = user.imageFile
//            if user.imageId == nil {
//                userProfileImage.defaultImageName = StoryBoardConstant.UserDetaultImage
//            }else{
//                userProfileImage.imageObjectId = user.imageId
//            }
        }else{
            userNameLabel?.text = nil
            userEmailLabel?.text = nil
            userProfileImage.defaultImageName = StoryBoardConstant.UserDetaultImage
            
        }
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    

}
