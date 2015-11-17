//
//  WebViewTests.swift
//  PragmaticTweets
//
//  Created by Jacob Chae on 11/15/15.
//  Copyright © 2015 Jooper. All rights reserved.
//

import XCTest
@testable import PragmaticTweets

class WebViewTests: XCTestCase, UIWebViewDelegate {
    var loadedWebViewExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAutomaticWebLoad() {
        guard let vc =
            UIApplication.sharedApplication().windows[0].rootViewController
                as? ViewController else {
                    XCTFail("Couldn't get root view controller")
                    return
        }
        vc.twitterWebView.delegate = self
        loadedWebViewExpectation = expectationWithDescription("web view auto-load test")
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        XCTFail("web view load failed")
        loadedWebViewExpectation?.fulfill()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let webViewContents =
            webView.stringByEvaluatingJavaScriptFromString(
                "document.documentElement.textContent")
            where webViewContents != "" {
                loadedWebViewExpectation?.fulfill()
        }
    }
}
