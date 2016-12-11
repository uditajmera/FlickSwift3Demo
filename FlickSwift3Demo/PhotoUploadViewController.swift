//
//  PhotoUploadViewController.swift
//  FlickSwift3Demo
//
//  Created by Udit Ajmera on 12/11/16.
//  Copyright © 2016 Udit Ajmera. All rights reserved.
//
//---------------------------------------------------
// MARK: - SDK Import
//---------------------------------------------------

import UIKit

class PhotoUploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var objUploadingImageView: UIImageView!
    //---------------------------------------------------
    // MARK: - Default Methods
    //---------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //---------------------------------------------------
    // MARK: - Image Picker Methods
    //---------------------------------------------------
    
    
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func photoLibrary()
    {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func showActionSheet()
    {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
        //MenuTabBarController
        self.present(actionSheet, animated: true, completion: nil)
        //        self.performSegue(withIdentifier: "UploadImageToGameVC", sender: self)
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image:UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            
            //Button.setBackgroundImage("info[UIImagePickerControllerOriginalImage] as! UIImage?", forState: UIControlState.Normal)
            //Button.image(UIImage(named: "(info[UIImagePickerControllerOriginalImage] as? UIImage)"), forState: UIControlState.Normal)
            
            self.objUploadingImageView.image = image
            
            //            self.uploadapic.isHidden = true
            //            self.Tapthecamera.isHidden = true
            //
            //            self.tauntowithflowbtn.viewWithTag(0)?.isHidden = false
            //            self.objEnterNameTextField.isHidden = false
            //            self.countlable.isHidden = false
            //
            //            self.objEnterStatusLabel.isHidden=false
            //            self.Loginwhen.isHidden = false
            //
            //
            //            self.AlmostdoneLbl.text = "Almost Done!";
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func picUploadButtonPressed(_ sender: AnyObject)
    {

    }

    @IBAction func selectImageButtonPressed(_ sender: AnyObject) {
        
        showActionSheet()

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
