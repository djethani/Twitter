//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Dimple Jethani on 6/27/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tweets: [Tweet]!
    
    
    @IBOutlet weak var tweetsTableView: UITableView!
    let redimage = UIImage(named: "like-action-on.png")
    
    let client = TwitterClient.sharedInstance
    
    var mah_user: User?
    let retweetGrayImage = UIImage(named: "retweet-action.png")
    let retweetGreenImage = UIImage(named: "retweet-action-on.png")
    let grayimage = UIImage(named: "like-action.png");
    
    
    /*
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let indexPath = tweetsTableView?.indexPathForRowAtPoint(location)
        let cell = tweetsTableView?.cellForRowAtIndexPath(indexPath!)
        
       
        
    }

   */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let logo = UIImage(named: "Twitter_logo_white_32")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.tweetsTableView.dataSource = self
        self.tweetsTableView.delegate = self
      /*
        if( traitCollection.forceTouchCapability == .Available){
            
            registerForPreviewingWithDelegate(self, sourceView: view)
            
        }
 */
        let refreshControl = UIRefreshControl()
        
        refreshControlAction(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
        
    }
    
    func refreshControlAction(refreshControl:UIRefreshControl){
        
        client.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            self.tweetsTableView.reloadData()
            
            
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        refreshControl.endRefreshing()
        self.tweetsTableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return 20
        } else{
            return 0
        }
        
        
    }
    
    @IBAction func onLogoutAction(sender: UIButton) {
        client.logout()
    }
    @IBAction func retweet(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! tweetCell
        
        let indexPath = tweetsTableView.indexPathForCell(cell)
        
        let tweet = tweets[indexPath!.row]
        if sender.currentImage!!.isEqual(retweetGrayImage){
            sender.setImage(retweetGreenImage, forState: UIControlState.Normal)
          
            client.Retweet(tweet.ID, success: {() -> () in
                print("reloading")
                    //self.tweetsTableView.reloadData()
                }, failure: {() -> () in})
            
            
        } else{
            sender.setImage(retweetGrayImage, forState: UIControlState.Normal)
        }

    }
 
   
    @IBAction func favoriteUpdateButton(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! tweetCell
        
        let indexPath = tweetsTableView.indexPathForCell(cell)
       
        let tweet = tweets[indexPath!.row]
        
        
        if sender.currentImage!!.isEqual(grayimage){
            sender.setImage(redimage, forState: UIControlState.Normal)
           
            print(tweet.ID)
            client.Likes(tweet.ID, success: {() -> () in
               
                //self.tweetsTableView.reloadData()
                }, failure: {() -> () in})
            

        } else{
            sender.setImage(grayimage, forState: UIControlState.Normal)
        }
        
    }
   
    @IBAction func onProfilePicture(sender: UIButton) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! tweetCell
        
        let indexPath = tweetsTableView.indexPathForCell(cell)
        
        let tweet = tweets[indexPath!.row]

        client.findUser(tweet.username_wout_a, success: { user in
            self.mah_user = user
            self.performSegueWithIdentifier("pictureToProfile", sender: nil)
            }, failure: { error in
                print(error.localizedDescription)
        })
        
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tweetsTableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! tweetCell
        let row = indexPath.row
       
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

        cell.tweet = self.tweets[row]
       
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject?) {
        
        if segue.identifier == "toDetailsView"{
            let indexPath = tweetsTableView.indexPathForCell(sender as! UITableViewCell)
            let row = indexPath!.row
            let CellDetails = segue.destinationViewController as! tweetDetailsView
            let tweet = self.tweets[row]
            print("NAMMMEEEEEE",tweet.name)
            CellDetails.nameText = tweet.name
            CellDetails.usernameText = tweet.screenName
            CellDetails.tweetText = tweet.text
            CellDetails.prof_pic_str = tweet.prof_pic_url
            CellDetails.id = tweet.ID
            CellDetails.rCount = tweet.retweetCount
            CellDetails.hCount = tweet.favoritesCount
            CellDetails.tweet=tweet
        }
        
        if segue.identifier == "pictureToProfile"{
            let profileVC = segue.destinationViewController as! profileViewController
            profileVC.user_screenname = mah_user!.screenname! as String
            profileVC.name = mah_user!.name as! String
            profileVC.num_followers = mah_user!.followers
            profileVC.num_following = mah_user!.following
            profileVC.profURL = mah_user!.profileURL
            profileVC.bio = mah_user!.tagline as! String
            profileVC.coverPicURL = mah_user!.coverURL
            
        }
        
        
        
        
    }

}

