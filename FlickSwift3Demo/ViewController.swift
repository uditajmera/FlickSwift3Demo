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

class ViewController: UIViewController {

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
    
    //---------------------------------------------------
    // MARK: -  Button Action
    //---------------------------------------------------
    
    @IBAction func flickrButtonPressed(_ sender: AnyObject) {
        
        if(FlickrManager.sharedInstance.bAuthorized)
        {
//            FlickrKit.shared().logout()
//            self.userLoggedOut()
        } else
        {
            self.performSegue(withIdentifier: "SegueToAuth", sender: self)
        }
    }

}
//---------------------------------------------------
// MARK: -  END
//---------------------------------------------------

