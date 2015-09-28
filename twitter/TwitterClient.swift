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
    
    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance =  TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }

}
