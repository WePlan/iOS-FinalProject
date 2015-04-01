//
//  TasksViewCell.swift
//  WePlan
//
//  Created by Kan Chen on 3/30/15.
//  Copyright (c) 2015 WP Group. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    
    var checkState: Bool? {
        didSet{
            if checkState != nil && checkState!{
                checkMark.image = UIImage(named: "checked")
            }else {
                checkMark.image = UIImage(named: "unchecked")
            }
        }
    }
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.backgroundView = UIImageView(image: UIImage(named: "CellBackground"))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
