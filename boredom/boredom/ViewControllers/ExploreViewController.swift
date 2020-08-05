//
//  ExploreViewController.swift
//  boredom
//
//  Created by jsood on 4/7/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import PromiseKit
import PopupDialog



class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, InfoListButtonDelegate, InfoActButtonDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TagsCollectionViewCellDelegate {
  
    
    
    @IBOutlet weak var recentlyAddedBtn: UIButton!
    @IBOutlet weak var mostlyLikedBtn: UIButton!
    
    @IBOutlet weak var listsLabel: UILabel!
    
    @IBOutlet weak var activitiesLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    @IBOutlet weak var userListsCollectionView: UICollectionView!

    @IBOutlet weak var viewWithPicker: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    var itemForPickerView = [List]()
//        [[String : String]]()
//    var pickedList = List()
    var pickedListID = String()
    var addingActivity = Activity()
    
    var exploreActivities: [Activity]!
    var exploreLists: [List]!
    
    var allRecentActs = [Activity]()
    var allRecentLists = [List]()
    var allLikedActs = [Activity]()
    var allLikedLists = [List]()
    
    var itemForPickerview = [[String : String]]()
    var pickerRow = Int()
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    // to check duplicate to user act in list:
    var userActsInUserList = [UserActivity]()
    var addingList = List()
    
//    var activitiesYelp: [Business]!
    var top10List: [List]! = []
    var top10Act: [Activity]! = []
    var tags: [String] = ["Restaurant", "Brunch", "Movie", "Outdoor", "Book", "Coffee", "Nightlife", "Happy hours"]
    var tagsBool =  [String: Bool]()
    var bgURL: [String] = ["https://i.imgur.com/2GOE7w9.png", "https://imgur.com/spLeglN.png", "https://imgur.com/SVdeXmg.png", "https://imgur.com/es6rQag.png", "https://imgur.com/VrD2OI3.png", "https://imgur.com/HkECUoG.png", "https://imgur.com/J8lQzBz.png", "https://imgur.com/jpdbJvU.png", "https://imgur.com/3Qm9GDx.png"]
    var index1 = [Int]()
    var index2 = [Int]()
    var bgUrlAct = [URL]()
    var bgUrlList = [URL]()
    var firstLoad = 0
    var tableIndex1:Bool!
    var tableIndex2:Bool!
    var selectedIndexInTable:IndexPath!
    var tableCell: ExploreTableViewCell!
    var colView1 : UICollectionView!
    
    var globalAct = [Activity]()
    var userLists = [List]()
    
    var infoForIndex: NSIndexPath! = nil
    var popup: PopupDialog!
    
    var actsIdLiked = [String]()
    var listsIdLiked = [String]()
    
    var recentlyAddedBtnClicked:Bool!
    var mostlyLikedBtnClicked:Bool!
    
    
    @IBOutlet weak var searchScrolView: UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentlyAddedBtn.backgroundColor = UIColor.gray
        mostlyLikedBtn.backgroundColor = UIColor(displayP3Red: 139/255, green: 22/255, blue: 1.0, alpha: 1.0)
        userListsCollectionView.backgroundColor = UIColor.clear
        activitiesCollectionView.backgroundColor = UIColor.clear
        
        mostlyLikedBtnClicked = true
        
        listsLabel.text = "Top 10 Lists"
        activitiesLabel.text = "Top 10 Activities"
        
        doneBtn.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        doneBtn.layer.borderWidth = 1
        doneBtn.layer.borderColor = (UIColor.lightGray).cgColor
        cancelBtn.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = (UIColor.lightGray).cgColor
        addBtn.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        addBtn.layer.borderWidth = 1
        addBtn.layer.borderColor = (UIColor.lightGray).cgColor
        
        
        userListsCollectionView.dataSource = self
        activitiesCollectionView.dataSource = self
        tagsCollectionView.dataSource = self
        
