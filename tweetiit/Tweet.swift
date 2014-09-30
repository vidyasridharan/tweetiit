//
//  Tweet.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 9/27/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit
var _currentTweet: Tweet?
let  currentTweetKey = "kCurrenttweetKey"
class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favorited: Int?
    var retweeted: Int?
    var id_str: String?
    
    init (dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favorited = dictionary["favorited"] as? Int
        id_str = dictionary ["id_str"] as? String
        retweeted = dictionary["retweeted"] as? Int
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary])->[Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    class func tweetAtIndex(tweets: [Tweet], index: NSInteger) -> Tweet{
        
        return tweets[index]
    }
//    
//    class var currentTweet: Tweet? {
//        get{
//            _currentTweet = Tweet(tweet as? Dictionary)
//        if _currentTweet == nil{
////        var data = NSUserDefaults.standardUserDefaults().objectForKey(currentTweetKey) as? NSData
////        
////        if data != nil{
////        var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
////        _currentTweet = Tweet(dictionary: dictionary)
////        }
////        }
//        
//        }
//            return _currentTweet
//        }
//        
//    }

    
    
   
}
