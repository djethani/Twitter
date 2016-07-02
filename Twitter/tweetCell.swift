//
//  tweetCell.swift
//  Twitter
//
//  Created by Dimple Jethani on 6/27/16.
//  Copyright © 2016 Dimple Jethani. All rights reserved.
//

import UIKit

class tweetCell: UITableViewCell {

    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var profilePictura: UIImageView!
    
    @IBOutlet weak var hCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var tweetText: UILabel!
   
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
    var tweet: Tweet! {
        didSet{
            tweetText.text = String(tweet.text!)
            retweetCount.text = String(tweet.retweetCount)
            hCount.text = String(tweet.favoritesCount)
            username.text = String(tweet.screenName)
            name.text = String(tweet.name)
            timeStamp.text = AgoStringFromTime(tweet.timestamp!)
            
            if let url = NSURL(string: tweet.prof_pic_url!){
                print("URL PASSED")
                if let data = try? NSData(contentsOfURL: url, options: []){
                 
                    profilePictura.image = UIImage(data: data)
                }
            }
        }
    }
    
    func AgoStringFromTime(dateTime: NSDate) -> String {
        var timeScale: [NSObject : AnyObject] = ["sec": 1, "min": 60, "hr": 3600, "day": 86400, "week": 605800, "month": 2629743, "year": 31556926]
        var scale: String
        var timeAgo: Int = 0 - Int(dateTime.timeIntervalSinceNow)
        if timeAgo < 60 {
            scale = "sec"
        }
        else if timeAgo < 3600 {
            scale = "min"
        }
        else if timeAgo < 86400 {
            scale = "hr"
        }
        else if timeAgo < 605800 {
            scale = "day"
        }
        else if timeAgo < 2629743 {
            scale = "week"
        }
        else if timeAgo < 31556926 {
            scale = "month"
        }
        else {
            scale = "year"
        }
        
        timeAgo = timeAgo / (timeScale[scale] as? Int)!
        var s: String = ""
        if timeAgo > 1 {
            s = "s"
        }
        return "\(timeAgo) \(scale)\(s)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
