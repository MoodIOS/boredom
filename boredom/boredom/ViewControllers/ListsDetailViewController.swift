
//  ListsDetailViewController.swift
//  boredom
//
//  Created by jsood on 4/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//
import UIKit
import Parse



class ListsDetailViewController: UIViewController, UITableViewDataSource, AddSomeActDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var listNameLabel: UILabel!
    
    @IBOutlet weak var noActivitiesLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var activities =  [UserActivity]()
    var globalActivities = [Activity]()
    // for adding activity to ad list w pickerview
    var globalActsDictionary = [Activity]()
    var authorOfList: PFUser!
    var list: List!
    var addingList: List!
    var newList: List!
    var listID: String!
    var activityIsLiked: Bool = false
    var userListsPicker = [[String : String]]()
    var selectedList = List()
    var userLists = [List]()
    var curActGlobal: Activity!
    var likeCell: ActivitiesInListCell!
    var pickedListID = String()
    
    //to check duplicate in user list
    var userActsInUserList = [UserActivity]()
    
    
    var addingActivity = Activity()
    var userLikedActs = [String]()
    
    var itemForPickerview = [[String : String]]()
    var pickerRow = Int()
    @IBOutlet weak var viewWithPicker: UIView!
    @IBOutlet weak var listPicker: UIPickerView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    
    
    @IBAction func backToExplore(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getActivitiesInList()
        getLists()
        
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.reloadData()
        
        listNameLabel.text = list.listName
        noActivitiesLabel.isHidden = true
        
        viewWithPicker.isHidden = true
        doneBtn.isHidden = true
        listPicker.dataSource = self
        listPicker.delegate = self
        
    }
    
    func handleAddingAct(at index: IndexPath){
        print("handlingAddingAct")
        viewWithPicker.isHidden = false
        listPicker.selectRow(0, inComponent: 0, animated: false)
        addingActivity = globalActsDictionary[index.row]
        print("addingActivity", addingActivity)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let thisList = userListsPicker[row]
        self.pickedListID = thisList["id"]!
        pickerRow = row
        print("self.selectedList",self.pickedListID)
        UserActivity.fetchActivity(listId: pickedListID) { (userActs:[UserActivity]?, error: Error?) in
            if error == nil{
                if let userActs = userActs{
                    self.userActsInUserList = userActs
                }
            }
            
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userListsPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let list = userListsPicker[row]
        let listName = list["name"]
        return listName
    }
    
    
    
    @IBAction func onDoneAdding(_ sender: UIButton) {
        doneBtn.isHidden = true
        addBtn.isHidden = false
        cancelBtn.isHidden = false
        viewWithPicker.isHidden = true
    }
    
    
    @IBAction func onAddingThisAct(_ sender: UIButton) {
        print("on adding this act in listdetails")
        print("adding Act to list")
        if pickerRow == 0 {
            print("please pick a list")
            let alertController = UIAlertController(title: "Add Error", message: "Pick a List to add your item." , preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        } else if pickerRow != 0 {
            self.checkDuplicate( type: "Act", done: { (duplicate: Int) in
                print("list detail vc: duplicate", duplicate)
                if duplicate > 0 {
                    self.viewWithPicker.isHidden = true
                    let alertController = UIAlertController(title: "Can't Add Activity", message: "You already have this item in your list. Please add a different item." , preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
                    alertController.addAction(cancelAction)
                    let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true)
                    
                } else  if duplicate == 0 {
                    
                    print ("before UserAct.addnewact", self.addingActivity)
                    print("pickedListID", self.pickedListID)
                    List.fetchWithID(listID: self.pickedListID) { (lists: [List]?, error: Error?) in
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
            })
        }
    }
    
    
    func checkDuplicate(type: String, done: @escaping (Int) -> Void){
        if type == "Act"{
            var duplicate = 0
            for act in userActsInUserList {
                if act.activity.objectId == addingActivity.objectId{
                    duplicate += 1
                }
            }
            return done(duplicate)
        } else if type == "List"{
            var duplicate = 0
            for list in userLists {
                if list.objectId == addingList.objectId{
                    duplicate += 1
                }
            }
            return done(duplicate)
        }
        
    }
    
    
    @IBAction func onCancelAdding(_ sender: UIButton) {
        viewWithPicker.isHidden = true
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
                self.globalActsDictionary.append(curAct)
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
    
    
    func getLists() {
        let curUser = PFUser.current()
        let userId = curUser?.objectId
        self.addingList = list
        List.fetchLists(userId: userId!) { (lists: [List]?, error: Error?) in
            if lists?.count == 0 {
                //                self.noListsLabel.isHidden = false
                print("user has no lists yet")
            }
            else {
                if error == nil {
                    let lists = lists!
                    self.userLists = lists
                    
                    print("iiiii list",lists)
                    var allOptions = [[String : String]]()
                    var listIDsArr = [String]()
                    for list in lists{
                        listIDsArr.append(list.objectId!)
                    }
                    let defaultOne = ["name" : "Choose List to add", "id": "no id"]
                    
                    allOptions.append(defaultOne )
                    
                    for list in lists{
                        let option : [String : String]
                        let id = list.objectId
                        option = ["name" : list.listName , "id": id ] as! [String : String]
                        allOptions.append(option)
                    }
                    self.userListsPicker = allOptions
                    self.listPicker.reloadAllComponents()
                } else {
                    print("\(error?.localizedDescription)")
                }
            }
        }
    }
    
    func emptyListAlert(){
        let addConfirmation = UIAlertController(title: "Empty List" , message: "Cannot add empty list", preferredStyle: .alert)
        //            let OKaction = UIAlertAction(title: "Add", style: .default ){ (action) in }
        //            addConfirmation.addAction(OKaction)
        let cancelBtn = UIAlertAction(title: "Ok", style: .cancel){ (action) in }
        addConfirmation.addAction(cancelBtn)
        self.present(addConfirmation, animated: true)
    }
    
    
    @IBAction func copyList(_ sender: Any) {
        
        self.checkDuplicate(type: "List") { (duplicate) in
            if duplicate > 0 {
                let alertController = UIAlertController(title: "Can't Add List", message: "You already have list." , preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            } else if duplicate == 0 {
                let actsInList = self.list.activities
                //        print("actInList", actsInList!)
                if let actInLists = actsInList{
                    let addConfirmation = UIAlertController(title: "Adding List" , message: "Add this list to your profile?", preferredStyle: .actionSheet)
                    let OKaction = UIAlertAction(title: "Add", style: .default ){ (action) in
                        List.addNewList(name: self.list.listName, category: self.list.category, likeCount: 0, activities: actsInList) { (addedList: List?, error: Error?) in
                            if (addedList != nil) {
                                print("List created!")
                                print("copy list", addedList!)
                                
                                for act in self.globalActivities {
                                    UserActivity.addNewActivity(activity: act, list: addedList, completion: { (userAct: UserActivity?, error: Error?) in
                                        if error == nil {
                                            print ("userAct", userAct!)
                                            let addingAlert = UIAlertController(title: "Add Message", message:"Successfully Added List" , preferredStyle: .alert)
                                            let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                                            addingAlert.addAction(OKAction)
                                            self.present(addingAlert, animated: true)
                                        }
                                    })
                                }
                                self.dismiss(animated: true, completion: nil)
                            } else if let error = error {
                                print("Problem saving list: \(error.localizedDescription)")
                                let addingAlert = UIAlertController(title: "Add Message", message:"Error: \(error.localizedDescription)" , preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                                addingAlert.addAction(OKAction)
                                self.present(addingAlert, animated: true)
                            }
                        }
                    }
                    addConfirmation.addAction(OKaction)
                    let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel){ (action) in }
                    addConfirmation.addAction(cancelBtn)
                    self.present(addConfirmation, animated: true)
                } else {
                    self.emptyListAlert()
                }
            }
            }
        }

}