        //self.userListsCollectionView.isScrollEnabled = true
        //activitiesCollectionView.backgroundView?.tintColor = UIColor.white
        //self.view.addSubview(userListsCollectionView)
        //self.view.addSubview(activitiesCollectionView)
        getLists()
        pickerView.dataSource = self
        pickerView.delegate = self
        viewWithPicker.isHidden = true

        
        self.tagsBool["Restaurant"] = false
        self.tagsBool["Brunch"] = false
        self.tagsBool["Movie"] = false
        self.tagsBool["Outdoor"] = false
        self.tagsBool["Book"] = false
        self.tagsBool["Coffee"] = false
        self.tagsBool["Nightlife"] = false
        self.tagsBool["Happy hours"] = false
        
        

        doneBtn.isHidden = true

        
       let layout = userListsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 0
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: 154, height: 154)
        
        let layoutActivities = activitiesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutActivities.minimumInteritemSpacing = 2
        layoutActivities.minimumLineSpacing = 0
        let cellsPerLineActivities: CGFloat = 2
        let interItemSpacingTotalActivities = layoutActivities.minimumInteritemSpacing * (cellsPerLineActivities - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layoutActivities.itemSize = CGSize(width: 154, height: 154)
        
        getTopLists()
        getTopActivities()
        
        
        let curUser = User.current()
        self.actsIdLiked = (curUser?.likedActivities)!
        self.listsIdLiked = (curUser?.likedLists)!

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        if(mostlyLikedBtn.backgroundColor == UIColor.gray){
            var filterTags = 0
            for (_, value) in tagsBool {
                if value == true {
                    filterTags += 1
                }
            }
            if filterTags == 0 {
                
                getRecentLists()
                getRecentActivities()
            } else {
                self.filterByTags()
            }

        }
        else {
            var filterTags = 0
            for (_, value) in tagsBool {
                if value == true {
                    filterTags += 1
                }
            }
            if filterTags == 0 {
                
                getTopLists()
                getTopActivities()
            } else {
                self.filterByTags()
            }
            
        }
        
        getLists()
        infoForIndex = nil
        let curUser = User.current()
        self.actsIdLiked = (curUser?.likedActivities)!
        self.listsIdLiked = (curUser?.likedLists)!
        
        if viewWithPicker.isHidden == false {
            doneBtn.isHidden = true
            addBtn.isHidden = false
            cancelBtn.isHidden = false
            
        }
        
        self.tagsBool["Restaurant"] = false
        self.tagsBool["Brunch"] = false
        self.tagsBool["Movie"] = false
        self.tagsBool["Outdoor"] = false
        self.tagsBool["Book"] = false
        self.tagsBool["Coffee"] = false
        self.tagsBool["Nightlife"] = false
        self.tagsBool["Happy hours"] = false
    }
    
    
    @IBAction func didTapRecentlyAdded(_ sender: Any) {
        print("inside recently tapped-------------------------")
        recentlyAddedBtn.backgroundColor = UIColor(displayP3Red: 139/255, green: 22/255, blue: 1.0, alpha: 1.0)
        mostlyLikedBtn.backgroundColor = UIColor.gray
        
        recentlyAddedBtnClicked = true
        listsLabel.text = "Recently Added Lists"
        activitiesLabel.text = "Recently Added Activities"

        var filterTags = 0
        for (_, value) in tagsBool {
            if value == true {
                filterTags += 1
            }
        }
        if filterTags == 0 {
            
            getRecentLists()
            getRecentActivities()
        } else {
            self.filterByTags()
        }

        
    }
    
    @IBAction func didTapMostlyLiked(_ sender: Any) {
        print("inside mostly liked tapped-------------------------")
        mostlyLikedBtn.backgroundColor = UIColor(displayP3Red: 139/255, green: 22/255, blue: 1.0, alpha: 1.0)
        recentlyAddedBtn.backgroundColor = UIColor.gray
        mostlyLikedBtnClicked = true
        listsLabel.text = "Top 10 Lists"
        activitiesLabel.text = "Top 10 Activities"

        
        var filterTags = 0
        for (_, value) in tagsBool {
            if value == true {
                filterTags += 1
            }
        }
        if filterTags == 0 {
            
            getTopLists()
            getTopActivities()
        } else {
            self.filterByTags()
        }
        
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == activitiesCollectionView){
            return top10Act.count
        }
        else if(collectionView == userListsCollectionView){
            return top10List.count
        }
        else {
            return 8
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.userListsCollectionView){
            let cell = userListsCollectionView.dequeueReusableCell(withReuseIdentifier: "UserListsCell", for: indexPath) as! UserListsCell
            let list = top10List[indexPath.item]
            var globalAct = [Activity]()
            UserActivity.fetchActivity(listId: list.objectId!) { (userActivities:[UserActivity]?, error: Error?) in
                if error == nil {
                    print("userActivities", userActivities!)
                    for userAct in userActivities! {
                        let act = userAct.activity
                        globalAct.append(act!)
                    }
                    cell.userActs = userActivities!
                    cell.globalActs = globalAct
                }
            }
            cell.delegate = self
            cell.indexPath = indexPath
            cell.currentList = list
            cell.listName.text = list.listName
            cell.listId = list.objectId
            cell.listsUserLiked = self.listsIdLiked
            cell.backgroundColor?.withAlphaComponent(0.5)
            //randomize bg
            var count = 11
            if(self.top10Act.count != nil)
            {
                count = self.top10List.count
            }
            while bgUrlList.count < count {
                 let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)))
                 let background = bgURL[randomindex]
                 let backgroundURL = URL(string: background)
                 bgUrlList.append(backgroundURL!)
             }
            let backgroundURL = bgUrlList[indexPath.item]
            cell.userListsImageView.af_setImage(withURL: backgroundURL)
            //check if user liked this:
            print("listsIdLiked", listsIdLiked)
            var liked: Int = 0
            var i = 0
            
            while i < listsIdLiked.count{
                let id = listsIdLiked[i]
                if id == list.objectId {
                    liked = liked + 1
                }
                i = i + 1
            }
            
            if liked == 0 {
                cell.likeBtn.setImage(UIImage(named: "heart-white"), for: .normal)
            } else if liked > 0 {
                cell.likeBtn.setImage(UIImage(named: "heart-red"), for: .normal)
            }
            


            return cell
        }
        else if (collectionView == self.activitiesCollectionView){

            let activitiesCell = activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "ActivitiesCell", for: indexPath) as! ActivitiesCell
            activitiesCell.delegate = self
            activitiesCell.indexPath = indexPath
            let act = top10Act[indexPath.item]
            activitiesCell.activityName.text = act.actName ?? "Label"
            activitiesCell.actId = act.objectId
            activitiesCell.actsIdLike = self.actsIdLiked
            activitiesCell.currentAct = act
            var count = 11
            if(self.top10Act.count != nil)
            {
                count = self.top10Act.count
            }
            
            while bgUrlAct.count < count {
                
                let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)))
                let background = bgURL[randomindex]
                let backgroundURL = URL(string: background)
                bgUrlAct.append(backgroundURL!)
            }
            
            let backgroundURL = bgUrlAct[indexPath.item]
            activitiesCell.activitiesImageView.af_setImage(withURL: backgroundURL)
            
            print("listsIdLiked", actsIdLiked)
            var liked: Int = 0
            var i = 0
            
            while i < actsIdLiked.count{
                let id = actsIdLiked[i]
                if id == act.objectId {
                    liked = liked + 1
                }
                i = i + 1
            }
            
            if liked == 0 {
                activitiesCell.likeBtn.setImage(UIImage(named: "heart-white"), for: .normal)
            } else if liked > 0 {
                activitiesCell.likeBtn.setImage(UIImage(named: "heart-red"), for: .normal)
            }
            
            return activitiesCell
        
        } else {
            let tagsCell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionView", for: indexPath) as! TagsCollectionViewCell
            print("tags[indexPath.item]",tags[indexPath.item])
            
            let tagName = tags[indexPath.item]
            tagsCell.tagBtn.setTitle(tagName, for: .normal)
            tagsCell.delegate = self
            
            //handleTagsFilter(button: tagsCell.tagBtn)
            //tagsCell.onTapTagBtn(getTagActivities())
            //activitiesCollectionView.reloadData()
            for (tag, value) in self.tagsBool {
                if (value == true) && (tagsCell.tagBtn.currentTitle == tag)  {
                    tagsCell.tagBtn.backgroundColor = UIColor(displayP3Red: 255/255, green: 193/255, blue: 0.0, alpha: 1.0)
                    
                } else if (value == false) && (tagsCell.tagBtn.currentTitle == tag) {
                    tagsCell.tagBtn.backgroundColor = UIColor.darkGray
                    
                }
            }
            return tagsCell
        }
    }
    
   

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let activityCell = sender as! UICollectionViewCell
        let listCell = sender as! UICollectionViewCell
