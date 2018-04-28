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
    var activityNames: [SearchTextFieldItem]!
    var activityId: [String]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.activityNames = []
        self.activityId = []
        
        print("self.list", self.list)
        loadActivity()
       
        
        
    }

    @IBAction func saveNewActivity(_ sender: UIBarButtonItem) {
        // TO-DO: check if the data already has this item, if user already have this item in this list.
        let newActName = actName.text
        let i = 0
        while i < (allActivities?.count)!{
            if allActivities != [] {
                let activityInList = allActivities![i]
                if (newActName == activityInList.actName ){
                    print("Activity is already added in list!")
                    break
                    
                } else {
                    Activity.addNewActivity(actName: actName.text, actDescription: actDescription.text, list: self.list, cost: cost.text!, location: location.text){ (activity, error) in
                        if let activity = activity  {
                            print("Activity ID:", activity)
                            UserActivity.addNewActivity(activity: activity, list: self.list, withCompletion: { (success, error) in
                                if success == true{
                                    print("User activity created")
                                    self.dismiss(animated: true, completion: nil)
                                    self.loadActivity()
                                } else if let error = error {
                                    print("Problem saving User activity: \(error.localizedDescription)")
                                }
                            })
                        }
                        else if let error = error {
                            print("Problem saving activity: \(error.localizedDescription)")
                        }
                    }
                }
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
    
    func getActivityNames() {
        //let activityNames: [String]?
        for act in allActivities! {
            let item = SearchTextFieldItem(title: act.actName)
            activityNames?.append(item)
            print (act.actName)
        }
    }
    
    func loadActivity(){
        Activity.fetchActivity(completion: { (activities: [Activity]?, error: Error?) in
            if error == nil {
                self.allActivities = activities
                self.getActivityNames()
                self.name.filterItems(self.activityNames)
                self.handleUserPicker()
            } else {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    func handleUserPicker() {
        self.name.itemSelectionHandler = {item, index in
            let result = item[index]
            self.name.text = "\(result.title)"
            for (index, act) in (self.allActivities!).enumerated() {
                if act.actName == result.title {
                    self.actDescription.text = act.actDescription
                    self.cost.text = act.cost
                    self.location.text = act.location
                }
            }
        }
        
        
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
