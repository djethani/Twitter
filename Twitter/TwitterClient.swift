//
//  TwitterClient.swift
//  Twitter
//
//  Created by Dimple Jethani on 6/27/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginSuccess: (()->())?
    var loginFailure: ((NSError) -> ())?
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "TNZa7vt88Dy3QmZx8KuOFQcpG", consumerSecret: "gpFlYH2eYJQ8yCKtdRdeF8pL4bPhWdVuyimlJGJbCN40hkBTFc")

    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    
    func findUser(screenName: String, success: (User) -> (), failure: (NSError) -> ()){
        GET("1.1/users/show.json?screen_name=\(screenName)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            let dictionary = response as! NSDictionary
            let myUser = User(dictionary: dictionary)
            success(myUser)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    func myFavoritesList(screenName: String, success: ([Tweet]) -> (), failure: (NSError) -> ()){
        GET("1.1/favorites/list.json?screen_name=\(screenName)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    func myTweetsTimeline(username: String, success: ([Tweet]) -> (), failure: (NSError) -> ()){
        GET("1.1/statuses/user_timeline.json?screen_name=\(username)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        

    }

    func Likes(id:Int,success: () -> (), failure: () -> ()){
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress:nil, success: { (task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError)-> Void in
                print("FAILLLL")
                print(error.localizedDescription)
                failure()
        
        })

    
    }
    
    func Retweet(id:Int,success: () -> (), failure: () -> ()){
        
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress:nil, success: { (task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            
                success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError)-> Void in
                print("FAILLLL")
                print(error.localizedDescription)
                failure()
                
        })
        
        
    }
   
    func makeTweet(status: String, success:() -> (), failure: () -> ()){
   
        let url2: String!
        url2 = status.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
       
        
        POST("1.1/statuses/update.json?status=\(url2)", parameters: nil, progress: nil, success: {
            (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("FAILFAIL")
                print(error.localizedDescription)
                failure()
        })
 
    }
    
    func makeReply(status: String, postID: Int, success:() -> (), failure: () -> ()){
        let url2: String!
        url2 = status.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        
        POST("1.1/statuses/update.json?status=\(url2)&in_reply_to_status_id=\(postID)", parameters: nil, progress: nil, success: {
            (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("FAILFAILFAILLLLL")
                print(error.localizedDescription)
                failure()
        })

        
        
    }
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                print("HERE")
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            self.loginSuccess?()
            
        }) { (error: NSError!)-> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
        
    }
    func logout(){
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    func login(success: ()-> (), failure: (NSError)->()){
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo123://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) in
            print("error:  \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            
            success(user)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError)-> Void in
                failure(error)
        })

    }
    
   
}
