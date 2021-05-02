//
//  AddNewListViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/11/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces
import AlamofireImage



class AddNewListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var categoryText: UITextField!
    
    var pickedImage:UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func hideKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraBtn(_ sender: Any) {
        let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = true
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("Camera is available 📸")
                    vc.sourceType = .camera
                } else {
                    print("Camera 🚫 available so we will use photo library instead")
                    vc.sourceType = .photoLibrary
                }
                
                self.present(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [String : Any]) {
            // Get the image captured by the UIImagePickerController
            
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            self.pickedImage = editedImage
            
            
            // Do something with the images (based on your use case)
            
            // Dismiss UIImagePickerController to go back to your original view controller
            
            dismiss(animated: true, completion: {
                // save image with the act
                // Do something here
               
            })
    }
    
    /**
         Method to convert UIImage to PFFile
         
         - parameter image: Image that the user wants to upload to parse
         
         - returns: PFFile for the the data in the image
         */
        func getPFFileFromImage(image: UIImage?) -> PFFileObject? {
            // check if image is not nil
            if let image = image {
                // get image data and check if that is not nil
                if let imageData = UIImagePNGRepresentation(image) {
                    return PFFileObject(name: "image.png", data: imageData)
                }
            }
            return nil
        }
            

    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        var backgroundImg:PFFileObject!
        let image = UIImage(named: "image.png")
       
        
        if(pickedImage == nil){
            backgroundImg = getPFFileFromImage(image: image)
        }
        else{
            backgroundImg = getPFFileFromImage(image: pickedImage)
        }
        List.addNewList(name: nameText.text, category: categoryText.text, likeCount: 0 , activities: nil, backgroundImage: backgroundImg) { (success, error) in
            if (success != nil) {
                print("List created!")
                
                self.dismiss(animated: true, completion: nil)
            }
            else if let error = error {
                print("Problem saving list: \(error.localizedDescription)")
            }
        }
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


