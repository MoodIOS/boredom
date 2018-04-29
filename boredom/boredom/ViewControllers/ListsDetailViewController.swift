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
    var listID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.reloadData()
        
        listNameLabel.text = list.listName

        getActivitiesInList()
    }
  
    func tapFavoritesBtn(activity: Activity){
        var activity = activities
    }
    
   
    func getActivitiesInList(){
        let curList = self.list
        let listId = curList?.objectId
        UserActivity.fetchActivity(listId: listId!) { (activities: [UserActivity]?, error: Error?) in
            if error == nil{
                if activities != []{
                    self.activities = activities!
                    let curAct = activities![0]
                    print("current Act : ", curAct)
                    let curActGlobal = curAct.activity!
                    print("current Act Global: ", curActGlobal)
                    self.tableView.reloadData()
                } else if (activities == []) {
                    self.noActivitiesLabel.text = ""
                }
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
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesInListCell", for: indexPath) as! ActivitiesInListCell
        let userActivities = self.activities
        let curAct = userActivities[indexPath.row]
        let currentActId = curAct.activity.objectId
        
        Activity.fetchActivity(actId: currentActId!) { (activities: [Activity]?, error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let activity = activities![0]
                cell.activityNameLabel.text = activity.actName
            }
        }
        
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
