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


class FlickrManager: NSObject {

    
    //---------------------------------------------------
    // MARK: -  FilePrivate variables
    //---------------------------------------------------
    
    private(set) var strApiKey:String = ""
    private(set) var strSecret:String = ""
    private(set) public var strAuthToken:String = ""
    private(set) public var strAuthSecret:String = ""
    private(set) public var bAuthorized:Bool = false

    //---------------------------------------------------
    // MARK: -  Singleton declaration
    //---------------------------------------------------
    
    static let sharedInstance: FlickrManager = {
        let instance = FlickrManager()
        // setup code
        return instance
    }()
    
    //---------------------------------------------------
    // MARK: -  Utility Methods
    //---------------------------------------------------
    
    public func initialize(withAPIKey lstrApiKey:String, lstrSecret:String)
    {
        self.strApiKey = lstrApiKey
        self.strSecret = lstrSecret
    }
    
     func generateNonce() -> String {
        let uuidString:NSString = UUID().uuidString as NSString
        return uuidString.substring(to: 8)
    }
    
    
}
//---------------------------------------------------
// MARK: -  END
//---------------------------------------------------
