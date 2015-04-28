//
//  TwitterClient.swift
//  Twitter
//
//  Created by Pat Boonyarittipong on 4/25/15.
//  Copyright (c) 2015 patboony. All rights reserved.
//

import UIKit

let twitterConsumerKey = "yiobmguQWl0lEILnd3DCQzTCi"
let twitterConsumerSecret = "Faz1x1dCrs2Yl8fJzPFHCxpmpcHwAbnnTx5GBAGCNaDtxuT5H2"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")!

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    // params - in case we want to do pagination
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Timeline:")
            println(response)
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting user's timeline")
                completion(tweets: nil, error: error)
                //self.loginCompletion?(user: nil, error: error)
        })
        
        
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "pattwitter://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            println("Got the token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(authURL)
            }, failure: { (error: NSError!) -> Void in
                println("Failed \(error.description)")
                self.loginCompletion?(user: nil, error: error)
        })
        
    }
    
    func openURL(url: NSURL){
        
        // Check if twitter
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got the access token!")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println(response)
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                println(user.name)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting user's credentials")
                //println(error.description)
                self.loginCompletion?(user: nil, error: error)
            })
            
            }) { (error:NSError!) -> Void in
            println("Did not receive the access token")
            self.loginCompletion?(user: nil, error: error)
        }
        
    }
   
}