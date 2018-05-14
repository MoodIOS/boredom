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

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, InfoListButtonDelegate, InfoActButtonDelegate {


    

    @IBOutlet weak var recentlyAddedBtn: UIButton!
    @IBOutlet weak var mostlyLikedBtn: UIButton!
    
    @IBOutlet weak var listsLabel: UILabel!
    
    @IBOutlet weak var activitiesLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    @IBOutlet weak var userListsCollectionView: UICollectionView!
//    var movies: [[String:Any]] = []
    var exploreActivities: [Activity]!
    var exploreLists: [List]!
    
//    var activitiesYelp: [Business]!
    var top10List: [List]! = []
    var top10Act: [Activity]! = []
    var tags: [String] = ["Restaurant", "Brunch", "Movie", "Outdoor", "Book", "Coffee", "Nightlife", "Happy hours"]
    var bgURL: [String] = ["https://i.imgur.com/2GOE7w9.png", "https://imgur.com/spLeglN.png", "https://imgur.com/SVdeXmg.png", "https://imgur.com/es6rQag.png", "https://imgur.com/VrD2OI3.png", "https://imgur.com/HkECUoG.png", "https://imgur.com/J8lQzBz.png", "https://imgur.com/jpdbJvU.png", "https://imgur.com/3Qm9GDx.png"]
    var index1 = [Int]()
    var index2 = [Int]()
    var bgUrlAct = [URL]()
    var bgUrlList = [URL]()
    
    var tableIndex1:Bool!
    var tableIndex2:Bool!
    var selectedIndexInTable:IndexPath!
    var tableCell: ExploreTableViewCell!
    var colView1 : UICollectionView!
    
    var infoForIndex: NSIndexPath! = nil
    var popup: PopupDialog!
    
    var actsIdLiked = [String]()
    var listsIdLiked = [String]()
    
    var recentlyAddedBtnClicked:Bool!
    var mostlyLikedBtnClicked:Bool!
    
    
    @IBOutlet weak var searchScrolView: UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userListsCollectionView.backgroundColor = UIColor.clear
        activitiesCollectionView.backgroundColor = UIColor.clear
        recentlyAddedBtn.backgroundColor = UIColor.gray
        
        mostlyLikedBtnClicked = true
        
        listsLabel.text = "Top 10 Lists"
        activitiesLabel.text = "Top 10 Activities"
        
        
        //view.addSubview(tableView)
       // tableView.dataSource = self
       // tableView.delegate = self
       // tableView.rowHeight = 200
       // tableView.reloadData()
        
        //colView1 = table
        userListsCollectionView.dataSource = self
        activitiesCollectionView.dataSource = self
        
        //self.userListsCollectionView.isScrollEnabled = true
        
        
        //activitiesCollectionView.backgroundView?.tintColor = UIColor.white
        
        //self.view.addSubview(userListsCollectionView)
        //self.view.addSubview(activitiesCollectionView)
        
       let layout = userListsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 0
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: 120, height: 120)
        
        let layoutActivities = activitiesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutActivities.minimumInteritemSpacing = 2
        layoutActivities.minimumLineSpacing = 0
        let cellsPerLineActivities: CGFloat = 2
        let interItemSpacingTotalActivities = layoutActivities.minimumInteritemSpacing * (cellsPerLineActivities - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layoutActivities.itemSize = CGSize(width: 120, height: 120)
        
        getTopLists()
        getTopActivities()
        
        let curUser = User.current()
        self.actsIdLiked = (curUser?.likedActivities)!
        self.listsIdLiked = (curUser?.likedLists)!

    }
    
    @IBAction func didTapRecentlyAdded(_ sender: Any) {
        print("inside recently tapped-------------------------")
        recentlyAddedBtn.backgroundColor = UIColor.blue
        mostlyLikedBtn.backgroundColor = UIColor.gray
        recentlyAddedBtnClicked = true
        listsLabel.text = "Recently Added Lists"
        activitiesLabel.text = "Recently Added Activities"
        getRecentActivities()
        getRecentLists()
        
        
    }
    
    @IBAction func didTapMostlyLiked(_ sender: Any) {
        print("inside mostly liked tapped-------------------------")
        mostlyLikedBtn.backgroundColor = UIColor.blue
        recentlyAddedBtn.backgroundColor = UIColor.gray
        mostlyLikedBtnClicked = true
        listsLabel.text = "Top 10 Lists"
        activitiesLabel.text = "Top 10 Activities"
        getTopActivities()
        getTopLists()
        
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == activitiesCollectionView){
            return top10Act.count
        }
        else if(collectionView == userListsCollectionView){
            return top10List.count
        }
        else {
            //return tagsCollectionView count... just returning 10 for now, you can change that :)
            return tags.count
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.userListsCollectionView){
             let cell = userListsCollectionView.dequeueReusableCell(withReuseIdentifier: "UserListsCell", for: indexPath) as! UserListsCell
             let list = top10List[indexPath.item]
            cell.delegate = self
            cell.indexPath = indexPath
            cell.listName.text = list.listName
            cell.listId = list.objectId
            cell.listsUserLiked = self.listsIdLiked
            //randomize bg
            while bgUrlList.count < 11 {
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
        else if (collectionView == self.activitiesCollectionView){ //uncomment this line once you add the else case below..
//        else{
            let activitiesCell = activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "ActivitiesCell", for: indexPath) as! ActivitiesCell
            activitiesCell.delegate = self
            activitiesCell.indexPath = indexPath
            let act = top10Act[indexPath.item]
            activitiesCell.activityName.text = act.actName ?? "Label"
            activitiesCell.actId = act.objectId
            activitiesCell.actsIdLike = self.actsIdLiked
            while bgUrlAct.count < 11 {
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
            let tagsCell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: "TagBtnCell", for: indexPath) as! TagsCollectionViewCell
            print("tags[indexPath.item]",tags[indexPath.item])
            tagsCell.tagBtn.setTitle(tags[indexPath.item], for: .normal)
            return tagsCell
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let activityCell = sender as! UICollectionViewCell
        let listCell = sender as! UICollectionViewCell
        if let indexPath = activitiesCollectionView.indexPath(for: activityCell){
            let activity = top10Act[indexPath.item]
            print(activity)
            let activityDetailViewController = segue.destination as! ActivitiesDetailViewController
            print(activity)
            activityDetailViewController.activity = activity
        }
        else if let indexPath = userListsCollectionView.indexPath(for: listCell){
            let list = top10List[indexPath.item]
            let listDetailViewController = segue.destination as! ListsDetailViewController
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

        
    func likeBtnClicked(at index: IndexPath, type: String, btn: UIButton){
        print("like clicked")
        if type == "List"{
            let likeBtn = btn.imageView?.image
            let like = UIImage(named:"heart-gray")
            let unlike = UIImage(named:"heart-red")
            if (likeBtn?.isEqual(like))! {
                
            } else if (likeBtn?.isEqual(unlike))!{
                
            }
        } else if type == "Act"{
            
        }
    }
    
    func addBtnClicked (at index: IndexPath, type: String){
        print("add clicked")
        if type == "List"{
            
        } else if type == "Act"{
            
        }
    }
    
    func infoBtnClicked(at index: IndexPath, type: String){
        print("info clicked")
        if type == "List" {
            let info = self.top10List[index.row]
            print("info list",info)
            let title = "\(info.listName!)"
            let message = """
            Category: \(info.category!)
            \(info.likeCount) likes
            """
            let image = UIImage(named: "pexels-photo-103290")
            self.popup = PopupDialog(title: title, message: message , image: image)
            // Create buttons
            let okBtn = CancelButton(title: "OK") {
                print("You canceled the car dialog.")
            }
            let likeBtn = DefaultButton(title: "") {
                //like this activity
                print("like this item")
            }
            //check if User has already like this activity
            likeBtn.setImage(#imageLiteral(resourceName: "heart-gray"), for: .normal)
            let addBtn = DefaultButton(title: "") {
                print("add this item")
            }
            addBtn.setImage(#imageLiteral(resourceName: "add"), for: .normal)
            popup.addButtons([likeBtn, okBtn, addBtn])
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
            let likeBtn = DefaultButton(title: "") {
                //like this activity
                print("like this item")
            }
            //check if User has already like this activity
            likeBtn.setImage(#imageLiteral(resourceName: "heart-gray"), for: .normal)
            let addBtn = DefaultButton(title: "") {
                print("add this item")
            }
            addBtn.setImage(#imageLiteral(resourceName: "add"), for: .normal)
            popup.addButtons([likeBtn, okBtn, addBtn])
            popup.buttonAlignment = .horizontal
            
            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        getTopLists()
        getTopActivities()

        infoForIndex = nil
        let curUser = User.current()
        self.actsIdLiked = (curUser?.likedActivities)!
        self.listsIdLiked = (curUser?.likedLists)!
    }
    
    
    func getTopLists(){
        List.fetchLists { (lists: [List]?, error: Error?) in
            if error == nil && lists != nil {
                self.exploreLists = lists
                let lists = lists
                self.top10List = [List]()
                var i = 0
                while i < 10 {
                    let list = lists![i]
                    print("listLikecount", lists![i].likeCount)
                    print("top list", i)
                    print(list)
                    self.top10List.append(list)
                    print("~~~~~~~~~~~~~~~~~~~", self.top10List)
                    self.userListsCollectionView.reloadData()
                    //self.tableView.reloadData()
                    i = i + 1
                }
            }
        }
    }
    
    func getRecentLists(){
        List.fetchRecentLists{(lists: [List]?, error: Error?) in
            if error == nil && lists != nil {
                self.exploreLists = lists
                let lists = lists
                self.top10List = [List]()
                var i = 0
                while i < 10 {
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
    
    func getTopActivities() {
        Activity.fetchActivity{ (activities: [Activity]?, error: Error?) in
            if error == nil {
                self.exploreActivities = activities
                if self.exploreActivities != nil {
                    self.exploreActivities = activities
                    let activities = activities
                    self.top10Act = [Activity]()
                    var i = 0
                    while i < 10{
                        print("activityLikeCount", activities![i].activityLikeCount)
                        let act = activities![i]
                        self.top10Act.append(act)
                        print("~~~~~~~~~~~~~~~~~~~", self.top10Act)
                        self.activitiesCollectionView.reloadData()
                        //self.tableView.reloadData()
                        i = i + 1
                    }
                } else {
                    print("No Top Activity Available")
                }
            }
            else{
                print(error?.localizedDescription)
            }
        }
    }
    
    func getRecentActivities() {
        Activity.fetchRecentActivity{ (activities: [Activity]?, error: Error?) in
            if error == nil {
                self.exploreActivities = activities
                if self.exploreActivities != nil {
                    self.exploreActivities = activities
                    let activities = activities
                    self.top10Act = [Activity]()
                    var i = 0
                    while i < 10{
                        print("activityLikeCount", activities![i].activityLikeCount)
                        let act = activities![i]
                        self.top10Act.append(act)
                        print("~~~~~~~~~~recent activities~~~~~~~~~", self.top10Act)
                        self.activitiesCollectionView.reloadData()
                        //self.tableView.reloadData()
                        i = i + 1
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    

}
