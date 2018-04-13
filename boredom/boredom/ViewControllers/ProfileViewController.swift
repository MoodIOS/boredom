//
//  ProfileViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var colView: UICollectionView!

    var lists = [List]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        colView.dataSource = self
        colView.delegate = self
        
        let layout = colView.collectionViewLayout as! UICollectionViewFlowLayout
        // Adjust cell size and layout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 3
        let interItemSpacingTotal = layout.minimumInteritemSpacing * ( cellsPerLine - 1)
        let width = colView.frame.size.width / cellsPerLine - interItemSpacingTotal/cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)

        
        getLists()
        
        //APIManager.shared.getLists()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getLists()
    }
    
    func getLists() {
        print("inside getLists")
        let query = PFQuery(className: "List")
        query.includeKey("_p_author")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        query.whereKey("author", equalTo: "_User$" + (PFUser.current()?.objectId)!)
        query.findObjectsInBackground { (lists: [PFObject]? , error: Error?) in
            if error == nil {
                print(lists!)
                if let lists = lists {
                    self.lists = lists as! [List]
                    self.colView.reloadData()
                    print("self.lists", self.lists )
                    print("lists[0]", self.lists[0].listName)
                }
            }
            else{
                print(error?.localizedDescription)
            }
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let userLists = self.lists
        return userLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "UserListsCell", for: indexPath) as! UserListsCell
        let userLists = self.lists
        let curList = userLists[indexPath.row]
        let curListName = curList.listName
        cell.listName.text = curListName
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell{
            if let indexPath = colView.indexPath(for: cell){
                let curList = lists[indexPath.row]
                print("list to be send for adding act:", curList)
                let navVC = segue.destination as! UINavigationController
                let listOfActVC = navVC.topViewController as! ListOfActsViewController
                print("ListofAct VC", listOfActVC)
                listOfActVC.list = curList
                print("send current List:", listOfActVC.list)
            }
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
