//
//  TweetCell.swift
//  Twitter
//
//  Created by Pat Boonyarittipong on 4/27/15.
//  Copyright (c) 2015 patboony. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweetID: String?
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func retweetAction(sender: AnyObject) {
    }
    
    
    @IBAction func replyAction(sender: AnyObject) {
    }
    
    
    @IBAction func favoriteAction(sender: AnyObject) {
    
        
        TwitterClient.sharedInstance.favoriteStatusWithParams(["id":tweetID!] as NSDictionary) {
            (error: NSError?) in
            if error == nil {
                // change text color
                self.favoriteButton.titleLabel!.textColor = UIColor(white: 0.4, alpha: 1.0)
            } else {
                // alert error
            }
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.width
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.width
        screennameLabel.preferredMaxLayoutWidth = screennameLabel.frame.width
    }

}
