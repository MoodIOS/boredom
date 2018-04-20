//
//  ListOfActsViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/13/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
class ListOfActsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var activities = [Activity]()
    var list = List()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getActivities()
        // Do any additional setup after loading the view.
    }
    
    func getActivities() {
        let curList = self.list
        let listId = curList.objectId
        Activity.fetchActivity(listId: listId!) { (activities: [Activity]?, error: Error?) in
            if error == nil {
                print(activities!)
                if let activities = activities {
                    self.activities = activities
                    self.tableView.reloadData()
                    print("self.activities", self.activities )
                }
            } else{
                print(error?.localizedDescription)
            }
        }
    }
        
//        query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
//            if error == nil {
//                print(activities!)
//                if let activities = activities {
//                    self.activities = activities as! [Activity]
//                    self.tableView.reloadData()
//                    print("self.activities", self.activities )
////                    print("lists[0]", self.lists[0].listName)
//                }
//            }
//            else{
//                print(error?.localizedDescription)
//            }
//        }
    

    
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        let userActivities = self.activities
        let curAct = userActivities[indexPath.row]
        let curActName = curAct.actName
        cell.activityName.text = curActName
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let addNewActVC = navVC.topViewController as! AddNewActivityVCViewController
        addNewActVC.list = self.list
    }

    override func viewDidAppear(_ animated: Bool) {
        getActivities()
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
