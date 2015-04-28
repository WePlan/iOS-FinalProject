//
//  FriendTableViewCell.swift
//  WePlan
//
//  Created by Kan Chen on 4/9/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

protocol FriendTableCellDeleget {
    func toAddTask()
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
    
//    @IBAction func removeFriend(sender: UIButton) {
//        if let deleteUser = self.friend {
//            let deleteId = deleteUser.uid
//            //        self.friendList.removeAtIndex(indexPath.row)
//            //        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            ParseFriendAction.deleteFriend(deleteId, complete: { (result :Bool) -> Void in
//                if result == true {
//                    println("Deleted!")
//                }else {
//                    println("fail!")
//                }
//            })
//        }
//        
//        
//    }
    @IBAction func clickAssign(sender: AnyObject) {
        self.delegate?.toAddTask()
        
    }

    @IBAction func userDetail(sender: UIButton) {
    }
    
   
    
        private struct StoryBoardConstant{
        static let UserDetaultImage = "UserDefaultPic"
        static let expandingHeight:CGFloat = 90
        static let commonHeight:CGFloat = 55
    }
//    func cellButtonTaggle(){
//        if frame.size.height < StoryBoardConstant.expandingHeight {
//            assignATaskButton.hidden = true
//            removeFriendButton.hidden = true
//        }else{
//            assignATaskButton.hidden = false
//            removeFriendButton.hidden = false
//        }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
//    func noticeCell() {
//        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
//        cellButtonTaggle()
//    }
//    func endNoticeCell() {
//        removeObserver(self, forKeyPath: "frame")
//    }
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//        if keyPath == "frame" {
//            cellButtonTaggle()
//        }
//    }
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    

}
