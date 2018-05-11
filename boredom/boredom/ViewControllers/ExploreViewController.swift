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

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    @IBOutlet weak var userListsCollectionView: UICollectionView!
//    var movies: [[String:Any]] = []
    var exploreActivities: [Activity]!
    var exploreLists: [List]!
    
//    var activitiesYelp: [Business]!
    var top10List: [List]! = []
    var top10Act: [Activity]! = []
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
    
    var popup: PopupDialog!
    var actInfo: Activity!
    var likeActs: [Activity]!
    
    @IBOutlet weak var searchScrolView: UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userListsCollectionView.backgroundColor = UIColor.clear
        activitiesCollectionView.backgroundColor = UIColor.clear
        
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
        popupSetup()
        self.present(popup, animated: true, completion: nil)
    }
    
    
    func popupSetup(){
//  https://github.com/Orderella/PopupDialog
        
        let title = "Name of Act/List"
        let message = """
                     Description:
                     Category:
                     """
        let image = UIImage(named: "pexels-photo-103290")
        
        // Create the dialog
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

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
   /* func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InsideTableCollectionViewCell", for: indexPath) as! InsideTableCollectionViewCell
        
        
        //        if(self.indexList == true && self.indexAct == false){
        while bgUrlList.count < 11 {
            let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)))
            let background = bgURL[randomindex]
            let backgroundURL = URL(string: background)
            bgUrlList.append(backgroundURL!)
        }
        let backgroundURL = bgUrlList[indexPath.item]
        cell.collectionImageView.af_setImage(withURL: backgroundURL)
        //            let curList = listArray
        //print("//////////////////////////////",self.listArray)
        cell.listOrActNameLabel.text = top10List[indexPath.item].listName
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.indexPathForSelectedRow?.row == 0){
            self.tableIndex1 = true
            self.selectedIndexInTable = indexPath
            //self.tableIndex2 = false
        }
        else{
            //self.tableIndex1 = false
            self.selectedIndexInTable = indexPath
            self.tableIndex2 = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableCell = tableView.dequeueReusableCell(withIdentifier: "ExploreTableViewCell") as! ExploreTableViewCell
        if(indexPath.row == 0){
            //getTopLists()
            print("##########################")
            
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
                        //----var colListArray =  self.tableCell.collectionViewVariable.listArray
                        //----colListArray?.append(list)
//                        self.top10List.append(list)
                        //----print("~~~~~~~~~~~~~~~~~~~", self.tableCell.collectionViewVariable.listArray)
                        //self.userListsCollectionView.reloadData()
                        //self.tableCell.insideTableCollectionView.
                       //-- self.tableCell.collectionViewVariable.indexAct = false
                       //-- self.tableCell.collectionViewVariable.indexList = true
                       //-- self.tableCell.insideTableCollectionView.reloadData()
                        self.tableView.reloadData()
                        i = i + 1
                        
                    }
                }
            }
            
        }
        else if(indexPath.row == 1){
            //getTopActivities()
            //---tableCell.collectionViewVariable.actArray = self.top10Act
            //tableCell.insideTableCollectionView.
            //---tableCell.collectionViewVariable.indexAct = true
            //----tableCell.collectionViewVariable.indexList = false
            //self.tableIndex1 = false
            //self.tableIndex2 = true
            //self.selectedIndexInTable = indexPath
            print("TOP TEN ACTIVITIES..........",self.top10Act)
            print("******************", tableCell.collectionViewVariable.actArray)
        }
        
        
        return tableCell
    }
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == activitiesCollectionView){
            return top10Act.count
        }
        else{
            return top10List.count
        }
        /*if(collectionView == activitiesCollectionView){
         return top10Act.count
         }
         else{
         return top10List.count
         }*/
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*let cellIndexPath:IndexPath = tableView.indexPathForSelectedRow!
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
            return cell*/
       // }
            
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
            //let act = top10Act[indexPath.item]
            //activitiesCell.activityName.text = act.actName ?? "Label"
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
                    print("~~~~~~~~~~~~~~~~~~~", self.top10List)
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
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.indexPathForSelectedRow?.row == 0){
            self.tableIndex1 = true
            self.tableIndex2 = false
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let activityCell = sender as! UICollectionViewCell
        let listCell = sender as! UICollectionViewCell
        //var tableViewCell: ExploreTableViewCell
        //var collectionViewCell: CollectionViewClass
        
      /* if(self.tableIndex1 == true && self.tableIndex2 == false){
        //print("tableIndex1...............and 2", self.tableIndex1, self.tableIndex2)
        //tableViewCell = tableView(tableView, cellForRowAt: self.selectedIndexInTable) as! ExploreTableViewCell
        //collectionViewCell = collectionView(collectionViewCell, cellForItemAt: self.)
            print("=======================", self.selectedIndexInTable.row)
            if let indexPath = self.tableCell.insideTableCollectionView.indexPath(for: listCell){
               // print("INSIDE INDEXPATH IF CONDITION!!!!!!!!!!!!!!!!!!")
                let list = top10List[indexPath.row]
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
            }*/
        //}
        
        
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
