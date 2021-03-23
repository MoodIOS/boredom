//
//  SettingViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
//import ParseUI


class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    

    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var userImage: UIImageView!
    var pickedImage: UIImage?
    
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = User.current()?.username
        userImage.isUserInteractionEnabled = true

        if let imageFile = User.current()?.profileImage {
            imageFile.getDataInBackground(block: { (data, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        // Async main thread
                        let image = UIImage(data: data!)
                        self.userImage.image = image
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }
    
    func getUserInfo(){
        let user = User.current()
        let username = user!["username"] as! String
        if  username != "username" {
            self.usernameLabel.text = user!["username"] as? String
        } else {
            self.usernameLabel.text = "Unknown Username"
        }
        print("in getuserinfo()")
        if let getParseImg = user!["profileImage"] as? PFFileObject {
            getParseImg.getDataInBackground{(imageData, error) in
                if (error == nil) {
                    if let imageData = imageData{
                        let img = UIImage(data: imageData)
                        self.userImage.image = img
                        self.usernameLabel.text = user!["username"] as? String
                    }
                }
            }
        }

    }
    
    
    @IBAction func editProfPic(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        //self.present(vc, animated: true, completion: nil)
        self.present(vc, animated: true, completion:nil)
            //let user = User.current
            
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.pickedImage = editedImage
        //temp.image = originalImage
        
        // Do something with the images (based on your use case)
        
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: {
            User.makeProfPic(image: self.pickedImage) { (success, error) in
                if success {
                    self.userImage.image = self.pickedImage
                    print("image saved")
                    
                }
                else if let error = error {
                    print("Problem saving image \(error.localizedDescription)")
                }
            }
        })
        
    }
    
    
    @IBAction func changePassword(_ sender: Any) {
        let user = User.current()
        if password1.text == password2.text {
            user!.password = password1.text
            user!.saveInBackground() { (success,error) in
                if success {
                    /*User.logInWithUsername(inBackground: user!.username!, password: user!.password!) { (user, error) in
                        // Your code here...
                    }*/
                    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    User.logInWithUsername(inBackground: user!.username!, password: user!.password!) { (user: PFUser?, error:Error?) -> Void in
                        if user != nil {
                            //appDelegate.login()
                            print("Password changed!")
                        }
                        //self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                }
            }
        }
        else {
            print("Passwords not the same!")
        }
    }
    
//    @objc func didTap(){
//        print("User did tap")
//        let  vc = UIImagePickerController()
//        vc.delegate = self
//        vc.allowsEditing = true
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            print("Camera is available")
//            vc.sourceType = .camera
//        } else {
//            print("Camera is not available. Use photo library")
//            vc.sourceType = .photoLibrary
//        }
//        //Show ImagePicker either library or camera
//        self.present(vc, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        //        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
//        profileImage.image = editedImage
//        let imageData = UIImagePNGRepresentation(editedImage)
//        let parseImageFile = PFFile(name: "upload_image.png", data: imageData!)
//        let currentuser = PFUser.current()
//        currentuser!["profilePic"] = parseImageFile
//        currentuser?.saveInBackground(block: { (success, error: Error?) in
//            if error == nil {
//                print(success)
//            } else {
//                print(error?.localizedDescription)
//            }
//        })
//
//        dismiss(animated: true, completion: nil)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
