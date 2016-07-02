//
//  User.swift
//  Twitter
//
//  Created by Dimple Jethani on 6/27/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit
class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileURL: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var coverURL: NSURL?
    var followers: Int = 0
    var following: Int = 0
    var ID: Int?
    
    init(dictionary:NSDictionary) {
        
       
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileURLString = dictionary["profile_image_url_https"] as? String
        
        let modifiedProfileUrlString = profileURLString!.stringByReplacingOccurrencesOfString("_normal", withString: "") as? String
        if let modprofileURLString = modifiedProfileUrlString {
            profileURL = NSURL(string: modprofileURLString)
        }
        tagline = dictionary["description"] as? String
        
        followers = (dictionary["followers_count"] as? Int) ?? 0
        following = (dictionary["friends_count"] as? Int) ?? 0
        ID = dictionary["_id"] as? Int
        let profileCoverURLString = dictionary["profile_banner_url"] as? String
        
      
        
        if let profileCoverURLString = profileCoverURLString{
            coverURL = NSURL(string: profileCoverURLString)
            print("COVERURLLLLL",coverURL)
        }
        
       
        
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                    if let userData = userData{
                        let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                
                    }
                
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            }
            else{
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
