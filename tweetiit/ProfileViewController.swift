//
//  ProfileViewController.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 10/4/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var fullName: UILabel!
    var backgroundImage: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    var user: User?
    var headerView  = UIImageView(frame: CGRect(x:0, y:0, width:320, height:30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.user ==  nil){
            self.user = User.currentUser
        }
        tableView.delegate = self
        tableView.dataSource = self
    
        screenName.text = "@\(self.user?.screenname as String!)"
        fullName.text = self.user?.name as String!
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = self.user?.name as String!
       // self.profileImage.setImageWithURL(NSURL(string: self.user?.profileImageUrl as String!))
        if(self.user?.profileBannerUrl != nil){
  //          self.backgroundImage.setImageWithURL(NSURL(string: self.user?.profileBannerUrl as String!))
        }
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "loadTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        self.loadTweets()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTweets(){
        var params = ["screen_name": user?.screenname]
        let user_id = self.user?.screenname as String!
        println("\(user_id)")
        TwitterClient.sharedInstance.userTimelineWithParameters(user_id, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            var cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as UserCell
            
            cell.Mentions.text = "Statuses: \(self.user?.statusCount as Int!)  Followers: \(self.user?.followersCount as Int!)  Following: \(self.user?.followingCount as Int!)"
        
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("twitterCell") as TweetCellViewCell
            cell.cellContent.text = self.tweets?[indexPath.row - 1].text as String!
            cell.screenName.text = "@\(self.tweets?[indexPath.row - 1].user?.screenname as String!)"
            cell.setImage(self.tweets?[indexPath.row - 1].user?.profileImageUrl as String!)
            cell.createdAtString.text = self.tweets?[indexPath.row - 1].createdAtString as String!
            cell.preservesSuperviewLayoutMargins = false
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            if(self.tweets != nil){
                return self.tweets!.count + 1
            }
        
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        headerView.backgroundColor = UIColor.lightGrayColor()
        
        headerView.setImageWithURL(NSURL(string: self.user?.profileBannerUrl as String!))
        return headerView
   }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 99
        }
        return 113
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scrolled")
        var y = -scrollView.contentOffset.y;
        var cachedImageViewSize = headerView.frame
        if (y > 0) {
            self.headerView.frame = CGRectMake(0, scrollView.contentOffset.y, cachedImageViewSize.size.width+y, cachedImageViewSize.size.height+y);
            self.headerView.center = CGPointMake(self.view.center.x, self.headerView.center.y);
        
        }
        
        
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
