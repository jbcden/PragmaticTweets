//
//  KeyboardViewController.swift
//  PragmaticTweetsKeyboard
//
//  Created by Jacob Chae on 11/19/15.
//  Copyright © 2015 Jooper. All rights reserved.
//

import UIKit
import PragmaticTweetsFramework

class KeyboardViewController: UIInputViewController,
    UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var nextKeyboardBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var nextKeyboardButton: UIButton!
    
    var tweetNames: [String] = []
    
    @IBAction func nextKeyboardBarButtonTapped(sender: UIBarButtonItem) {
        advanceToNextInputMode()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetNames.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let atName = "@\(tweetNames[indexPath.row])"
        textDocumentProxy.insertText(atName)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell")
            as UITableViewCell!
        cell.textLabel?.text = "@\(tweetNames[indexPath.row])"
        return cell
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let twitterParams = ["count": "100"]
        guard let twitterAPIURL = NSURL(string:
            "https://api.twitter.com/1.1/friends/list.json") else {
            return
        }
        sendTwitterRequest(twitterAPIURL,
            params: twitterParams,
            completion: { (data, urlResponse, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                })
            })
    
        // Perform custom UI setup here
//        self.nextKeyboardButton = UIButton(type: .System)
//    
//        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
//        self.nextKeyboardButton.sizeToFit()
//        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
//    
//        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
//        
//        self.view.addSubview(self.nextKeyboardButton)
//    
//        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
//        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
//        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
    }
    
    func handleTwitterData (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog ("handleTwitterData() received no data")
            return
        }
        NSLog ("handleTwitterData(), \(data.length) bytes")
        do {
        let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
        guard let jsonDict = jsonObject as? [String : AnyObject],
                usersArray = jsonDict ["users"] as? [ [String : AnyObject] ] else {
                NSLog ("handleTwitterData() can't parse data")
                return
        }
        
        tweetNames.removeAll()
        for userDict in usersArray {
                    if let tweetName = userDict["screen_name"] as? String {
                    tweetNames.append(tweetName)
                    }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    } catch let error as NSError {
                        NSLog ("JSON error: \(error)")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
//        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
