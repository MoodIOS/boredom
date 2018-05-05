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


class ExploreViewController: UIViewController, UICollectionViewDataSource{

    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    @IBOutlet weak var userListsCollectionView: UICollectionView!
    var movies: [[String:Any]] = []
    var exploreActivities: [Activity]!
    var exploreLists: [List]!
    var activitiesYelp: [Business]!
    var top10List: [List]! = []
    var top10Act: [Activity]! = []
    var bgURL: [String] = ["https://i.imgur.com/2GOE7w9.png", "https://imgur.com/spLeglN.png", "https://imgur.com/SVdeXmg.png", "https://imgur.com/es6rQag.png", "https://imgur.com/VrD2OI3.png", "https://imgur.com/HkECUoG.png", "https://imgur.com/J8lQzBz.png", "https://imgur.com/jpdbJvU.png", "https://imgur.com/3Qm9GDx.png"]
    var index1 = [Int]()
    var index2 = [Int]()
    var bgUrlAct = [URL]()
    var bgUrlList = [URL]()
    
    @IBOutlet weak var searchScrolView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTopLists()
        getTopActivities()
        
        userListsCollectionView.dataSource = self
        activitiesCollectionView.dataSource = self
        
        activitiesCollectionView.backgroundView?.tintColor = UIColor.white
        
        self.view.addSubview(userListsCollectionView)
        self.view.addSubview(activitiesCollectionView)
        
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        getTopLists()
        getTopActivities()
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
                    self.userListsCollectionView.reloadData()
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
                    //self.exploreActivities = activities
                    let activities = activities
                    self.top10Act = [Activity]()
                    var i = 0
                    while i < 10{
                        print("activityLikeCount", activities![i].activityLikeCount)
                        let act = activities![i]
                        self.top10Act.append(act)
                        self.activitiesCollectionView.reloadData()
                        i = i + 1
                    }
                } else {
                    print("No Top Activity Available")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == activitiesCollectionView){
            return top10Act.count
        }
        else{
            return top10List.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.userListsCollectionView){
            let cell = userListsCollectionView.dequeueReusableCell(withReuseIdentifier: "UserListsCell", for: indexPath) as! UserListsCell
            let list = top10List[indexPath.item]
            cell.listName.text = list.listName
            
            while bgUrlList.count < 11 {
                let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)))
                let background = bgURL[randomindex]
                let backgroundURL = URL(string: background)
                bgUrlList.append(backgroundURL!)
            }
            let backgroundURL = bgUrlList[indexPath.item]
            cell.userListsImageView.af_setImage(withURL: backgroundURL)
        
            return cell
        }
        
        else{
            let activitiesCell = activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "ActivitiesCell", for: indexPath) as! ActivitiesCell
            let act = top10Act[indexPath.item]
            activitiesCell.activityName.text = act.actName ?? "Label"
            while bgUrlAct.count < 11 {
                let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)))
                let background = bgURL[randomindex]
                let backgroundURL = URL(string: background)
                bgUrlAct.append(backgroundURL!)
            }
            let backgroundURL = bgUrlAct[indexPath.item]
            activitiesCell.activitiesImageView.af_setImage(withURL: backgroundURL)

            return activitiesCell
        }
        
    }
    
    // ACTION OUTLETS
//    func clickedOnTags(_ sender: UIButton){
//        let button = sender
//        print("button sender ", button.backgroundColor!)
//        let blueColor = UIColor.init(red: 0, green: 122/255, blue:1 , alpha: 1)
//        let grayColor = UIColor.lightGray
//        print("blueColor", blueColor)
//        print("grayColor", grayColor)
//        handleTags(tagName: button.currentTitle!) { (tags: [String: Bool]?, error: Error?) in
//            for (tag, value) in tags!{
//                if (value == true) && (button.currentTitle == tag)  {
//                    button.backgroundColor = UIColor.init(red: 0, green: 122/255, blue:1 , alpha: 1)
//                } else if (value == false) && (button.currentTitle == tag) {
//                    button.backgroundColor = UIColor.lightGray
//                }
//            }
//        }
//    }
    
//    func handleTags (tagName: String, completion: @escaping ([String:Bool]?, Error? ) -> Void){
//        print("handleTag: ", tagName)
//        if tags[tagName] == false || tags[tagName] == nil {
//            tags[tagName] = true
//        } else {
//            tags[tagName] = false
//        }
//        print("tags: ", tags)
//        return completion(tags, nil)
//
//    }
//
//    // After users clicked on tags -> display only activities with tags
//    // Need a tag array to loop through
//    func filterActsWithTags(_: tagArray, _ :activities){
//        for tag in tagArray {
//            for act in activities {
//
//            }
//        }
//
//    }
    
    
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
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }
    
    
//    func randomizeBG (index: Int, nameArr: String){
//        let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)))
//        let randomLink = bgURL[randomindex]
//        if nameArr == "bgUrl1"{
//            self.bgUrl1.append(randomLink)
//        } else if nameArr == "bgUrL2" {
//            self.bgUrl2.append(randomLink)
//        }
//
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    

}
