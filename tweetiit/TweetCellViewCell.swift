//
//  TweetCellViewCell.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 9/27/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit

class TweetCellViewCell: UITableViewCell {

    @IBOutlet weak var cellContent: UILabel!
    
    @IBOutlet weak var createdAtString: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    var posterUrl: NSString?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setImage (posterUrl: String) -> Void{
        self.posterImage.setImageWithURL(NSURL(string: posterUrl))
        UIView.transitionWithView(posterImage, duration: 0.9, options:UIViewAnimationOptions.CurveEaseOut , animations:{self.posterImage.alpha = 1}, completion: nil)
        var layer:CALayer =  self.posterImage.layer
        layer.masksToBounds = true
        layer.cornerRadius = 7.0
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
