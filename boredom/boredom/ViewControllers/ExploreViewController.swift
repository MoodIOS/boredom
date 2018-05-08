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


class ExploreViewController: UIViewController, UITableViewDataSource, UICollectionViewDelegate, UITableViewDelegate{

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 150
        tableView.reloadData()
        
        print("----------------------", top10List)
        
        //userListsCollectionView.dataSource = self
        //activitiesCollectionView.dataSource = self
        
        //self.userListsCollectionView.isScrollEnabled = true
        
        
        //activitiesCollectionView.backgroundView?.tintColor = UIColor.white
        
        //self.view.addSubview(userListsCollectionView)
        //self.view.addSubview(activitiesCollectionView)
        
       /* let layout = tableViewCe.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 0
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: 120, height: 120)*/
        
        /*let layoutActivities = activitiesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutActivities.minimumInteritemSpacing = 2
        layoutActivities.minimumLineSpacing = 0
        let cellsPerLineActivities: CGFloat = 2
        let interItemSpacingTotalActivities = layoutActivities.minimumInteritemSpacing * (cellsPerLineActivities - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layoutActivities.itemSize = CGSize(width: 120, height: 120)*/
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "ExploreTableViewCell") as! ExploreTableViewCell
        /*if(indexPath.row == 0){
            //getTopLists()
            print("##########################")
            tableCell.listArray = self.top10List
        }
        else if(indexPath.row == 1){
            //getTopActivities()
            tableCell.actArray = self.top10Act
        }*/
        
        tableCell.actArray = self.top10Act
        tableCell.listArray = self.top10List
        return tableCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        
        /*if(collectionView == activitiesCollectionView){
         return top10Act.count
         }
         else{
         return top10List.count
         }*/
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIndexPath:IndexPath = tableView.indexPathForSelectedRow!
        let cellIndex:Int = cellIndexPath.row
        let tableViewCell = tableView.cellForRow(at: cellIndexPath) as! ExploreTableViewCell
        print("-------------", cellIndex, "-------------")
        let collectionView = tableViewCell.insideTableCollectionView
        
        if(cellIndex == 0){
            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!inside if")
            let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "InsideTableCollectionViewCell", for: indexPath) as! InsideTableCollectionViewCell
            let list = //tableViewCell.listArray[indexPath.item]
                top10List[indexPath.item]
            //cell.listName.text = list.listName
            
            while bgUrlList.count < 11 {
                let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)))
                let background = bgURL[randomindex]
                let backgroundURL = URL(string: background)
                bgUrlList.append(backgroundURL!)
            }
            let backgroundURL = bgUrlList[indexPath.item]
            //---------cell.collectionImageView.af_setImage(withURL: backgroundURL)
            //tableView.reloadData()
            let layout = tableViewCell.insideTableCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumInteritemSpacing = 2
            layout.minimumLineSpacing = 0
            let cellsPerLine: CGFloat = 2
            let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
            //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
            layout.itemSize = CGSize(width: 120, height: 120)
            collectionView?.reloadData()
            tableView.reloadData()
            return cell
        }
            
            /*if (collectionView == self.userListsCollectionView){
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
             }*/
            
        else{
            print("!!!!!!!!!!!!!!!!!!!!!!!inside else")
            let activitiesCell = collectionView?.dequeueReusableCell(withReuseIdentifier: "InsideTableCollectionViewCell", for: indexPath) as! InsideTableCollectionViewCell
            let act = tableViewCell.actArray[indexPath.item]
            //top10Act[indexPath.item]
            //activitiesCell.activityName.text = act.actName ?? "Label"
            while bgUrlAct.count < 11 {
                let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)))
                let background = bgURL[randomindex]
                let backgroundURL = URL(string: background)
                bgUrlAct.append(backgroundURL!)
            }
            let backgroundURL = bgUrlAct[indexPath.item]
            //--------activitiesCell.collectionImageView.af_setImage(withURL: backgroundURL)
            //tableView.reloadData()
            let layout = tableViewCell.insideTableCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumInteritemSpacing = 2
            layout.minimumLineSpacing = 0
            let cellsPerLine: CGFloat = 2
            let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
            //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
            layout.itemSize = CGSize(width: 120, height: 120)
            collectionView?.reloadData()
            tableView.reloadData()
            
            return activitiesCell
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        //getTopLists()
        //getTopActivities()
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
                    //self.userListsCollectionView.reloadData()
                    self.tableView.reloadData()
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
                        //self.activitiesCollectionView.reloadData()
                        self.tableView.reloadData()
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
