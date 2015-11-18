//
//  TwitterAPIRequestUtilities.swift
//  PragmaticTweets
//
//  Created by Jacob Chae on 11/17/15.
//  Copyright © 2015 Jooper. All rights reserved.
//

import Foundation
import Accounts
import Social

func sendTwitterRequest(requestUrl: NSURL,
    params: [String: String],
    completion: SLRequestHandler) {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(twitterAccountType,
            options: nil,
            completion: {
                (granted: Bool, error: NSError!) -> Void in
                guard granted else {
                    NSLog("Account access not granted")
                    return
                }
                let twitterAccounts =
                    accountStore.accountsWithAccountType(twitterAccountType)
                guard twitterAccounts.count > 0 else {
                    NSLog("no twitter accounts configured")
                    return
                }
                let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                    requestMethod: .GET,
                    URL: requestUrl,
                    parameters: params)
                request.account = twitterAccounts.first as! ACAccount
                request.performRequestWithHandler(completion)
        })
}