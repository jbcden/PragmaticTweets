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

class RootViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        let refresher = UIRefreshControl()
        refresher.addTarget(self,
            action: "handleRefresh:",
            forControlEvents: .ValueChanged)
        refreshControl = refresher
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func handleRefresh(sender: AnyObject?) {
        reloadTweets()
        refreshControl?.endRefreshing()
    }
    
    func reloadTweets() {
        let twitterParams = ["count": "100"]
        guard let twitterAPIURL = NSURL(string:
            "https://api.twitter.com/1.1/statuses/home_timeline.json") else {
                return
        }
        sendTwitterRequest(twitterAPIURL,
            params: twitterParams,
            completion: { (data, urlResponse, error) -> Void in
            self.handleTwitterData(data, urlResponse: urlResponse, error: error)
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
        cell.avatarImageView.image = nil
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) {
        if let url = parsedTweet.userAvatarUrl,
            imageData = NSData(contentsOfURL: url)
            where cell.userNameLabel.text == parsedTweet.userName {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.avatarImageView.image = UIImage(data: imageData)
                })
            }
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
                guard let jsonArray = jsonObject as? [[String: AnyObject]] else {
                    NSLog("handleTwitterData() didn't get an array")
                    return
                }
                parsedTweets.removeAll()
                for tweetDict in jsonArray {
                    var parsedTweet = ParsedTweet()
                    parsedTweet.tweetText = tweetDict["text"] as? String
                    parsedTweet.createdAt = tweetDict["created_at"] as? String
                    if let userDict = tweetDict["user"] as? [String: AnyObject] {
                        parsedTweet.userName = userDict["name"] as? String
                        if let avatarString = userDict["profile_image_url"] as? String {
                             parsedTweet.userAvatarUrl = NSURL(string: avatarString)
                        }
                    }
                    parsedTweets.append(parsedTweet)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            } catch let error as NSError {
                NSLog("JSON error: \(error)")
            }
    }
    
}

