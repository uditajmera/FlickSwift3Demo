//
//  ViewController.swift
//  FlickSwift3Demo
//
//  Created by Udit Ajmera on 12/10/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//
//---------------------------------------------------
// MARK: -  SDK imports
//---------------------------------------------------

import UIKit
import OAuthSwift

class ViewController: OAuthViewController {
    
    lazy var internalWebViewController: WebViewController = {
        let controller = WebViewController()
        #if os(OSX)
            controller.view = NSView(frame: NSRect(x:0, y:0, width: 450, height: 500)) // needed if no nib or not loaded from storyboard
        #elseif os(iOS)
            controller.view = UIView(frame: UIScreen.main.bounds) // needed if no nib or not loaded from storyboard
        #endif
        controller.delegate = self
        controller.viewDidLoad() // allow WebViewController to use this ViewController as parent to be presented
        return controller
    }()
    
    //---------------------------------------------------
    // MARK: -  Default Methods
    //---------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        
        if internalWebViewController.parent == nil {
            self.addChildViewController(internalWebViewController)
        }
        return internalWebViewController
    }
    
    
    func doOAuthFlickr(){
        let oauthswift = OAuth1Swift(
            consumerKey:    FlickrManager.sharedInstance.strApiKey,
            consumerSecret: FlickrManager.sharedInstance.strSecret,
            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
        )
        
        
        oauthswift.authorizeURLHandler = getURLHandler()
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/flickr")!,
            success: { credential, response, parameters in
                
                DispatchQueue.main.async {
                    
                    FlickrManager.sharedInstance.setAuthSwift(loauthSwift: oauthswift)
                    
                    FlickrManager.sharedInstance.setAuthParameters(ldictParams: parameters as NSDictionary)
                    
                    self.performSegue(withIdentifier: "SegueToPhotosTabBar",
                                      sender: self)
                    
                }
                
            },
            failure: { error in
                print(error.description)
            }
        )
    }
    
    
    //---------------------------------------------------
    // MARK: -  Button Action
    //---------------------------------------------------
    
    @IBAction func flickrButtonPressed(_ sender: AnyObject) {
        
        doOAuthFlickr()
    }
    
}
//---------------------------------------------------
// MARK: -  END
//---------------------------------------------------

extension ViewController: OAuthWebViewControllerDelegate {
    #if os(iOS) || os(tvOS)
    
    func oauthWebViewControllerDidPresent() {
        
    }
    func oauthWebViewControllerDidDismiss() {
        
    }
    #endif
    
    func oauthWebViewControllerWillAppear() {
        
    }
    func oauthWebViewControllerDidAppear() {
        
    }
    func oauthWebViewControllerWillDisappear() {
        
    }
    func oauthWebViewControllerDidDisappear() {
        // Ensure all listeners are removed if presented web view close
        FlickrManager.sharedInstance.oauthswift?.cancel()
    }
}
