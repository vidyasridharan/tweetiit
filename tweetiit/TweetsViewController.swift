//
//  TweetsViewController.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 9/27/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var refreshControl: UIRefreshControl!
    var tweet: [Tweet]?
    
    
    @IBOutlet weak var tableView: UITableView!
    var indexofCurrent  = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        var defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(true, forKey: "compose")
        println("reached")
        
        TwitterClient.sharedInstance.homeTimelineWithParameters(nil, completion: {(tweets, error)->() in
            
            if(tweets != nil){
                self.tweet = tweets!
                    defaults.setInteger(tweets!.count, forKey: "tweetcount")
                println("got here")
                var index = 0
                for tweet in tweets!{
                    defaults.setObject(tweet.text, forKey: "tweet\(index)")
                    defaults.setObject(tweet.user?.screenname as String!, forKey: "tweeter\(index)")
                    defaults.setObject(tweet.createdAtString as String!, forKey: "tweeter_time\(index)")
                    defaults.setObject(tweet.user?.profileImageUrl as String!, forKey: "tweeter_image\(index)")
                    defaults.setObject(tweet.user?.name as String!, forKey: "tweeter_name\(index)")
                
                    defaults.setInteger(tweet.retweeted!, forKey: "retweeted\(index)")
                    defaults.setInteger(tweet.favorited!, forKey: "favorited\(index)")
                    defaults.setObject(tweet.id_str! as String!, forKey: "id_str\(index)")
                   println(tweet.user?.profileImageUrl)
                    println("retweeted\(tweet.retweeted!)")
                    println("retweeted\(tweet.id_str! as String)")
                    index = index + 1
                }

            }
            
             defaults.synchronize()
        })
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("twitterCell") as TweetCellViewCell
        var defaults = NSUserDefaults.standardUserDefaults()
       
        cell.cellContent.text = defaults.objectForKey("tweet\(indexPath.row)") as String!
        let text = defaults.objectForKey("tweeter\(indexPath.row)") as String!
        cell.screenName.text = "@\(text)"
        let posterUrlplaceholder = defaults.objectForKey("tweeter_image\(indexPath.row)") as String!
        let time = defaults.objectForKey("tweeter_time\(indexPath.row)") as String!
        println("\(posterUrlplaceholder)")
        cell.setImage(posterUrlplaceholder)
        cell.createdAtString.text = time
        
        println(indexofCurrent)
        TwitterClient.sharedInstance.homeTimelineWithParameters(nil, completion: {(tweets, error)->() in
            if(tweets != nil){
                self.tweet = tweets!
                cell.cellContent.text = tweets![indexPath.row].text
                let text = "@\(tweets![indexPath.row].user?.screenname as String!)"
                println(text);
                cell.screenName.text = text
                let posterUrl = "\(tweets![indexPath.row].user?.profileImageUrl as String!)"
                cell.createdAtString.text = tweets![indexPath.row].createdAtString
                cell.setImage(posterUrl)
                println(posterUrl)
               
            }
        })
      
        
     
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected")
        indexofCurrent = indexPath.row
        println("Here is indexPath.row\(indexPath.row)")
//        performSegueWithIdentifier("", sender: tableView.cellForRowAtIndexPath(indexPath), editActionsForRowAtIndexPath: <#NSIndexPath#>)
        //        var defaults = NSUserDefaults.standardUserDefaults()
        //
        //        cell.cellContent.text = defaults.objectForKey("tweet\(indexPath.row)") as String!
        //        let text = defaults.objectForKey("tweeter\(indexPath.row)") as String!
        //        cell.screenName.text = "@\(text)"
        //        let posterUrlplaceholder = defaults.objectForKey("tweeter_image\(indexPath.row)") as String!
        //        println("\(posterUrlplaceholder)")
        
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var defaults = NSUserDefaults.standardUserDefaults()
        var cellcount = defaults.integerForKey("tweetcount")
//        TwitterClient.sharedInstance.homeTimelineWithParameters(nil, completion: {(tweets, error)->() in
//            if(tweets != nil){
//                self.tweet = tweets!
//                cellcount = tweets!.count
//               
//            }
//        })
       //println("this is the name\(self.tweet![0].user?.name)")
        
        return cellcount
    }
    
    
    @IBAction func onCompose(sender: AnyObject) {
        
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        
        
         if(segue.identifier == "tweetSegue"){
         var vc = segue.destinationViewController as TweetsDetailsViewController
            //vc.fullName.text! = "name"
           // vc.screenName!.text = "@\(text)"
            var defaults = NSUserDefaults.standardUserDefaults()
            
            var index = tableView.indexPathForSelectedRow()!.row
            
            let posterUrlplaceholder = defaults.objectForKey("tweeter_image\(index)") as String!
            println("\(posterUrlplaceholder)")
            vc.index =  index
            vc.posterUrl = posterUrlplaceholder
            
        }

    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }

}