//        let listDetails = sender as! UIViewController
        if let indexPath = activitiesCollectionView.indexPath(for: activityCell){
            let activity = top10Act[indexPath.item]
            print(activity)
            let activityDetailViewController = segue.destination as! ActivitiesDetailViewController
            print(activity)
            activityDetailViewController.activity = activity
        }
        else if let indexPath = userListsCollectionView.indexPath(for: listCell){
            let list = top10List[indexPath.item]
            let navVC = segue.destination as! UINavigationController
            let listDetailViewController = navVC.topViewController as! ListsDetailViewController
            listDetailViewController.list = list
            listDetailViewController.authorOfList = list.author
            UserActivity.fetchActivity(listId: list.objectId!) { (userActivities:[UserActivity]?, error: Error?) in
                if error == nil {
                    print("userActivities", userActivities!)
                    for userAct in userActivities! {
                        let globalAct = userAct.activity
                        
                        listDetailViewController.globalActivities.append(globalAct!)
                    }
                    
                }
            }
        }
        
    }
    
    func handleTagsFilter(button : UIButton){
        print("button sender ", button.backgroundColor!)

        handleTags(tagName: button.currentTitle!) { (tags: [String: Bool]?, error: Error?) in
            for (tag, value) in tags!{
                if (value == true) && (button.currentTitle == tag)  {
                    button.backgroundColor = UIColor(displayP3Red: 255/255, green: 193/255, blue: 0.0, alpha: 1.0)
//                    self.tagsCollectionView.reloadData()
                } else if (value == false) && (button.currentTitle == tag) {
                    button.backgroundColor = UIColor.darkGray
//                    self.tagsCollectionView.reloadData()
                }
            }
        }
    }

    func handleTags (tagName: String, completion: @escaping ([String:Bool]?, Error? ) -> Void){
        print("handleTag: ", tagName)
        if tagsBool[tagName] == false || tagsBool[tagName] == nil {
            tagsBool[tagName] = true
        } else if tagsBool[tagName] == true {
            tagsBool[tagName] = false
        }
        print("tags: ", tags)
        print("tagsBool", tagsBool)
        
        if(mostlyLikedBtn.backgroundColor == UIColor.gray){
            var filterTags = 0
            for (_, value) in tagsBool {
                if value == true {
                    filterTags += 1
                }
            }
            
            if filterTags == 0 {
                
                getRecentLists()
                getRecentActivities()
            } else {
                self.filterByTags()
            }
            
        }
        else {
            var filterTags = 0
            for (_, value) in tagsBool {
                if value == true {
                    filterTags += 1
                }
            }
            if filterTags == 0 {
                
                getTopLists()
                getTopActivities()
            } else {
                self.filterByTags()
            }
            
        }

        return completion(tagsBool, nil)

    }
    
    func filterByTags(){
        if(mostlyLikedBtn.backgroundColor == UIColor.gray){
            // In Recently Added
            print("allRecentLists","allRecentActs" )
            if (self.allRecentLists != []) && (self.allRecentActs != []){
                print("----------------------------", top10Act.count)
                print("------------------------------")

                self.top10List.removeAll()
                self.top10Act.removeAll()
                
                print("----------------------------later---------------", top10Act.count)

                var activities = [Activity]()
                var lists = [List]()
                
                for list in self.allRecentLists {
                    lists.append(list)
                }
                for act in self.allRecentActs {
                    activities.append(act)
                }
                
                for list in lists {
                    let listTag = list.tags
                    print("list.tag", list.tags)
                    // actTags is the tags that this current activity has
                    for (listTag, tagValue) in listTag! {
                        // want to loop actTags through tags in Explore and compare name
                        // if both equal true then add to user.exploreActivities
                        for (pickedTag, pickedTagValue) in self.tagsBool {
                            if listTag == pickedTag {
                                if (tagValue == true) && (pickedTagValue == true){
                                    if self.top10List.count > 0 {
                                        var duplicate = 0
                                        for addedList in self.top10List{
                                            if list == addedList{
                                                duplicate += 1
                                            }
                                            if duplicate == 0 {
                                                if self.top10List.count < 11{
                                                    self.top10List.append(list)
                                                }
                                                
                                            }
                                        }
                                    } else {
                                        if self.top10List.count < 11{
                                            self.top10List.append(list)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }

                for activity in activities {
                    let actTags = activity.tags
                    print("activity.tags", activity.tags)
                    // actTags is the tags that this current activity has
                    for (actTag, tagValue) in actTags! {
                        // want to loop actTags through tags in Explore and compare name
                        // if both equal true then add to user.exploreActivities
                        for (pickedTag, pickedTagValue) in self.tagsBool{
                            if actTag == pickedTag {
                                if (tagValue == true) && (pickedTagValue == true){
                                    if self.top10Act.count > 0 {
                                        var duplicate = 0
                                        for addedAct in self.top10Act{
                                            if  activity == addedAct {
                                                duplicate += 1
                                            }
                                        }
                                        if duplicate == 0 {
                                            if self.top10Act.count < 11{
                                                self.top10Act.append(activity)
                                            }
                                        }
                                    } else {
                                        if self.top10Act.count < 11{
                                            self.top10Act.append(activity)
                                        }
                                    }

                                }
                            }
                        }
                    }
                }
                print("After filtering self.exploreActivities", self.top10List)
                
                //filter recent acts and append into top10acts
                self.userListsCollectionView.reloadData()
                self.activitiesCollectionView.reloadData()
            }
        }
        else {
            // In most liked
            print("allLikedLists","allLikedActs" )
            if (self.allLikedLists != []) && (self.allLikedActs != []){
                //filter recent lists and append into top10lists
                self.top10List.removeAll()
                self.top10Act.removeAll()
                var activities = [Activity]()
                var lists = [List]()
                
                for list in self.allLikedLists {
                    lists.append(list)
                }
                for act in self.allLikedActs {
                    activities.append(act)
                }
                
                for list in lists {
                    let listTag = list.tags
                    print("list.tag", list.tags)
                    // actTags is the tags that this current activity has'
                    for (listTag, tagValue) in listTag! {
                        // want to loop actTags through tags in Explore and compare name
                        // if both equal true then add to user.exploreActivities
                        for (pickedTag, pickedTagValue) in self.tagsBool {
                            if listTag == pickedTag {
                                if (tagValue == true) && (pickedTagValue == true){
                                    if self.top10List.count > 0 {
                                        var duplicate = 0
                                        for addedList in self.top10List{
                                            if list == addedList{
                                                duplicate += 1
                                            }
                                        }
                                        if duplicate == 0 {
                                            if self.top10List.count < 11{
                                                self.top10List.append(list)
                                            }
                                            
                                        }
                                    } else {
                                        if self.top10List.count < 11{
                                            self.top10List.append(list)
                                        }
                                        
                                    }
                                    

                                }
                            }
                        }
                    }
                }
                
                for activity in activities {
                    let actTags = activity.tags
                    print("activity.tags", activity.tags)
                    // actTags is the tags that this current activity has
                    for (actTag, tagValue) in actTags! {
                        // want to loop actTags through tags in Explore and compare name
                        // if both equal true then add to user.exploreActivities
                        for (pickedTag, pickedTagValue) in self.tagsBool{
                            if actTag == pickedTag {
                                if (tagValue == true) && (pickedTagValue == true){
                                    if self.top10Act.count > 0{
                                        var duplicate = 0
                                        for addedAct in self.top10Act{
                                            if  activity == addedAct {
                                                duplicate += 1
                                            }
                                        }
                                        if duplicate == 0 {
                                            if self.top10Act.count < 11 {
                                                self.top10Act.append(activity)
                                            }
                                            
                                        }
                                    } else {
                                        if self.top10Act.count < 11{
                                            self.top10Act.append(activity)
                                        }
                                    }
                                    

                                }
                            }
                        }
                    }
                }
                print("After filtering self.exploreActivities", self.top10List)
                
                //filter recent acts and append into top10acts
                self.userListsCollectionView.reloadData()
                self.activitiesCollectionView.reloadData()
            }

        }
        
    }
    
    // adding List to account
    func addBtnClicked (actsInList: [UserActivity], currentList: List, globalActs: [Activity]){
        let actInList = currentList.activities
        if actsInList != [] {
//            print("actInList Explore:", actsInList)
            let addConfirmation = UIAlertController(title: "Adding List" , message: "Add this list to your profile?", preferredStyle: .actionSheet)
            let OKaction = UIAlertAction(title: "Add", style: .default ){ (action) in
                self.checkDuplicate(addingList: currentList, done: { (duplicate) in
                    if duplicate > 0 {
                        let alertController = UIAlertController(title: "Can't Add List", message: "You already have this list." , preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true)
                    } else if duplicate == 0{
                        List.addNewList(name: currentList.listName, category: currentList.category, likeCount: 0, activities: actsInList) { (addedList: List?, error: Error?) in
                            if (addedList != nil) {
//                                print("List created!")
//                                print("copy list", addedList!)
//                                print("Add Btn globalAct", globalActs)
                                for act in globalActs {
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
                            } else if let error = error {
                                let addingAlert = UIAlertController(title: "Add Message", message:"Error: \(error.localizedDescription)" , preferredStyle: .alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                                addingAlert.addAction(OKAction)
                                self.present(addingAlert, animated: true)
                            }
                        }

                    }
                })
            }
            addConfirmation.addAction(OKaction)
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel){ (action) in }
            addConfirmation.addAction(cancelBtn)
            self.present(addConfirmation, animated: true)
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
        }
    }
    
    func checkDuplicate(addingList: List, done: @escaping (Int) -> Void){
        var duplicate = 0
        for list in userLists {
            if list.objectId == addingList.objectId{
                duplicate += 1
            }
        }
        return done(duplicate)
    }
    
    func emptyListAlert(){
        let addConfirmation = UIAlertController(title: "Empty List" , message: "Cannot add empty list", preferredStyle: .alert)
        //            let OKaction = UIAlertAction(title: "Add", style: .default ){ (action) in }
        //            addConfirmation.addAction(OKaction)
        let cancelBtn = UIAlertAction(title: "Ok", style: .cancel){ (action) in }
        addConfirmation.addAction(cancelBtn)
        self.present(addConfirmation, animated: true)
    }
    
    
    // adding act to a list
    func addBtnClicked (at index: IndexPath, type: String){
        print("add clicked")
        if type == "Act"{
            viewWithPicker.isHidden = false
            if viewWithPicker.isHidden == false {
                doneBtn.isHidden = true
                addBtn.isHidden = false
                cancelBtn.isHidden = false
                pickerView.selectRow(0, inComponent: 0, animated: false)
            }
            addingActivity = top10Act[index.row]
//            print("addingActivity", addingActivity)
        }
    }
    
    func infoBtnClicked(at index: IndexPath, type: String){
        print("info clicked")
        if type == "List" {
            let info = self.top10List[index.row]
            print("info list",info)
            let title = "\(info.listName!)"
            let message = """
            Description: \(info.listDescription!)
            \(info.likeCount) likes
            """
            let img = bgUrlList[index.row]
            let image = UIImage(named: "pexels-photo-103290")
            self.popup = PopupDialog(title: title, message: message , image: image)
            // Create buttons
            let okBtn = CancelButton(title: "OK") {
                print("You canceled the car dialog.")
            }

            popup.addButton(okBtn)
            popup.buttonAlignment = .horizontal
            
            self.present(popup, animated: true, completion: nil)
        } else if type == "Act" {
            let info = self.top10Act[index.row]
            print("info act", info)
            let title = "\(info.actName!)"
            let message = """
            Description: \(info.actDescription!)
            \(info.activityLikeCount) likes
            """
            let image = UIImage(named: "pexels-photo-103290")
            self.popup = PopupDialog(title: title, message: message , image: image)
            // Create buttons
            let okBtn = CancelButton(title: "OK") {
                print("You canceled the car dialog.")
            }
            popup.addButton(okBtn)

            popup.buttonAlignment = .horizontal
            
            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    
    
    func getTopLists(){
        List.fetchLists { (lists: [List]?, error: Error?) in
            if error == nil && lists! != [] {
                self.allLikedLists = lists!
                if lists! != [] {
                    self.exploreLists = lists
                    let lists = lists
                    self.top10List.removeAll()
                    var i = 0
                    if (lists?.count)! > 9 {
                        while i < 10 {
                            let list = lists![i]
//                            print("listLikecount", lists![i].likeCount)
                            print("top list", i)
                            print(list)
                            self.top10List.append(list)
//                            print("~~~~~~~~~~~~~~~~~~~", self.top10List)
                            self.userListsCollectionView.reloadData()
                            //self.tableView.reloadData()
                            i = i + 1
                        }
                    }else {
                        while i < lists!.count {
                            let list = lists![i]
//                            print("listLikecount", lists![i].likeCount)
//                            print("top list", i)
                            print(list)
                            self.top10List.append(list)
//                            print("----------------recent lists-----", self.top10List)
                            self.userListsCollectionView.reloadData()
                            //self.tableView.reloadData()
                            i = i + 1
                        }
                    }
                    
                }
            }
        }
    }
    
    func getRecentLists(){
        List.fetchRecentLists{(lists: [List]?, error: Error?) in
            if error == nil && lists! != [] {
                self.allRecentLists = lists!
                self.exploreLists = lists
                let lists = lists
                self.top10List.removeAll()
                var i = 0
                if (lists?.count)! > 9 {
                    while i < 10 {
                        let list = lists![i]
//                        print("listLikecount", lists![i].likeCount)
//                        print("top list", i)
                        print(list)
                        self.top10List.append(list)
                        print("----------------recent lists-----", self.top10List)
                        self.userListsCollectionView.reloadData()
                        //self.tableView.reloadData()
                        i = i + 1
                    }
                } else {
                    while i < lists!.count {
                        let list = lists![i]
                        print("listLikecount", lists![i].likeCount)
                        print("top list", i)
                        print(list)
                        self.top10List.append(list)
                        print("----------------recent lists-----", self.top10List)
                        self.userListsCollectionView.reloadData()
                        //self.tableView.reloadData()
                        i = i + 1
                    }
                }
            }
            
        }
    }
    
    func getTopActivities() {
        Activity.fetchActivity{ (activities: [Activity]?, error: Error?) in
            if error == nil {
                if activities! != [] {
                    self.top10Act = []
                    self.allLikedActs = activities!
                    self.exploreActivities = activities
                    if self.exploreActivities != nil {
                        self.exploreActivities = activities
                        let activities = activities
                        self.top10Act = [Activity]()
                        var i = 0
                        if activities!.count > 9 {
                            while i < 10 {
//                                print("activityLikeCount", activities![i].activityLikeCount)
                                let act = activities![i]
                                self.top10Act.append(act)
//                                print("~~~~~~~~~~~~~~~~~~~", self.top10Act)
                                self.activitiesCollectionView.reloadData()
                                //self.tableView.reloadData()
                                i = i + 1
                            }
                        }else {
                            self.top10Act = []
                            while i < activities!.count {
//                                print("activityLikeCount", activities![i].activityLikeCount)
                                let act = activities![i]
                                self.top10Act.append(act)
//                                print("~~~~~~~~~~~~~~~~~~~", self.top10Act)
                                self.activitiesCollectionView.reloadData()
                                //self.tableView.reloadData()
                                i = i + 1
                            }
                        }
                        
                    } else {
                        print("No Top Activity Available")
                    }
                }
            }
            else{
                print(error?.localizedDescription)
            }
        }
    }
    
    func getRecentActivities() {
        Activity.fetchRecentActivity{ (activities: [Activity]?, error: Error?) in
            if error == nil && activities! != [] {
                self.top10Act = []
                self.exploreActivities = activities
                self.allRecentActs = activities!
                if self.exploreActivities != nil {
                    self.exploreActivities = activities
                    let activities = activities
                    self.top10Act = [Activity]()
                    var i = 0
                    if (activities?.count)! > 9 {
                        while i < 10{
                            print("activityLikeCount", activities![i].activityLikeCount)
                            let act = activities![i]
                            self.top10Act.append(act)
                            print("~~~~~~~~~~recent activities~~~~~~~~~", self.top10Act)
                            self.activitiesCollectionView.reloadData()
                            //self.tableView.reloadData()
                            i = i + 1
                        }
                    }else {
                        self.top10Act = []
                        while i < activities!.count {
                            print("activityLikeCount", activities![i].activityLikeCount)
                            let act = activities![i]
                            self.top10Act.append(act)
                            print("~~~~~~~~~~~~~~~~~~~", self.top10Act)
                            self.activitiesCollectionView.reloadData()
                            //self.tableView.reloadData()
                            i = i + 1
                        }
                    }
                } else {
                    print("No Recent Activity Available")
                }
            }
            else{
                print(error?.localizedDescription)
            }
        }
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // make font white
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let list = itemForPickerview[row]
        let titleData = list["name"]
        let myTitle = NSAttributedString(string: titleData!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemForPickerview.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let list = itemForPickerview[row]
        let name = list["name"]
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let picked = itemForPickerview[row]
        self.pickedListID = picked["id"]!

        print("itemForPickerView", itemForPickerview)
        print("self.pickedList", self.pickedListID)
        self.pickerRow = row
        
        UserActivity.fetchActivity(listId: pickedListID) { (userActs:[UserActivity]?, error: Error?) in
            if error == nil{
                if let userActs = userActs{
                    self.userActsInUserList = userActs
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
        self.pickerRow = 0
        viewWithPicker.isHidden = true
        print("on done adding")
        
    }
    

    @IBAction func onAddingActToList(_ sender: UIButton) {
        print("on adding this act in listdetails")
        print("adding Act to list")
        if pickerRow == 0 {
            print("please pick a list")
            let alertController = UIAlertController(title: "Add Error", message: "Pick a List to add your item." , preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        } else if pickerRow != 0 {
            self.checkDuplicate(type: "Act", done: { (duplicate: Int) in
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
                    self.userLists = lists
                    //print("iiiii list",lists)
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
                    self.itemForPickerview = allOptions
//                    self.itemForPickerView = lists
                    self.pickerView.reloadAllComponents()
                } else {
                    print("\(error?.localizedDescription)")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }

    func handleLikedCell (likedId: String) {
//        print("likedID: ", likedId)
//        print("+++++++++++++++++++++")
//        print("self.actsIdLiked", self.actsIdLiked)
//        print("self.listsIdLiked", self.listsIdLiked)
        let curUser = User.current()
        self.actsIdLiked = (curUser?.likedActivities)!
        self.listsIdLiked = (curUser?.likedLists)!
//        print("++++++++++AFTER UPDATE+++++++++++")
//        print("self.actsIdLiked", self.actsIdLiked)
//        print("self.listsIdLiked", self.listsIdLiked)
        userListsCollectionView.reloadData()
        activitiesCollectionView.reloadData()
    }
    
    
    
}
