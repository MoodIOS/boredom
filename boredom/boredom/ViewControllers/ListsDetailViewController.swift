//
//  ListsDetailViewController.swift
//  boredom
//
//  Created by jsood on 4/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class ListsDetailViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var listNameLabel: UILabel!
    
    @IBOutlet weak var noActivitiesLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var activities =  [UserActivity]()
    var authorOfList: PFUser!
    var list: List!
    var newList: List!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.reloadData()
        
        listNameLabel.text = list.listName
        
        if (list.activities?.count != 0){
            noActivitiesLabel.text = ""
        }
        
        getActivitiesInList()
    }

    func getActivitiesInList(){
        UserActivity.fetchActivity() { (activities: [UserActivity]?, error: Error?) in
            if error == nil{
                self.activities = activities!
                print(".........." , activities![0].list)
                self.tableView.reloadData()
            } else {
                print("problem fetching UserActivity", error?.localizedDescription )
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.activities?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesInListCell", for: indexPath) as! ActivitiesInListCell
        let author = authorOfList
        /*UserActivity.fetchActivity(listId: list.objectId!) { (activities: [UserActivity]?, error: Error?) in
            if error == nil{
                self.activities = activities
            }
        }*/
        let activity = self.activities[indexPath.row]
        print("oooooooooo",activity.activity.actName)
        let activityName = activity.activity.actName as String?
        
        cell.activityNameLabel.text = activityName ?? "Label"
        tableView.reloadData()
        
        //tableView.deselectRow(at: indexPath, animated: true)
        return cell
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
        Activity.addNewActivity(actName: list.activities![0].actName, actDescription: list.activities![0].actDescription, list: newList, cost: list.activities![0].cost, location: "temp"){ (activity, error) in
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
