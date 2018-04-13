//
//  AddNewActivityVCViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/12/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
class AddNewActivityVCViewController: UIViewController {

    @IBOutlet weak var actName: UITextField!
    @IBOutlet weak var actDescription: UITextField!
    var list = List()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("self.list", self.list)
        // Do any additional setup after loading the view.
    }

    @IBAction func saveNewActivity(_ sender: UIBarButtonItem) {
//        let currentList = self.list
//        print("Save list objectId:", currentList.objectId)
        Activity.addNewActivity(actName: actName.text, actDescription: actDescription.text, list: self.list){ (success, error) in
            if success {
                print("Activity created!")

                self.dismiss(animated: true, completion: nil)
            }
            else if let error = error {
                print("Problem saving activity: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil )
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
