//
//  ShowGroupMemberCell.swift
//  WePlan
//
//  Created by Huibo Li on 4/30/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class ShowGroupMemberCell: UITableViewCell {

    var Member:User?{
        didSet{
            updateCell()
        }
    }
    
    @IBOutlet weak var MemberImage: AsyncUIImageView!
    @IBOutlet weak var MemberNameLabel: UILabel!
    @IBOutlet weak var MemberEmailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(){
        MemberImage.imageObjectId=Member?.imageId
        ImageProcess.changeImageViewRounded(MemberImage)
        MemberNameLabel.text=Member?.name
        MemberEmailLabel.text=Member?.uemail
    }

}
