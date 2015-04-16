
//
//  SearchFriendTableViewCell.swift
//  WePlan
//
//  Created by Kan Chen on 4/10/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

protocol AddFriendsDelegate {
    func addNewFriendWithId(id: String)
}

class SearchFriendTableViewCell: UITableViewCell {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User? {
        didSet{
            if user != nil {
                nickNameLabel.text = user!.name
                emailLabel.text = user!.uemail
            }
        }
    }
    var delegate: AddFriendsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickAddButton(sender: AnyObject) {
        if delegate != nil {
            self.addButton.enabled = false
            //TODO:
//            delegate?.addNewFriendWithId(id: String)
        }
    }
}
