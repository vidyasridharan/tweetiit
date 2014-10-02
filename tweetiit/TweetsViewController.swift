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
    var tweets: [Tweet]?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "loadTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.rowHeight  = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 114
        self.loadTweets()

    }
    
    func loadTweets(){
            TwitterClient.sharedInstance.homeTimelineWithParameters(nil, completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
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
        cell.cellContent.text = self.tweets?[indexPath.row].text as String!
        cell.screenName.text = "@\(self.tweets?[indexPath.row].user?.screenname as String!)"
        cell.setImage(self.tweets?[indexPath.row].user?.profileImageUrl as String!)
        cell.createdAtString.text = self.tweets?[indexPath.row].createdAtString as String!
        return cell
    }
    
 
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.tweets != nil){
            return self.tweets!.count
        }
        return 0
    }
    
    
    @IBAction func onCompose(sender: AnyObject) {
                self.performSegueWithIdentifier("composeSegue", sender: self)
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if(segue.identifier == "composeSegue"){
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "compose")
            println("here")

        }
        
         if(segue.identifier == "tweetSegue"){
         var vc = segue.destinationViewController as TweetsDetailsViewController
            
            vc.tweet = self.tweets![tableView.indexPathForSelectedRow()!.row] as Tweet
            
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

}
