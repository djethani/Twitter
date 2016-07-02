//
//  Tweet.swift
//  Twitter
//
//  Created by Dimple Jethani on 6/27/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var name: String!
    var screenName: String!
    var ID: Int
    var favorited:Bool
    var retweeted: Bool
    var prof_pic_url: String?
    var username_wout_a:String
    //var media_url: String?
    
    init(dictionary: NSDictionary) {
       
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        ID = (dictionary["id"] as? Int)!
        let user = dictionary["user"]
        name = user?["name"] as? String
       
        username_wout_a = (user?["screen_name"] as? String)!
        let homeUsername = "@" + username_wout_a
        screenName = homeUsername
        favorited = (dictionary["favorited"] as? Bool)!
        retweeted = (dictionary["retweeted"] as? Bool)!
        let timestampString = dictionary["created_at"] as? String
        let profileUrlString = (user?["profile_image_url"] as? String)!
        prof_pic_url = profileUrlString.stringByReplacingOccurrencesOfString("_normal", withString: "")
       
//        if let media = dictionary["media"]{
//            media_url = media["media_url"]
//        }
      
       
        
        if let timestampString = timestampString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
