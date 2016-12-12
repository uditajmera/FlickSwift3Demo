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

protocol FlickrManagerDelegate {
    
    func flickrPhotosURLResponse(larrayPhotoURLs:NSMutableArray)
}

class FlickrManager: NSObject {


    public enum httpMethodType:Int {
        
        case httpMethodGet = 0
        case httpMethodPost = 1
        
    }
    
    open var delegate:FlickrManagerDelegate?

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
        self.strUserId = self.strUserId.removingPercentEncoding!

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
    
    open func photoArray(fromResponse response: NSDictionary!) -> NSArray
    {
        print(response)
        let ldictPhotos:NSDictionary = response.object(forKey: "photos") as! NSDictionary
        let larrayPhotosInfo:NSArray = ldictPhotos.object(forKey: "photo") as! NSArray
        print(larrayPhotosInfo)
        return larrayPhotosInfo
    }
    
    public func userPhotosURLs(_ oauthswift: OAuth1Swift, consumerKey: String,
                               lintPageNumber:Int,
                               lintPageSize:Int)
    {
        let url :String = "https://api.flickr.com/services/rest/"
        let parameters :Dictionary = [
            "method"         : "flickr.photos.search",
            "api_key"        : consumerKey,
            "user_id"        : self.strUserId,
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_q,url_z",
            "per_page"       : "\(lintPageSize)",
            "page"           : "\(lintPageNumber)"
        ]
        
        
        let _ = oauthswift.client.get(
            url, parameters: parameters,
            success: { response in
                
              //  DispatchQueue.main.async {
                    
                    let larrayPhotosURL:NSMutableArray = NSMutableArray()

                    let jsonDict = try? response.jsonObject()
                    let photoArray = FlickrManager.sharedInstance.photoArray(fromResponse: jsonDict as! [String : Any] as NSDictionary)
                    
                    for photoDictionary in photoArray {
                        let photoURL = FlickrManager.sharedInstance.photoURL(for: "m", fromPhotoDictionary: photoDictionary as! NSDictionary)
                        print("check->\(photoURL)")
                        larrayPhotosURL.add(photoURL)
                    }
                    
                    self.delegate?.flickrPhotosURLResponse(larrayPhotoURLs: larrayPhotosURL)
                    
               // }
               
            },
            failure: { error in
                print(error)
            }
        )
    }
    
    
    public func uploadPhotosURLs(_ oauthswift: OAuth1Swift,
                                 consumerKey: String,
                                 lobjImageToUpload:UIImage)
    {
        
        /*
         photo
         The file to upload.
         title (optional)
         The title of the photo.
         description (optional)
         A description of the photo. May contain some limited HTML.
         tags (optional)
         A space-seperated list of tags to apply to the photo.
         is_public, is_friend, is_family (optional)
         Set to 0 for no, 1 for yes. Specifies who can view the photo.
         safety_level (optional)
         Set to 1 for Safe, 2 for Moderate, or 3 for Restricted.
         content_type (optional)
         Set to 1 for Photo, 2 for Screenshot, or 3 for Other.
         hidden (optional)
         Set to 1 to keep the photo in global search results, 2 to hide from public searches.
         */
        let url :String = "https://up.flickr.com/services/upload/"
        let parameters :Dictionary = [
            "method"         : "flickr.photos.search",
            "api_key"        : consumerKey,
            "user_id"        : self.strUserId,
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_q,url_z"
        ]
        
        
        let _ = oauthswift.client.get(
            url, parameters: parameters,
            success: { response in
                
                //  DispatchQueue.main.async {
                
                let larrayPhotosURL:NSMutableArray = NSMutableArray()
                
                let jsonDict = try? response.jsonObject()
                let photoArray = FlickrManager.sharedInstance.photoArray(fromResponse: jsonDict as! [String : Any] as NSDictionary)
                
                for photoDictionary in photoArray {
                    let photoURL = FlickrManager.sharedInstance.photoURL(for: "m", fromPhotoDictionary: photoDictionary as! NSDictionary)
                    print("check->\(photoURL)")
                    larrayPhotosURL.add(photoURL)
                }
                
                self.delegate?.flickrPhotosURLResponse(larrayPhotoURLs: larrayPhotosURL)
                
                // }
                
            },
            failure: { error in
                print(error)
            }
        )
    }
    
}
//---------------------------------------------------
// MARK: -  END
//---------------------------------------------------
