//
//  TweetsDetailsViewController.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 9/28/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit

class TweetsDetailsViewController: UIViewController {

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var Tweet: UILabel!
    @IBOutlet weak var TimeStamp: UILabel!
    var posterUrl = ""
    var index = 0
    var id_str = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.posterImage.setImageWithURL(NSURL(string: posterUrl))
        UIView.transitionWithView(posterImage, duration: 0.9, options:UIViewAnimationOptions.CurveEaseOut , animations:{self.posterImage.alpha = 1}, completion: nil)
         var defaults = NSUserDefaults.standardUserDefaults()
        let text = defaults.objectForKey("tweeter\(self.index)") as String!
        screenName.text = "@\(text)"
        let name = defaults.objectForKey("tweeter_name\(self.index)") as String!
        fullName.text = name
        Tweet.text = defaults.objectForKey("tweet\(self.index)") as String!
        TimeStamp.text = defaults.objectForKey("tweeter_time\(self.index)") as String!
        id_str = defaults.objectForKey("id_str\(index)") as String!
        var layer:CALayer =  self.posterImage.layer
        layer.masksToBounds = true
        layer.cornerRadius = 7.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        let image = UIImage(named: "favorite_on") as UIImage
        favoriteButton.setBackgroundImage(image, forState: .Normal)
        TwitterClient.sharedInstance.favoriteWithId(id_str,  completion:  {(tweets, error)->() in
            
            })
        
    }

    @IBAction func onRetweet(sender: AnyObject) {
        let image = UIImage(named: "retweet_on") as UIImage
        retweetButton.setBackgroundImage(image, forState: .Normal)
        TwitterClient.sharedInstance.retweetWithId(id_str, completion:  {(tweets, error)->() in
            
            })
    }
    
    @IBAction func onReply(sender: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        let text = defaults.objectForKey("tweeter\(self.index)") as String!
        defaults.setObject("@\(text)", forKey: "replyTo")
        defaults.setObject(id_str, forKey: "id")
        println(id_str)
       
        defaults.setBool(false, forKey: "compose")
        println("here")
        
        
        defaults.synchronize()
       performSegueWithIdentifier("replySegue", sender: replyButton)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
