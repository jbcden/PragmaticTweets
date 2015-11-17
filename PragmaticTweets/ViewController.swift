//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Jacob Chae on 11/15/15.
//  Copyright © 2015 Jooper. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
    @IBOutlet weak var twitterWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText("I just finished the first project in iOS 9 SDK Development. #pragsios9")
            self.presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            NSLog("Can't send a tweet")
        }
    }
   
    @IBAction func handleShowMyTweetsTapped(sender: UIButton) {
        reloadTweets()
    }
    
    func reloadTweets() {
        if let url = NSURL(string: "https://twitter.com/jbcden") {
            let urlRequest = NSURLRequest(URL: url)
            twitterWebView.loadRequest(urlRequest)
        }
    }
    
}

