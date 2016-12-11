//
//  UserPhotosViewController.swift
//  FlickSwift3Demo
//
//  Created by Udit Ajmera on 12/11/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//

import UIKit

class UserPhotosViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,FlickrManagerDelegate {

    @IBOutlet weak var objUserPhotosCollectionView: UICollectionView!
    var arrayPhotosURL : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FlickrManager.sharedInstance.delegate = self
        
        FlickrManager.sharedInstance.userPhotosURLs(FlickrManager.sharedInstance.oauthswift!, consumerKey: FlickrManager.sharedInstance.strApiKey)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------
    // MARK: - collection view data source
    //---------------------------------------------------
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayPhotosURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:UserPhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPhotoReuseIdentifier", for: indexPath as IndexPath) as! UserPhotoCollectionViewCell
        
        
        //  cell.objGameNameLabel.text = lobjGameCellData.strGameName
        //cell.objGameButton.setTitle(lobjGameCellData.strGameName, for: .normal)
        let lstrImageURL = self.arrayPhotosURL.object(at: indexPath.row)
        cell.downloadImage(url: URL.init(string: lstrImageURL as! String)!)
        
        return cell
    }
    
    
    override var prefersStatusBarHidden:Bool {
        return true
    }
    
    //---------------------------------------------------
    // MARK: - FlickrManagerDelegate
    //---------------------------------------------------

    func flickrPhotosURLResponse(larrayPhotoURLs:NSMutableArray)
    {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
