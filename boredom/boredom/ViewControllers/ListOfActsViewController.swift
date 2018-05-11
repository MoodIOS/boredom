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
    
    
    var userActivities = [UserActivity]()
    var list = List()
    var actnamesInList = [String]()
    var allActNames = [String]()
    var actsInList =  [Activity]()
    var allActs = [Activity]()
//    var doneAct = UserActivity()
    private var completionPopup: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        getActivities()
        print("actnamesInList", actnamesInList)
        // Do any additional setup after loading the view.
        
//        completionPopup.isHidden = true
    }
    
    //OPTIONAL: If user clicks on completion btn ->  popup asking for picture?
    func loadCompletionPopup() {
        let customViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 200)
        completionPopup = UIView(frame: customViewFrame)
        view.addSubview(completionPopup)
        completionPopup.isHidden = false
    }
    
    func getActivities() {
        let curList = self.list
        let listId = curList.objectId
        UserActivity.fetchActivity(listId: listId!) { (activities: [UserActivity]?, error: Error?) in
            if error == nil {
                print(activities!)
                if let activities = activities {
                    self.userActivities = activities
                    self.tableView.reloadData()
                    print("self.activities", self.userActivities )
                }
            } else{
                print(error?.localizedDescription as Any)
            }
        }
        Activity.fetchActivity { (allActivities: [Activity]?, error: Error?) in
            if allActivities! != [] {
                print("ACTIVITIES:", allActivities![0])
                self.allActs = allActivities!
                
                for act in allActivities! {
                    self.allActNames.append(act.actName)
                }
                
            }
        }
    }


    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        let userActivities = self.userActivities
        let curAct = userActivities[indexPath.row]
        let currentActID = curAct.activity.objectId
        cell.thisAct = curAct
        if curAct.done == false {
            cell.completionBtn.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        } else {
            cell.completionBtn.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
        
        Activity.fetchActivity(actId: currentActID!) { (activities: [Activity]?, error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let activity = activities![0]
                cell.activityName.text = activity.actName
                self.actnamesInList.append(activity.actName)
                self.actsInList.append(activities![0])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userActivities.count
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let addNewActVC = navVC.topViewController as! AddNewActivityVCViewController
        addNewActVC.list = self.list
        addNewActVC.actNamesInList = actnamesInList
        addNewActVC.allActNames = allActNames
        addNewActVC.allActs = allActs
        addNewActVC.actsInList = actsInList
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
