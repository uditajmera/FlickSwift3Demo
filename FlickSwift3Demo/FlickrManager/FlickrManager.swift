//
//  FlickrManager.swift
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

class FlickrManager: NSObject {


    public enum httpMethodType:Int {
        
        case httpMethodGet = 0
        case httpMethodPost = 1
        
    }

    //---------------------------------------------------
    // MARK: -  FilePrivate variables
    //---------------------------------------------------
    
    private(set) var oauthswift: OAuth1Swift?
    private(set) var strApiKey:String = ""
    private(set) var strSecret:String = ""
    private(set) public var strAuthToken:String = ""
    private(set) public var strAuthSecret:String = ""
    private(set) public var bAuthorized:Bool = false
    private(set) public var strUserName:String = ""
    private(set) public var strUserId:String = ""

    //---------------------------------------------------
    // MARK: -  Singleton declaration
    //---------------------------------------------------
    
    static let sharedInstance: FlickrManager = {
        let instance = FlickrManager()
        // setup code
        return instance
    }()
    
    //---------------------------------------------------
    // MARK: -  Setter methods
    //---------------------------------------------------
    
    public func setAuthSwift(loauthSwift:OAuth1Swift)
    {
        self.oauthswift = loauthSwift
    }
    
    
    public func setAuthParameters(ldictParams:NSDictionary)
    {
        self.strAuthToken = ldictParams.object(forKey: "oauth_token") as! String
        self.strAuthSecret = ldictParams.object(forKey: "oauth_token_secret") as! String
        self.strUserName = ldictParams.object(forKey: "username") as! String
        self.strUserId = ldictParams.object(forKey: "user_nsid") as! String

    }
    
    
    
    
    public func initialize(withAPIKey lstrApiKey:String, lstrSecret:String)
    {
        self.strApiKey = lstrApiKey
        self.strSecret = lstrSecret
    }
    
    
    func photoURL(for size: String, fromPhotoDictionary photoDict: NSDictionary) -> URL {
        //Find possible photoID
        var photoID =  (photoDict.value(forKey: "id") as! String)
        if photoID == "" {
            photoID = (photoDict.value(forKey: "primary") as! String)
            //sets return this
        }
        //Find possible server
        let server = (photoDict.value(forKey: "server") as! String)
        //Find possible farm
        let farm:String = String(describing: (photoDict.value(forKey: "farm") as! NSNumber))

        let secret = (photoDict.value(forKey: "secret") as! String)
        
        return self.photoURL(for: size, photoID: photoID, server: server, secret: secret, farm: farm)
    }
    
    func photoURL(for size: String,
                  photoID: String,
                  server: String,
                  secret: String,
                  farm: String) -> URL
    {
        // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
        // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
        let photoSource = "https://static.flickr.com/"
        var URLString = String("https://")
        if farm.characters.count > 0 {
            URLString?.append("farm\(farm).")
        }
       
        URLString?.append(photoSource.substring(from: photoSource.index(photoSource.startIndex, offsetBy: 8)))
        URLString?.append("\(server)/\(photoID)_\(secret)")
        URLString?.append("_\(size).jpg")
        return URL(string: URLString!)!
    }
    
    open func photoArray(fromResponse response: NSDictionary) -> NSArray
    {
        let ldictPhotos:NSDictionary = response.object(forKey: "photos") as! NSDictionary
        let larrayPhotosInfo:NSArray = ldictPhotos.object(forKey: "photo") as! NSArray
        print(larrayPhotosInfo)
        return larrayPhotosInfo
    }
    
    
    
}
//---------------------------------------------------
// MARK: -  END
//---------------------------------------------------
