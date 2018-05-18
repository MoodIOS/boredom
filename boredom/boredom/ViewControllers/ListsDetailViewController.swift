
//  ListsDetailViewController.swift
//  boredom
//
//  Created by jsood on 4/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//
import UIKit
import Parse



class ListsDetailViewController: UIViewController, UITableViewDataSource, AddSomeActDelegate {
    
    
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
    
    var itemForPickerview = [[String : String]]()
    var pickerRow = Int()
    
    
    
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
    
    func handleAddingAct(at index: IndexPath){
        print("handlingAddingAct")
        
        
        
//        let curUserAct = activities[index.row]
//        let curActID = curUserAct.activity.objectId
//        for act in globalActivities{
//            if curActID = act.objectId{
//                
//            }
//        }
        
    }
    
// ============ Picker View for adding ================
/*
    @IBAction func onAddingActToList(_ sender: UIButton) {
        print("adding Act to list")
        if pickerRow == 0 {
            print("please pick a list")
        } else if pickerRow != 0 {
            print ("before UserAct.addnewact", addingActivity)
            
            print("pickedListID", pickedListID)
            List.fetchWithID(listID: pickedListID) { (lists: [List]?, error: Error?) in
                if error == nil {
                    if let lists = lists {
                        print("listtttt for adding", lists)
                        UserActivity.addNewActivity(activity: self.addingActivity, list: lists[0] ) { (userAct: UserActivity?, error: Error?) in
                            if error == nil{
                                List.addActToList(currentList: lists[0], userAct: userAct!, tags: self.addingActivity.tags, completion: { (list: List?, error: Error?) in
                                    if error == nil {
                                        print("done")
                                        self.addBtn.isHidden = true
                                        self.cancelBtn.isHidden = true
                                        self.doneBtn.isHidden = false
                                    } else {
                                        print("Error adding activity to list \(String(describing: error?.localizedDescription))")
                                    }
                                })
                            } else {
                                print("Error adding activity to userAct \(String(describing: error?.localizedDescription))")
                            }
                        }
                    }
                }
                
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let thisList = userLists[row]
        self.selectedList = thisList
        print("self.selectedList",self.selectedList)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userLists.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let list = userLists[row]
        let listName = list.listName
        return listName
    }
    
    
    func getLists() {
        let curUser = PFUser.current()
        let userId = curUser?.objectId
        List.fetchLists(userId: userId!) { (lists: [List]?, error: Error?) in
            if lists?.count == 0 {
                //                self.noListsLabel.isHidden = false
                print("user has no lists yet")
            }
            else {
                if error == nil {
                    let lists = lists!
                    //                    self.noListsLabel.isHidden = true
                    print(lists)
                    self.userLists = lists
                    self.listPicker.reloadAllComponents()
                    print("self.lists", self.userLists )
                    print("lists[0]", self.userLists[0].listName)
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func onCancelAdding(_ sender: UIButton) {
        viewWithPicker.isHidden = true
        print("on cancel adding")
    }
    
    //Clicked Done and view picker is hidden
    @IBAction func onDoneAdding(_ sender: UIButton) {
        viewWithPicker.isHidden = true
        print("on done adding")
        
    }
*/
// ===================================
    
    
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
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesInListCell", for: indexPath) as! ActivitiesInListCell
        likeCell = cell
        let userActivities = self.activities
        let currentAct = userActivities[indexPath.row]
        //curLikeAct = curAct
        let currentActId = currentAct.activity.objectId
        cell.delegate = self
        cell.indexPath = indexPath
        Activity.fetchActivity(actId: currentActId!) { (activities: [Activity]?, error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let curAct = activities![0]
                if curAct.cost == 0 {
                    cell.costLabel.text = "$"
                } else if curAct.cost == 1 {
                    cell.costLabel.text = "$$"
                } else if curAct.cost == 2 {
                    cell.costLabel.text = "$$$"
                } else {
                    cell.costLabel.text = "$$$$"
                }
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

