//
//  User.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 9/27/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit

var _currentUser: User?
let  currentUserKey = "kCurrentuserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var profileBannerUrl: String?
    var dictionary: NSDictionary
    var statusCount: Int?
    var followersCount: Int?
    var  followingCount: Int?
    init (dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["tag_line"] as? String
        profileBannerUrl = dictionary["profile_banner_url"] as? String
        statusCount = dictionary["statuses_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
    
    }
    
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName("userDidLogoutNotification", object: nil)
    }
    
    class var currentUser: User? {
        get{
        if _currentUser == nil{
            var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        
            if data != nil{
                var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                _currentUser = User(dictionary: dictionary)
            }
        }
            return _currentUser
        }
        set(user){
            _currentUser = user
            
            if _currentUser != nil{
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                
            }else{
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
