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
    var activityIsLiked: Bool = false
    
    var curActGlobal: Activity!
    var likeCell: ActivitiesInListCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getActivitiesInList()

        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.reloadData()
        
        listNameLabel.text = list.listName
        noActivitiesLabel.isHidden = true
        
        
        
        
        
        //randomStuff()

        //getActivitiesInList()
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            var userId = PFUser.current()?.objectId
             var index = 0
             if (!self.curAct.activity.activityLikedByUsers.isEmpty) {
             while index < self.curAct.activity.activityLikedByUsers.count{
             if(self.curAct.activity.activityLikedByUsers[index] == userId)
             {
             self.activityIsLiked = true
             self.likeCell.favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
             
             }
             }
             }
        }*/
        /*var userId = PFUser.current()?.objectId
         var index = 0
         if (!curAct.activity.activityLikedByUsers.isEmpty) {
         while index < curAct.activity.activityLikedByUsers.count{
             if(curAct.activity.activityLikedByUsers[index] == userId)
             {
             self.activityIsLiked = true
             likeCell.favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
             
             }
            index = index + 1
            }
         }*/
        
        
    }
    
  
    func tapFavoritesBtn(activity: Activity){
        var activity = activities
    }
    
   
    func getActivitiesInList(){
        let curList = self.list
        let listId = curList?.objectId
        var activitesArray: [UserActivity] = []
        var userId = PFUser.current()?.objectId
        UserActivity.fetchActivity(listId: listId!) { (activities: [UserActivity]?, error: Error?) in
            if error == nil{
                if activities! != []{
                    self.noActivitiesLabel.isHidden = true
                    self.activities = activities!
                    activitesArray = activities!
                    let curAct = activities![0]
                    print("current Act : ", curAct)
                    self.curActGlobal = curAct.activity!
                   // var index = 0
                    
                    /*if (!self.curActGlobal.fetchIfNeeded().activityLikedByUsers.isEmpty) {
                        while index < self.curActGlobal.activityLikedByUsers.count{
                            if(self.curActGlobal.activityLikedByUsers[index] == userId)
                            {
                                self.activityIsLiked = true
                                self.likeCell.favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
                                
                            }
                            index = index + 1
                        }
                    }*/
                    //self.randomStuff(curActivity: self.curActGlobal)
                    print("current Act Global: ", self.curActGlobal)
                    self.tableView.reloadData()

                } else if (activities! == []) {

                    self.noActivitiesLabel.isHidden = false
                }
            } else {
                print("problem fetching UserActivity", error?.localizedDescription )
            }
        }
        //self.randomStuff(curActivity: activitesArray[0].activity)
        //self.randomStuff(curActivity: curActGlobal)
        
    }
    
    
    
    /*func randomStuff(curActivity: Activity)
    {
        var userId = PFUser.current()?.objectId
        var query = PFQuery(className: "Activity")
        query.includeKey("activityLikedByUsers")
        var index = 0
       
        if (!query.activity.activityLikedByUsers.isEmpty) {
            while index < curActivity.activityLikedByUsers.count{
                if(curActivity.activityLikedByUsers[index] == userId)
                {
                    self.activityIsLiked = true
                    likeCell.favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
                    
                }
                index = index + 1
            }
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesInListCell", for: indexPath) as! ActivitiesInListCell
        likeCell = cell
        let userActivities = self.activities
        let curAct = userActivities[indexPath.row]
        //curLikeAct = curAct
        let currentActId = curAct.activity.objectId
        
        
        Activity.fetchActivity(actId: currentActId!) { (activities: [Activity]?, error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let activity = activities![0]
                cell.activityNameLabel.text = activity.actName
                cell.activity = activity
                cell.userAct = curAct
                
                
                try? cell.userAct.activity.fetchIfNeeded()
                
                print("ACTIVITY LIKED BY USERS:", cell.userAct.activity.activityLikedByUsers)
                if(cell.userAct.activity.activityLikedByUsers.contains((PFUser.current()?.objectId)!)){
                        cell.favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
                    }
                
            }
        }
        
        /*var userId = PFUser.current()?.objectId
        var index = 0
        if (!curAct.activity.activityLikedByUsers.isEmpty) {
            while index < curAct.activity.activityLikedByUsers.count{
                if(curAct.activity.activityLikedByUsers[index] == userId)
                {
                    self.activityIsLiked = true
                    cell.favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
                    
                }
                 index = index + 1
            }
        }*/
        
        
        
        
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
        Activity.addNewActivity(actName: list.activities![0].actName, actDescription: list.activities![0].actDescription, list: newList, cost: list.activities![0].cost, location: "temp", tags: ["tag": false]){ (activity, error) in
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
