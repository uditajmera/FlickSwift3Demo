//
//  UserPhotosViewController.swift
//  FlickSwift3Demo
//
//  Created by Udit Ajmera on 12/11/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//
//---------------------------------------------------
// MARK: - SDK Import
//---------------------------------------------------

import UIKit


class UserPhotosViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,FlickrManagerDelegate {

    //---------------------------------------------------
    // MARK: - IB outlet
    //---------------------------------------------------

    @IBOutlet weak var objUserPhotosCollectionView: UICollectionView!
    
    //---------------------------------------------------
    // MARK: - private variable
    //---------------------------------------------------
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 2.5, bottom: 0, right: 2.5)

    var arrayPhotosURL : NSMutableArray = []
    
    //---------------------------------------------------
    // MARK: - Default methods
    //---------------------------------------------------
    
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
        let lstrImageURL:URL = self.arrayPhotosURL.object(at: indexPath.row) as! URL
        print(lstrImageURL)
        cell.downloadImage(url: lstrImageURL)
        
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
        print(larrayPhotoURLs)
        self.arrayPhotosURL = larrayPhotoURLs
        self.objUserPhotosCollectionView.reloadData()
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

//---------------------------------------------------
// MARK: - Extension GamesTableViewController
//---------------------------------------------------

extension UserPhotosViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        //        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        //        let availableWidth = view.frame.width - (paddingSpace)
        //        let widthPerItem = availableWidth / itemsPerRow
        
        print(collectionView.frame.size.width)
        let lfWidthOfCell  = (collectionView.frame.size.width - 8)/2
        
        return CGSize(width: lfWidthOfCell, height: 130)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
}



