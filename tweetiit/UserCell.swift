//
//  UserCell.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 10/5/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var Mentions: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
