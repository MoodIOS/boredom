//
//  ProfileViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ListsInYourListDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var noListsLabel: UILabel!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    
    var lists = [List]()
    var addLists = [List]()
    var combinedLists = [List]()
    var combinedListsSet = Set<List>()
    var selectedLists = [List]()
    var selecting: Bool!
    var indexPaths = [IndexPath]()
    var itemCounts = Int()
    
    @IBAction func onEditBtn(_ sender: UIBarButtonItem) {
        let button = sender
        print("sender.title", button.title)
        if self.lists != [] {
            if editBtn.title == "Edit"  {
                editBtn.title = "Done"
                selecting = true
                colView.reloadData()
                
            } else {
                editBtn.title = "Edit"
                selecting = false
                colView.reloadData()
            }
            
        } else {
            editBtn.title = "Edit"
            selecting = false
            colView.reloadData()
        }
        
    }
    
    
    
    
    
    
    func handlingDeleteList(at index: IndexPath){
        
        if (index.row) < combinedLists.count{
            
            print("handlingDeleteList")
            print("[index.row]",[index.row])
            let list = self.lists[index.row]
            let listName = list.listName as String?
            let deletePermision = UIAlertController(title: "Delete List" , message: "Are you sure you want to delete \(listName ?? "this list")?", preferredStyle: .actionSheet)
            let OKAction = UIAlertAction(title: "Delete", style: .destructive){ (action) in
                print("deletinggggg....")
                self.colView.performBatchUpdates({
                    self.lists.remove(at: index.row)
                    self.colView.deleteItems(at: [index])
                    self.itemCounts -= 1
                    self.colView.reloadData()
                }, completion: { (success) in
                    if success {
                        print("successfully updated")
                        List.deleteList(deletingList: list, completion: { (list: List?, error:Error?) in
                            if error == nil{
                                print("deleted", list!)
                                self.getLists()
                                self.deleteUserActInList(list: list!)
                            } else {
                                print("\(String(describing: error?.localizedDescription))")
                            }
                        })
                    }
                })
                
            }
            
            deletePermision.addAction(OKAction)
            let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel){ (action) in }
            deletePermision.addAction(cancelBtn)
            self.present(deletePermision, animated: true)
        }
        
    }
    
    
    func deleteUserActInList(list: List){
        UserActivity.fetchActivity(listId: list.objectId!) { (userActs: [UserActivity]?, error: Error?) in
            if error == nil{
                for act in userActs! {
                    UserActivity.deleteAct(deleting: act, completion: { (userAct: [UserActivity]?, error: Error?) in
                        if error == nil {
                            print("delete user act in list")
                        } else {
                            print("\(String(describing: error?.localizedDescription))")
                        }
                    })
                }
                
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        colView.dataSource = self
        colView.delegate = self
        noListsLabel.isHidden = true
        let layout = colView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // Adjust cell size and layout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 3
        let interItemSpacingTotal = layout.minimumInteritemSpacing * ( cellsPerLine - 1)
        let width = colView.frame.size.width / cellsPerLine - interItemSpacingTotal/cellsPerLine
        layout.itemSize = CGSize(width: width, height: width) //width*3/2

      //  getLists()

        if let imageFile = User.current()?.profileImage {
            imageFile.getDataInBackground(block: { (data, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        // Async main thread
                        let image = UIImage(data: data!)
                        self.profileImage.image = image
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
        self.username.text = User.current()?.username
        selecting = false
        editBtn.title = "Edit"
        colView.allowsMultipleSelection = false
        colView.selectItem(at: nil, animated: false, scrollPosition: UICollectionViewScrollPosition())
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        editBtn.title = "Edit"
        selecting = false
        colView.reloadData()
        getLists()
        getAddedListsRe()
        
        if combinedLists.count == 0 {
            self.noListsLabel.isHidden = false
            print("user has no lists yet")
        }
        else{
            self.noListsLabel.isHidden = true
        }
    }
    
    func getAddedListsRe(){
        let currUser = PFUser.current() as! User
        let listIds = currUser.addedLists
        combinedListsSet = Set<List>()
       // for listId in listIds {
            let query = PFQuery(className: "List")
            query.whereKey("objectId", containedIn: listIds)
       
            
        query.findObjectsInBackground { [self] (lists: [PFObject]? , error: Error?) in
            print("ADDED LISTS FOUND......", lists)
                let lists = lists as! [List]
                if lists.count == 0 {
                   // self.noListsLabel.isHidden = false
                    print("user has no lists yet")
                }
                else {
                    if error == nil {
                        if lists != nil{
                            let lists = lists
                            self.noListsLabel.isHidden = true
                            print(lists)
                            self.addLists = lists
                            for item in self.addLists {
                                print("ITEM to compare...", item)
                                combinedListsSet.insert(item)
                                /*if(self.combinedLists.contains(item) == false){
                                    self.combinedLists.append(contentsOf: self.lists)
                                    print("COMBINED LISTS IS...", self.combinedLists)
                                }*/
                            }
                            
                            self.combinedLists = Array(combinedListsSet)
                            
                            self.itemCounts = self.combinedLists.count
                            self.colView.reloadData()
                           // print("self.lists", self.lists )
                           // print("lists[0]", self.lists[0].listName)
                        } else {
                            self.editBtn.title = "Edit"
                            print(error?.localizedDescription)
                        }
                    
                    }
                }
                
                
            }
       // }
    }
    
    func getLists() {
        let curUser = User.current()
        let userId = curUser?.objectId
        combinedListsSet = Set<List>()
        List.fetchLists(userId: userId!) { [self] (lists: [List]?, error: Error?) in
            if lists?.count == 0 {
               // self.noListsLabel.isHidden = false
                print("user has no lists yet")
            }
            else {
                if error == nil {
                    if lists != nil{
                        let lists = lists!
                        self.noListsLabel.isHidden = true
                        print(lists)
                        self.lists = lists
                        for item in self.lists {
                            print("ITEM to compare...", item)
                            combinedListsSet.insert(item)
                            /*if(self.combinedLists.contains(item) == false){
                                self.combinedLists.append(contentsOf: self.lists)
                                print("COMBINED LISTS IS...", self.combinedLists)
                            }*/
                        }
                        
                        self.combinedLists = Array(combinedListsSet)
                        
                        self.itemCounts = self.combinedLists.count
                        print("COMBINED LISTS IS outside...", self.combinedLists)
                        print("COMBINED LISTS IS...", self.combinedLists.count)
                        self.colView.reloadData()
                      //  print("self.lists", self.lists )
                       // print("lists[0]", self.lists[0].listName)
                    } else {
                        self.editBtn.title = "Edit"
                        print(error?.localizedDescription)
                    }
                
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //let userLists = self.lists
        return itemCounts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "UserListsCell", for: indexPath) as! UserListsCell
        
        
        if self.combinedLists != [] {
            self.combinedLists.sort(by: { $0.createdAt! > $1.createdAt! })
            let userLists = self.combinedLists
            let curList = userLists[indexPath.row]
            let curListName = curList.listName
            cell.listName.text = curListName
            cell.delegate2 = self
            cell.indexPath = indexPath
            if selecting == true {
                cell.deleteListBtn.isHidden = false
            } else {
                cell.deleteListBtn.isHidden = true
            }
            
        } else if self.lists == nil  {
            editBtn.title = "Edit"
        }
        
        if(self.combinedLists[indexPath.item].backgroundPic != nil){
            let pfFileImage = self.combinedLists[indexPath.item].backgroundPic!
                   pfFileImage.getDataInBackground{(imageData, error) in
                    if(error == nil){
                        if let imageData = imageData{
                            let img = UIImage(data: imageData)
                            cell.profileListsImageView.image = img
                            cell.profileListsImageView.alpha = 0.7
                        }
                    }
            }
        }
        
        cell.layer.cornerRadius = 8.0
        cell.clipsToBounds = true
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UICollectionViewCell{
            
            if let indexPath = colView.indexPath(for: cell){

                let curList = combinedLists[indexPath.row]
                print("list to be send for adding act:", curList)
                let navVC = segue.destination as! UINavigationController
                let listOfActVC = navVC.topViewController as! ListOfActsViewController
                print("ListofAct VC", listOfActVC)
                listOfActVC.list = curList
                print("send current List:", listOfActVC.list)
                editBtn.title = "Edit"
                selecting = false
                colView.reloadData()
            }
        } else {
            editBtn.title = "Edit"
            selecting = false
            colView.reloadData()
        }
        
    }

    
    @IBAction func changeProfilePic(_ sender: UIButton) {
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
