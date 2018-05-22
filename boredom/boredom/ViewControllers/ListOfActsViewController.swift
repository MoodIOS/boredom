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
    var deleteIndexPath: NSIndexPath? = nil
    
    var userLikedActs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        getActivities()
        tableView.reloadData()
        print("actnamesInList", userLikedActs)
        
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
        let curUser = User.current()
        userLikedActs = (curUser?.likedActivities)!
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
                
                for act in allActivities! {//the activity we want.......
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
        let currentAct = userActivities[indexPath.row]
        let currentActID = currentAct.activity.objectId
        cell.thisAct = currentAct
        if currentAct.done == false {
            cell.completionBtn.setImage(#imageLiteral(resourceName: "uncheck-white"), for: .normal)
        } else {
            cell.completionBtn.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
        
        Activity.fetchActivity(actId: currentActID!) { (activities: [Activity]?, error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let curAct = activities![0]
                
                if curAct.cost == 0 {
                    cell.costLabel.text = "$"
                } else if curAct.cost == 1 {
                    cell.costLabel.text = "$$"
                } else if curAct.cost == 2 {
                    cell.costLabel.text = "$$$"
                } else {
                    cell.costLabel.text = "$$$$"
                }
                cell.costLabel.textColor = UIColor.white
    
                var liked: Int = 0
                var i = 0
                while i < self.userLikedActs.count{
                    let id = self.userLikedActs[i]
                    if id == curAct.objectId {
                        liked = liked + 1
                    }
                    i = i + 1
                }
                
                if liked == 0 {
                    cell.likeBtn.setImage(UIImage(named: "heart-white"), for: .normal)
                } else if liked > 0 {
                    cell.likeBtn.setImage(UIImage(named: "heart-red"), for: .normal)
                }
                
                cell.activityName.text = curAct.actName
                cell.currentAct = curAct
                cell.actID = curAct.objectId!
                self.actnamesInList.append(curAct.actName)
                self.actsInList.append(activities![0])
    
                try? cell.thisAct.activity.fetchIfNeeded() 
                
//                print("ACTIVITY LIKED BY USERS:", cell.thisAct.activity.activityLikedByUsers)
//                print("CURRENT USER:", PFUser.current()?.objectId)
                
//                if(cell.thisAct.activity.activityLikedByUsers.contains((PFUser.current()?.objectId)!)){
//                    cell.likeBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
//                }
                
                
                cell.likeCountLabel.text = "\(cell.thisAct.activity.activityLikeCount)"
                
            }
        }
        
       
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userActivities.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteIndexPath = indexPath as NSIndexPath
            let thisAct = userActivities[indexPath.row]
            let name = actsInList[indexPath.row].actName
            //delete act
            print("deleting act")
            confirmDelete(act: thisAct,name: name! )
        }
    }

    func confirmDelete(act: UserActivity , name: String) {
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to permanently delete \(name)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteAct)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteAct)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.width / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func handleDeleteAct(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteIndexPath{
            tableView.beginUpdates()
            let thisAct = userActivities[indexPath.row]
            self.userActivities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            deleteIndexPath = nil
            tableView.endUpdates()
            
            UserActivity.deleteAct(deleting: thisAct) { (acts, error) in
                if (acts == nil){
                    print("deleting successfully")
                    
                } else {
                    print("error?", error?.localizedDescription)
                }
            }
            
        }
    }
    
    func cancelDeleteAct(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
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
        tableView.reloadData()
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
