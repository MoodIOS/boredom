//
//  ListsDetailViewController.swift
//  boredom
//
//  Created by jsood on 4/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

class ListsDetailViewController: UIViewController {

    var list: List!
    var newList: List!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func copyList(_ sender: Any) {
        
        // nameText = name of the list copying
        // categoryText = category
        // likeCount should be reset to 0 since copying list
        List.addNewList(name: list.listName, category: list.category, likeCount: 0 ) { (newList, error) in
            if (newList != nil) {
                print("List created!")
                
                
                //self.dismiss(animated: true, completion: nil)
            }
            else if let error = error {
                print("Problem saving list: \(error.localizedDescription)")
            }
        }
        
        
        // copy all the activities from selected list to the one we just made
        Activity.addNewActivity(actName: list.activities![0].actName, actDescription: list.activities![0].actDescription, list: newList, cost: "temp", location: "temp"){ (activity, error) in
            if let activity = activity  {
                print("Activity ID:", activity)
                UserActivity.addNewActivity(activity: activity, list: self.list, withCompletion: { (success, error) in
                    if success == true{
                        print("User activity created")
                        self.dismiss(animated: true, completion: nil)
                        print(activity.actName)
                        //self.loadActivity()
                    } else if let error = error {
                        print("Problem saving User activity: \(error.localizedDescription)")
                    }
                })
            }
    }


    }
    
}
