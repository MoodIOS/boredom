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
    @IBOutlet weak var costControl: UISegmentedControl!
    
    @IBOutlet weak var name: SearchTextField!
    
    var list = List()
    var allActivities: [Activity]?
    var activityNames: [SearchTextFieldItem]!
    var activityId: [String]!
    var actNamesInList =  [String]()
    var tags = [String: Bool]()
    
    @IBOutlet weak var restaurantTag: UIButton!
    @IBOutlet weak var brunchTag: UIButton!
    @IBOutlet weak var movieTag: UIButton!
    @IBOutlet weak var outdoorTag: UIButton!
    @IBOutlet weak var bookTag: UIButton!
    @IBOutlet weak var coffeeTag: UIButton!
    @IBOutlet weak var nightlifeTag: UIButton!
    @IBOutlet weak var happyhoursTag: UIButton!
    

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.activityNames = []
        self.activityId = []
        
        print("self.list", self.list)
        loadActivity()
    }

    @IBAction func saveNewActivity(_ sender: UIBarButtonItem) {
        // TO-DO: check if the data already has this item, if user already have this item in this list.
        checkForDuplicate { (duplicateAct: Int, error: Error?) in
            if duplicateAct > 0 {
                self.actName.text = ""
                self.actDescription.text = ""
                self.location.text = ""
                self.costControl.selectedSegmentIndex = 0
                let alertController = UIAlertController(title: "Can't Add Activity", message: "You already have this item in your list. Please add a different item." , preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
                alertController.addAction(cancelAction)
                let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            } else {
                print("duplicate? ", duplicateAct)
                let choseMon = [1,2,3,4]
                let result = choseMon[self.costControl.selectedSegmentIndex]
                var savedValue = 5
                if(result == 1){
                    savedValue = 0
                }
                else if(result == 2){
                    savedValue = 1
                }
                else if(result == 3){
                    savedValue = 2
                }
                else if(result == 4){
                    savedValue = 3
                }
                print("self.tags", self.tags)
                
                Activity.addNewActivity(actName: self.actName.text, actDescription: self.actDescription.text, list: self.list, cost: savedValue, location: self.location.text, tags: self.tags){ (activity, error) in
                    if let activity = activity  {
                        print("Activity ID:", activity)
                        UserActivity.addNewActivity(activity: activity, list: self.list, withCompletion: { (success, error) in
                            if success == true {
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
    
    @IBAction func clickedOnTags(_ sender: UIButton) {
        let button = sender
        print("button sender ", button.backgroundColor!)
        let blueColor = UIColor.init(red: 0, green: 122/255, blue:1 , alpha: 1)
        let grayColor = UIColor.lightGray
        print("blueColor", blueColor)
        print("grayColor", grayColor)
        handleTags(tagName: button.currentTitle!) { (tags: [String: Bool]?, error: Error?) in
            for (tag, value) in tags!{
                if (value == true) && (button.currentTitle == tag)  {
                    button.backgroundColor = UIColor.init(red: 0, green: 122/255, blue:1 , alpha: 1)
                } else if (value == false) && (button.currentTitle == tag) {
                    button.backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    
    func handleTags (tagName: String, completion: @escaping ([String:Bool]?, Error? ) -> Void){
        print("handleTag: ", tagName)
        if tags[tagName] == false || tags[tagName] == nil {
            tags[tagName] = true
        } else {
            tags[tagName] = false
        }
        print("tags: ", tags)
        return completion(tags, nil)
        
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil )
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkForDuplicate(done: @escaping (Int, Error?) -> Void){
        let newName = actName.text
        var totalDuplicate = 0
        for act in actNamesInList{
            if act == newName{
                totalDuplicate = totalDuplicate + 1
            }
        }
        return done(totalDuplicate, nil)
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
            for (_, act) in (self.allActivities!).enumerated() {
                if act.actName == result.title {
                    self.actDescription.text = act.actDescription
//                    self.cost.text = act.cost
                    self.location.text = act.location
                }
            }
        }
        
        
    }
    
    
    func getActivityNames() {
        for act in allActivities! {
            let item = SearchTextFieldItem(title: act.actName)
            activityNames?.append(item)
            print (act.actName)
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
