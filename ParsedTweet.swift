//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Jacob Chae on 11/16/15.
//  Copyright © 2015 Jooper. All rights reserved.
//

import Foundation

public struct ParsedTweet {
    public var tweetText: String?
    public var userName: String?
    public var createdAt: String?
    public var tweetIdString: String?
    public var userAvatarUrl: NSURL?
    
    public init() {
    }
}