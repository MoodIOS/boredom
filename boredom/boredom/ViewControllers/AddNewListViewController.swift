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



class AddNewListViewController: UIViewController {

    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var categoryText: UITextField!

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
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        List.addNewList(name: nameText.text, category: categoryText.text, likeCount: 0 , activities: nil) { (success, error) in
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


