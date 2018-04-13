//
//  ProfileViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    //@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var colView: UICollectionView!
    
    var lists = [List]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colView.dataSource = self
        colView.delegate = self
        
        // Do any additional setup after loading the view.
    }


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "UserListsCell", for: indexPath) as! UserListsCell
        let curList = lists[indexPath.row]
        let curListName = curList.listName
        cell.listName.text = curListName
        
        return cell
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
