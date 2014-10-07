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
    var panStartCoordinate: CGPoint!
    var direction = ""
    var profileViewController: UIViewController!
    var  menuViewController: UIViewController!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containerView: UITableView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var storyboard = UIStoryboard(name:"Main", bundle: nil)
        menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as UIViewController
        profileViewController   = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as UIViewController
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
    
    
    @IBAction func onProfileButton(sender: AnyObject) {
        self.tableView.addSubview(profileViewController.view)
    }
   
    @IBAction func ontimeLineButton(sender: AnyObject) {
        self.profileViewController.view.removeFromSuperview()
    }
    
    
    
    @IBAction func panGestureRecognizer(sender: AnyObject) {
        var point = panGestureRecognizer.locationInView(self.view)
        
        if(panGestureRecognizer.state == UIGestureRecognizerState.Began){
            panStartCoordinate = point
            println("began")
        }
        else if (panGestureRecognizer.state == UIGestureRecognizerState.Changed){
            var distance = point.x - panStartCoordinate.x
            if(distance > 0){
                direction = "R"
            }
            else{
                direction = "L"
                distance = 0
            }
            
            println("changed")
            
            
        }
        else if (panGestureRecognizer.state == UIGestureRecognizerState.Ended ){
            
            if(direction == "R"){
                
                UIView .animateWithDuration(0.5, delay: 0, options: (UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveEaseIn), animations: {
                        var frame = CGRectMake(80, 60, self.view.frame.width, self.view.frame.height)
                        self.tableView.frame = frame
                    }, completion: nil)
            }else{
                UIView .animateWithDuration(0.5, delay: 0, options: (UIViewAnimationOptions.BeginFromCurrentState | UIViewAnimationOptions.CurveEaseIn), animations: {
                    var frame = CGRectMake(0, 60, self.view.frame.width, self.view.frame.height)
                    self.tableView.frame = frame
                    }, completion: nil)
            }
            println("ended")
        }

        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("twitterCell") as TweetCellViewCell
        cell.cellContent.text = self.tweets?[indexPath.row].text as String!
        cell.screenName.text = "@\(self.tweets?[indexPath.row].user?.screenname as String!)"
        cell.setImage(self.tweets?[indexPath.row].user?.profileImageUrl as String!)
        cell.createdAtString.text = self.tweets?[indexPath.row].createdAtString as String!
        return cell
    }
    
 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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
