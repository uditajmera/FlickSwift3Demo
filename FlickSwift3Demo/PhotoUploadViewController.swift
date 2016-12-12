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
import OAuthSwift

class PhotoUploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

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
    
    func generateBoundaryString() -> String {
        
        return "Boundary-\(NSUUID().uuidString)"
    }

    @IBAction func picUploadButtonPressed(_ sender: AnyObject)
    {
        
        let parameters =  Dictionary<String, AnyObject>()
        let image_data = UIImageJPEGRepresentation(self.objUploadingImageView.image!, 0.5)
        // Multi-part upload
        let _ = FlickrManager.sharedInstance.oauthswift?.client.postImage(
            "https://up.flickr.com/services/upload/", parameters: parameters, image: image_data!,
            success: { response in
                let jsonDict = try? response.jsonObject()
                print("SUCCESS: \(jsonDict)")
                print("SUCCESS: \(response)")

            },
            failure: { error in
                print(error)
            }
        )
//        let url = NSURL(string: "https://up.flickr.com/services/upload/")
//
//        var request = URLRequest(url: url! as URL)
//        
//        request.httpMethod = "POST"
//        
//        let boundary = generateBoundaryString()
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)",
//            forHTTPHeaderField: "Content-Type")
//        
//        if (self.objUploadingImageView.image == nil)
//        { return }
//        
//        let image_data = UIImagePNGRepresentation(self.objUploadingImageView.image!)
//        let body = NSMutableData()
//        let fname = "porch-167.png"
//        let mimetype = "image/png"
//        
//        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//        
//        body.append("Content-Disposition:form-data;name=\"photo\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//        
//        body.append("Incoming\r\n".data(using: String.Encoding.utf8)!)
//        
//        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//        
//        body.append("Content-Disposition:form-data; name=\"file\";filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
//        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using:
//            String.Encoding.utf8)!)
//        body.append(image_data!)
//        body.append("\r\n".data(using: String.Encoding.utf8)!)
//        body.append("--\(boundary)--\r\n".data(using:
//            String.Encoding.utf8)!)
//        request.httpBody = body as Data
//        
//        let session = URLSession.shared
//        
//        let task = session.dataTask(with: request as URLRequest) {
//            (
//            data, response, error) in
//            
//            guard let _:Data = data, let _:URLResponse = response , error
//                == nil else {
//                    print("error")
//                    return
//            }
//            
//            let dataString = String(data: data!, encoding: 
//                String.Encoding(rawValue: String.Encoding.utf8.rawValue))
//            print(dataString)
//            
//        }
//        
//        task.resume()
    
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
