//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Pat Boonyarittipong on 4/27/15.
//  Copyright (c) 2015 patboony. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var currentTweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cTweet = currentTweet {
            tweetTextLabel.text = cTweet.text!
            nameLabel.text = cTweet.user!.name!
            screennameLabel.text = "@" + cTweet.user!.screenname!
            timeStampLabel.text = calculateTimePassedSinceTimestamp(cTweet.createdAt)
            if let profileImageURL = cTweet.user!.profileImageUrl {
                profileImageView.setImageWithURL(NSURL(string: profileImageURL))
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateTimePassedSinceTimestamp(createdAt: NSDate?) -> String {
        
        let diffInSeconds = NSDate().timeIntervalSinceReferenceDate - createdAt!.timeIntervalSinceReferenceDate
        
        if(diffInSeconds >= 3600){
            let hourPassed: Double = floor(diffInSeconds/3600)
            return String(format:"%.0f", hourPassed) + "h"
        } else {
            let minPassed = max(floor(diffInSeconds/60), 1)
            return String(format:"%.0f", minPassed) + "m"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
