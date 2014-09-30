//
//  ComposeViewController.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 9/28/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetText: UITextView!
    
    @IBOutlet weak var Name: UILabel!
    
    var parameters: [String: String] = ["":""]
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
       // self.profileImage.setImageWithURL(NSURL(User.currentUser?.profileImageUrl as String!))
        let urlprofile = User.currentUser?.profileImageUrl! as String!
      println(urlprofile)
        var defaults = NSUserDefaults.standardUserDefaults()
        let text = defaults.objectForKey("replyTo") as String!
        println("print:\(text)")
        
        let compose = defaults.boolForKey("compose") ?? true
        self.profileImage.setImageWithURL(NSURL(string: urlprofile))
        self.Name.text = User.currentUser?.name! as String!
        // Do any additional setup after loading the view.
        var layer:CALayer =  self.profileImage.layer
        layer.masksToBounds = true
        layer.cornerRadius = 7.0
       
        var tweetid = defaults.objectForKey("id") as String! ?? "compose"
        println("Tweet id:\(tweetid)")
        println(compose)
        if(!compose){
          self.tweetText.text = "\(text)"
     
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func onSave(sender: AnyObject) {
        
        var test = tweetText.text! as String
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var tweetid = defaults.objectForKey("id") as String! ?? "compose"
        println("Tweet id:\(tweetid)")
        
        TwitterClient.sharedInstance.updatewithStatus(test, tweetid: tweetid, completion: {(tweets, error1)->() in
            
            if(error1 != nil){
                 println("error in posting")
                
            }
            println("got it: \(tweets)")
            
            })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    @IBAction func onCancel(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
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
