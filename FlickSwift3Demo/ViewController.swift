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
    // oauth swift object (retain)
    var oauthswift: OAuth1Swift?

    let services = Services()

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
    
    func showAlertView(title: String, message: String) {
        #if os(iOS)
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        #elseif os(OSX)
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.addButton(withTitle: "Close")
            alert.runModal()
        #endif
    }
    
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauthToken)"
        if !credential.oauthTokenSecret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauthTokenSecret)"
        }
        self.showAlertView(title: name ?? "Service", message: message)
        
        if let service = name {
            services.updateService(service, dico: ["authentified":"1"])
            // TODO refresh graphic
        }
    }

    
    func doOAuthFlickr(){
        let oauthswift = OAuth1Swift(
            consumerKey:    FlickrManager.sharedInstance.strApiKey,
            consumerSecret: FlickrManager.sharedInstance.strSecret,
            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
        )
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = getURLHandler()
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/flickr")!,
            success: { credential, response, parameters in
                print(parameters)
                self.showTokenAlert(name: "Flickr", credential: credential)
                self.testFlickr(oauthswift, consumerKey: FlickrManager.sharedInstance.strApiKey)
            },
            failure: { error in
                print(error.description)
            }
        )
    }
    
    
    func testFlickr (_ oauthswift: OAuth1Swift, consumerKey: String) {
        let url :String = "https://api.flickr.com/services/rest/"
        let parameters :Dictionary = [
            "method"         : "flickr.photos.search",
            "api_key"        : consumerKey,
            "user_id"        : "145498422@N04",
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_q,url_z"
        ]
        let _ = oauthswift.client.get(
            url, parameters: parameters,
            success: { response in
                let jsonDict = try? response.jsonObject()
               let photoArray = FlickrManager.sharedInstance.photoArray(fromResponse: jsonDict as! [String : Any] as NSDictionary)
                
                for photoDictionary in photoArray {
                    let photoURL = FlickrManager.sharedInstance.photoURL(for: "m", fromPhotoDictionary: photoDictionary as! NSDictionary)
                    print(photoURL)
                   // self.photoURLs.append(photoURL)
                }

                print(jsonDict as Any)
            },
            failure: { error in
                print(error)
            }
        )
    }
    
    //---------------------------------------------------
    // MARK: -  Button Action
    //---------------------------------------------------
    
    @IBAction func flickrButtonPressed(_ sender: AnyObject) {
        
        doOAuthFlickr()
//        if(FlickrManager.sharedInstance.bAuthorized)
//        {
////            FlickrKit.shared().logout()
////            self.userLoggedOut()
//        } else
//        {
//            self.performSegue(withIdentifier: "SegueToAuth", sender: self)
//        }
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
        oauthswift?.cancel()
    }
}
