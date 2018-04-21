//
//  AddNewActivityVCViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/12/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
import SearchTextField

class AddNewActivityVCViewController: UIViewController {

    @IBOutlet weak var actName: UITextField!
    @IBOutlet weak var actDescription: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var cost: UITextField!
    
    @IBOutlet weak var name: SearchTextField!
    
    var list = List()
    var allActivities: [Activity]?
    var activityNames: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityNames = []
        print("self.list", self.list)
        Activity.fetchActivity(completion: { (activities: [Activity]?, error: Error?) in
            if error == nil {
                self.allActivities = activities
                print("list of all activities")
                print (self.allActivities?.count)
                for act in self.allActivities! {
                    self.activityNames?.append(act.actName)
                    print (act.actName)
                    //self.name.filterStrings(self.activityNames!)
                }
                print(self.activityNames?.count)
                print("asdf")
                self.name.filterStrings(self.activityNames!)
                /*self.getActivityNames(completion: { (activityNames: [String]?, error: Error?) in
                    self.activityNames = activityNames
                    
                    
                    self.name.filterStrings(activityNames!)
                })*/
                
                
            }
            else {
                print(error?.localizedDescription)
            }
        })
        
        //for act in allActivities! {
            //activityNames?.append(act.actName)
        //}
        //activityNames = ["Red", "blue"]
        //name.filterStrings(activityNames!)
        //allActivities = Activity.fetchAct
        // Do any additional setup after loading the view.
    }

    @IBAction func saveNewActivity(_ sender: UIBarButtonItem) {
//        let currentList = self.list
//        print("Save list objectId:", currentList.objectId)
        Activity.addNewActivity(actName: actName.text, actDescription: actDescription.text, list: self.list, cost: cost.text!, location: location.text){ (success, error) in
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
    
    func getActivityNames(completion: @escaping ([String]?, Error?) -> Void) {
        //let activityNames: [String]?
        for act in allActivities! {
            activityNames?.append(act.actName)
            print (act.actName)
        }
        //return self.getActivityNames(completion: completion)
        //return activityNames
        //activityNames = ["Red", "blue"]
        //name.filterStrings(activityNames!)
    }
    /*func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Set the max character limit
        let characterLimit = 140
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        // TODO: Update Character Count Label
        
        // The new text should be allowed? True/False
        let count = newText.characters.count
        charCount.text = String(count) + "/140"
        
        if count == 0 {
            placeHolder.textColor = UIColor.lightGray
            tweetButton.backgroundColor = lightBlue
            tweetButton.isEnabled = false
        }
        else {
            placeHolder.textColor = UIColor.clear
            tweetButton.backgroundColor = blue
            tweetButton.isEnabled = true
        }
        return count < characterLimit
        // TODO: Check the proposed new text character count
        // Allow or disallow the new text
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
