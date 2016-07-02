//
//  tweetDetailsView.swift
//  Twitter
//
//  Created by Dimple Jethani on 6/29/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit

class tweetDetailsView: UIViewController {

    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
     let redimage = UIImage(named: "like-action-on.png")
    let retweetGrayImage = UIImage(named: "retweet-action.png")
    let retweetGreenImage = UIImage(named: "retweet-action-on.png")
    let grayimage = UIImage(named: "like-action.png");

    let client = TwitterClient.sharedInstance
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var tweetLabelText: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favCount: UILabel!
    
    @IBOutlet weak var tweetReplyTextField: UITextField!
    
    var nameText: String?
    var usernameText: String?
    var tweetText: String?
    var prof_pic_str: String?
    var id: Int?
    var rCount: Int?
    var hCount: Int?
    
    var tweet:Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = nameText
        username.text = usernameText
        tweetLabelText.text = tweetText
        retweetCount.text = String(tweet!.retweetCount)
        favCount.text = String(tweet!.favoritesCount)
        
        
        if let url = NSURL(string: prof_pic_str!){
          
            if let data = try? NSData(contentsOfURL: url, options: []){
                self.userProfilePicture.image = UIImage(data: data)
            }
        }
        if tweet!.favorited {
            favButton.setImage(redimage, forState: UIControlState.Normal)
        } else{
            favButton.setImage(grayimage, forState: UIControlState.Normal)
        }
        
        
        if tweet!.retweeted {
            retweetButton.setImage(retweetGreenImage, forState: UIControlState.Normal)
        } else{
            retweetButton.setImage(retweetGrayImage, forState: UIControlState.Normal)
        }
        
        
    }
    
    @IBAction func onReply(sender: UIButton) {
        let response_text = tweetReplyTextField.text
        let status = username.text! + " " + response_text!
        
        client.makeReply(status, postID: id!, success: {() -> () in
            print("reloading")
            //self.tweetsTableView.reloadData()
            }, failure: {() -> () in})

        
    }
}
