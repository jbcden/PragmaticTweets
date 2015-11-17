//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Jacob Chae on 11/15/15.
//  Copyright © 2015 Jooper. All rights reserved.
//

import UIKit
import Accounts
import Social


let defaultAvatarUrl = NSURL(string:
    "https://abs.twimg.com/sticky/default_profile_images/default_profile_0_200x200.png")

class ViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = [
        ParsedTweet(tweetText: "iOS 9 SDK Development now in print!",
            userName: "@pragprog",
            createdAt: "2015-09-09 15:44:30 EDT",
            userAvatarUrl: defaultAvatarUrl),
        ParsedTweet(tweetText: "But was that really such a good idea?",
            userName: "@redqueencoder",
            createdAt: "2014-09-09 15:44:30 EDT",
            userAvatarUrl: defaultAvatarUrl),
        ParsedTweet(tweetText: "Struct all the things!",
            userName: "@invalidname",
            createdAt: "2015-07-31 05:39:39 EDT",
            userAvatarUrl: defaultAvatarUrl)
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        let refresher = UIRefreshControl()
        refresher.addTarget(self,
            action: "handleRefresh",
            forControlEvents: .ValueChanged)
        refreshControl = refresher
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func handleRefresh(sender: AnyObject?) {
        parsedTweets.append(
            ParsedTweet(tweetText: "New Row",
                userName: "@refresh",
                createdAt: NSDate().description,
                userAvatarUrl: defaultAvatarUrl)
        )
        reloadTweets()
        refreshControl?.endRefreshing()
    }
    
    func reloadTweets() {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil,
            completion: {
                (granted: Bool, error: NSError!) -> Void in
                guard granted else {
                    NSLog("Account access not granted")
                    return
                }
                let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                guard twitterAccounts.count > 0 else {
                    NSLog("no twitter accounts configured")
                    return
                }
                let twitterParams = [
                    "count": "100"
                ]
                let twitterAPIUrl = NSURL(string:
                    "https://api.twitter.com/1.1/statuses/home_timeline.json")
                let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                    requestMethod: .GET,
                    URL: twitterAPIUrl,
                    parameters: twitterParams)
                request.account = twitterAccounts.first as! ACAccount
                request.performRequestWithHandler({
                    (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                    self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                })
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =
        tableView.dequeueReusableCellWithIdentifier("CustomTweetCell")
            as! ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        if let url = parsedTweet.userAvatarUrl,
            imageData = NSData(contentsOfURL: url) {
                cell.avatarImageView.image = UIImage(data: imageData)
        }
        return cell
    }
    
    private func handleTwitterData(data: NSData!,
        urlResponse: NSHTTPURLResponse!,
        error: NSError!) {
            guard let data = data else {
                NSLog("handleTwitterData() got nothin'")
                return
            }
                NSLog("handleTwitterData() received, \(data.length) bytes!")
            do {
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions([]))
                NSLog("json is \(jsonObject)")
            } catch let error as NSError {
                NSLog("JSON error: \(error)")
            }
    }
    
}

