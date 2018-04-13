//
//  ProfileViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var lists = [String: Any]()
    var lists2: [PFObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getLists()
        
        //APIManager.shared.getLists()
        
        // Do any additional setup after loading the view.
    }
    
    func getLists() {
        print("inside getLists")
        let query = PFQuery(className: "List")
        query.includeKey("_p_author")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        query.whereKey("author", equalTo: "_User$" + (PFUser.current()?.objectId)!)
        query.findObjectsInBackground { (lists2: [PFObject]? , error: Error?) in
            if error == nil {
                print(lists2!)
                if let lists2 = lists2 {
                    self.lists2 = lists2
                    
                }
            }
            else{
                print(error)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! UITableViewCell
        
        //cell.tweet = lists[indexPath.row]
        
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
