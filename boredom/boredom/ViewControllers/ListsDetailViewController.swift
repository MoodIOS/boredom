
//  ListsDetailViewController.swift
//  boredom
//
//  Created by jsood on 4/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//
import UIKit
import Parse

class ListsDetailViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var listNameLabel: UILabel!
    
    @IBOutlet weak var noActivitiesLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var activities =  [UserActivity]()
    var globalActivities = [Activity]()
    var authorOfList: PFUser!
    var list: List!
    var newList: List!
    var listID: String!
    var activityIsLiked: Bool = false
    
    var curActGlobal: Activity!
    var likeCell: ActivitiesInListCell!
    
    var userLikedActs = [String]()
    
    @IBAction func backToExplore(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getActivitiesInList()
        
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.reloadData()
        
        listNameLabel.text = list.listName
        noActivitiesLabel.isHidden = true
  
        
    }
    
    
    func tapFavoritesBtn(activity: Activity){
        var activity = activities
    }
    
    
    func getActivitiesInList(){
        let curUser = User.current()
        userLikedActs = (curUser?.likedActivities)!
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
                   
                    print("current Act Global: ", self.curActGlobal)
                    self.tableView.reloadData()
                    
                } else if (activities! == []) {
                    
                    self.noActivitiesLabel.isHidden = false
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
    
    
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesInListCell", for: indexPath) as! ActivitiesInListCell
        let currentAct = self.activities[indexPath.row]
        let currActId = currentAct.activity.objectId
        Activity.fetchActivity(actId: currActId!) { (activities: [Activity]?, error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let activity = activities![0]
                cell.activityNameLabel.text = activity.actName
                cell.activity = activity
                cell.userAct = currentAct
                
                
                try? cell.userAct.activity.fetchIfNeeded()
                
                print("ACTIVITY LIKED BY USERS:", cell.userAct.activity.activityLikedByUsers)
                if(cell.userAct.activity.activityLikedByUsers.contains((PFUser.current()?.objectId)!)){
                    cell.favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
                }
                
            }
        }
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesInListCell", for: indexPath) as! ActivitiesInListCell
        likeCell = cell
        let userActivities = self.activities
        let currentAct = userActivities[indexPath.row]
        //curLikeAct = curAct
        let currentActId = currentAct.activity.objectId
        
        Activity.fetchActivity(actId: currentActId!) { (activities: [Activity]?, error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let curAct = activities![0]
                var liked: Int = 0
                var i = 0
                while i < self.userLikedActs.count{
                    let id = self.userLikedActs[i]
                    if id == curAct.objectId {
                        liked = liked + 1
                    }
                    i = i + 1
                }
                
                if liked == 0 {
                    cell.favoritesBtn.setImage(UIImage(named: "heart-gray"), for: .normal)
                } else if liked > 0 {
                    cell.favoritesBtn.setImage(UIImage(named: "heart-red"), for: .normal)
                }
                
                cell.activityNameLabel.text = curAct.actName
                cell.activity = curAct
                cell.userAct = currentAct
                cell.likeCount.text = "\(curAct.activityLikeCount)"
            }
        }
//        Activity.fetchActivity(actId: currentActId!) { (activities: [Activity]?, error: Error?) in
//            if activities! != [] {
//                let activities = activities
//                print("ACTIVITIES:", activities![0])
//                let activity = activities![0]
//                cell.activityNameLabel.text = activity.actName
//                cell.activity = activity
//                cell.userAct = curAct
//
//
//                try? cell.userAct.activity.fetchIfNeeded()
//
//                print("ACTIVITY LIKED BY USERS:", cell.userAct.activity.activityLikedByUsers)
//                if(cell.userAct.activity.activityLikedByUsers.contains((PFUser.current()?.objectId)!)){
//                    cell.favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
//                }
//
//            }
//        }

        return cell
    }
    
    
    
    @IBAction func copyList(_ sender: Any) {
        // nameText = name of the list copying
        // categoryText = category
        // likeCount should be reset to 0 since copying list
        let actsInList = list.activities
        print("actInList", actsInList!)
        if actsInList! != [] {
            List.addNewList(name: list.listName, category: list.category, likeCount: 0, activities: actsInList) { (addedList: List?, error: Error?) in
                if (addedList != nil) {
                    print("List created!")
                    print("copy list", addedList!)

                    for act in self.globalActivities {
                        UserActivity.addNewActivity(activity: act, list: addedList, completion: { (userAct: UserActivity?, error: Error?) in
                            if error == nil {
                                print ("userAct", userAct!)
                            }
                        })
                    }
                    self.dismiss(animated: true, completion: nil)
                } else if let error = error {
                    print("Problem saving list: \(error.localizedDescription)")
                }
            }
            
            
        }
    
        getActivitiesInList()

    }
}

