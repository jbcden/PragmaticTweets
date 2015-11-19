//
//  UserImageDetailViewController.swift
//  PragmaticTweets
//
//  Created by Jacob Chae on 11/18/15.
//  Copyright © 2015 Jooper. All rights reserved.
//

import UIKit

class UserImageDetailViewController: UIViewController {
    var userImageURL: NSURL?
    var preGestureTransform: CGAffineTransform?
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        if sender.state == .Began {
            preGestureTransform = userImageView.transform
        }
        if sender.state == .Began ||
            sender.state == .Changed {
                let scaledTransform = CGAffineTransformScale(preGestureTransform!,
                    sender.scale,
                    sender.scale)
                userImageView.transform = scaledTransform
        }
    }
    
    @IBAction func handleDoubleTapGesture(sender: UITapGestureRecognizer) {
        userImageView.transform = CGAffineTransformIdentity
    }
    
    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            preGestureTransform = userImageView.transform
        }
        
        if sender.state == .Began ||
            sender.state == .Changed {
                let translation = sender.translationInView(userImageView)
                let translatedTransform = CGAffineTransformTranslate(preGestureTransform!,
                    translation.x,
                    translation.y)
                userImageView.transform = translatedTransform
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let userImageURL = userImageURL,
            imageData = NSData(contentsOfURL: userImageURL) {
                userImageView.image = UIImage(data: imageData)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
