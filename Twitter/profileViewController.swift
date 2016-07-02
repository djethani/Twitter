//
//  profileViewController.swift
//  Twitter
//
//  Created by Dimple Jethani on 6/30/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit

class profileViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    let redimage = UIImage(named: "like-action-on.png")

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var myTweetsTableView: UITableView!
    let client = TwitterClient.sharedInstance
    
    
    let retweetGrayImage = UIImage(named: "retweet-action.png")
    let retweetGreenImage = UIImage(named: "retweet-action-on.png")
    let grayimage = UIImage(named: "like-action.png");

    var tweets: [Tweet]!
    
    @IBOutlet weak var coverPictureView: UIImageView!
    @IBOutlet weak var profPictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    var name:String?
    var user_screenname: String = ""
    var bio: String?
    var num_following:Int = 0
    var num_followers:Int = 0
    var profURL: NSURL?
    var coverPicURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTweetsTableView.dataSource=self
        myTweetsTableView.delegate=self
        
        if user_screenname == ""
        {
            user_screenname = (User.currentUser?.screenname as? String)!
            nameLabel.text = User.currentUser?.name as? String
            usernameLabel.text = User.currentUser?.screenname as? String
            
            bioLabel.text = User.currentUser?.tagline as? String
            followers.text = String(User.currentUser!.followers)
            following.text = String(User.currentUser!.following)
            
            let profpicurl = User.currentUser?.profileURL
            
            if let data = try? NSData(contentsOfURL: profpicurl!, options: []){
                
                profPictureView.image = UIImage(data: data)
            }
            if let coverpicurl = User.currentUser?.coverURL{
                
                if let data = try? NSData(contentsOfURL: coverpicurl, options: []){
                    
                    coverPictureView.image = UIImage(data: data)
                }
            }
            


        }
        else{
            nameLabel.text = name
            usernameLabel.text = user_screenname
            bioLabel.text = bio
            followers.text = String(num_followers)
            following.text = String(num_following)
            
            let profpicurl = profURL
            
            if let data = try? NSData(contentsOfURL: profpicurl!, options: []){
                
                profPictureView.image = UIImage(data: data)
            }
            if let coverpicurl = coverPicURL{
                
                if let data = try? NSData(contentsOfURL: coverpicurl, options: []){
                    
                    coverPictureView.image = UIImage(data: data)
                }
            }

        }
        
        client.myTweetsTimeline(user_screenname, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            self.myTweetsTableView.reloadData()
            
            
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
         let refreshControl = UIRefreshControl()
        
        //refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.endRefreshing()
       // tweetsTableView.insertSubview(refreshControl, atIndex: 0)
        

    }
    @IBAction func changeInControl(sender: UISegmentedControl) {
        if self.tweets != nil {
            self.tweets.removeAll()
        }
        switch segmentedControl.selectedSegmentIndex {
        
            
        case 0:
            print("CASE 0")
            myTweetsTableView.hidden = false
            break
        case 1:
            print("CASE 1")
        
            myTweetsTableView.hidden = true
            client.myTweetsTimeline(user_screenname, success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            
            
            
            break
        case 2:
           
            myTweetsTableView.hidden = false
            client.myFavoritesList(user_screenname, success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                
                self.myTweetsTableView.reloadData()
                
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            break
        default:
           // self.myTweetsTableView.hidden = false
            break
        }
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.tweets != nil {
            return self.tweets.count
        } else {
            return 0
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
            let cell = myTweetsTableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! tweetCell
            let row = indexPath.row
            cell.tweet = tweets[row]
            if tweets[row].favorited {
                cell.favButton.setImage(redimage, forState: UIControlState.Normal)
            } else{
                cell.favButton.setImage(grayimage, forState: UIControlState.Normal)
            }
            if tweets[row].retweeted {
                cell.retweetButton.setImage(retweetGreenImage, forState: UIControlState.Normal)
            } else{
                cell.retweetButton.setImage(retweetGrayImage, forState: UIControlState.Normal)
            }
            
            return cell
    }
    
    

    
    
}