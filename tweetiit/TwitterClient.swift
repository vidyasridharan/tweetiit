//
//  TwitterClient.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 9/26/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit


let twitterConsumerKey =  "WTQyBVEjHgkgvJAchXzN7L4TA"
let twitterConsumerSecret = "NK4pIuuvIEpVBJzxFer3DrEPz7LY8Ge7eI47cQBxYLvzRv0hSI"
let twitterUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?)->())?
    
    class var sharedInstance: TwitterClient {
    struct Static{
            static let instance = TwitterClient(baseURL: twitterUrl, consumerKey: twitterConsumerKey , consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParameters(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?)->()){
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!)-> Void in
            //println("home timeline\(response)")
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            println("got tweets\(tweets[0].user?.name)")
            completion(tweets: tweets, error:nil)
            
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!)-> Void in
                println("error getting home timeline")
                completion(tweets: nil, error:error)
                
        })

        
    }
    
    func updatewithStatus(test: String, tweetid: String, completion: (tweets: [Tweet]?, error: NSError?)->()){
        var params = ["status": test]
       
        if(tweetid != "compose"){
            params = ["status": test, "in_reply_to_status_id": tweetid]
        }
        
        POST("1.1/statuses/update.json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!)-> Void in
            //println("post response\(response)")
            //var tweets = response as [NSDictionary]
            
           // completion(tweets: tweets, error:nil)
            
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!)-> Void in
                println("error posting\(error)")
                //completion(tweets: nil, error:error)
                
        })
        
        
    }
    
    func retweetWithId(tweetid: String, completion: (tweets: [Tweet]?, error: NSError?)->()){
        var tweetid = tweetid
        POST("1.1/statuses/retweet/\(tweetid).json", parameters: nil, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!)-> Void in
            println("post response\(response)")
            //var tweets = response as [NSDictionary]
            
            // completion(tweets: tweets, error:nil)
            
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!)-> Void in
                println("error posting\(error)")
                //completion(tweets: nil, error:error)
                
        })
        
    }
    
    func favoriteWithId(tweetid: String, completion: (tweets: [Tweet]?, error: NSError?)->()){
        
        var params = ["id": tweetid]
        POST("1.1/favorites/create.json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!)-> Void in
            println("post response\(response)")
            //var tweets = response as [NSDictionary]
            
            // completion(tweets: tweets, error:nil)
            
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!)-> Void in
                println("error posting\(error)")
                //completion(tweets: nil, error:error)
                
        })
        
    }
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        //Fetch request token and redirect to authorization 
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: {(requestToken: BDBOAuthToken!) -> Void in
            println("Got the request token")
            var authURL=NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            
            }){(error: NSError!) -> Void in
                println("Failed to get response")
                self.loginCompletion?(user:nil, error:error)
                println(error)
        }
    
    }
    
    
    func openURL(url:NSURL){
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken (queryString: url.query), success: {(accessToken: BDBOAuthToken! ) -> Void in
            println("Got access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!)-> Void in
                
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                println("user:\(user.name)")
                self.loginCompletion?(user:user, error:nil)
            
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!)-> Void in
            println("error getting user")
            self.loginCompletion?(user:nil, error: error)
                    
            })
            
            
            
            }, failure: {(error: NSError!) -> Void in
                println("Failure to receive access token")
                self.loginCompletion?(user:nil, error: error)
                
        })

    
    }
   
}
