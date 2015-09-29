//
//  TwitterClient.swift
//  twitter
//
//  Created by Vijayalakshmi Subramanian on 9/28/15.
//  Copyright © 2015 Viji Subramanian. All rights reserved.
//

import UIKit

let twitterConsumerKey = "9SKDZ2oc4K932CauXwVy1bMqh"
let twitterConsumerSecret = "f4k8sIPK9Bwqd0wCFTA5R3umGpnoOefhuUotVQ9fFlubxBuQBd"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion : ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance =  TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("Got the request Token")
            
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user:nil, error : error)
        }
        
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            print("Got access Token!")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters:nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                print(response);
                var user = User(dictionary: response as! NSDictionary)
                self.loginCompletion?(user:user, error : nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    print("Error getting user credentials")
                    self.loginCompletion?(user:nil, error : error)
            })
            
            TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                for tweet in tweets {
                    print("text : \(tweet.text)")
                }
                
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    print("Failed to get user timeline")
            })
            
            
            }) { (error: NSError!) -> Void in
                print("Failed to receive access Token");
        }

    }

}
