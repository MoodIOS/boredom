//
//  ListOfActsViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/13/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

class ListOfActsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UploadImageforCompletionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var userActivities = [UserActivity]()
    var list = List()
    var actnamesInList = [String]()
    var allActNames = [String]()
    var actsInList =  [Activity]()
    var allActs = [Activity]()
    var actIndexPath = IndexPath()
//    var doneAct = UserActivity()
    
    var refreshControl: UIRefreshControl!/////

    var deleteIndexPath: NSIndexPath? = nil
    
    var userLikedActs = [String]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var completionPopup: PopupDialog!
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        getActivities()
        tableView.reloadData()


        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        //action is what method is called and start enums by .
        refreshControl.addTarget(self, action: #selector(ListOfActsViewController.didPullToRefresh(_:)), for: .valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        //tableView.reloadData()
        activityIndicator.stopAnimating()
        print("actnamesInList", userLikedActs)

        tableView.allowsSelection = false
        // Do any additional setup after loading the view.
        
//        completionPopup.isHidden = true
    }
    
    //OPTIONAL: If user clicks on completion btn ->  popup asking for picture?
//    func loadCompletionPopup() {
//        let customViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 200)
//        completionPopup = UIView(frame: customViewFrame)
//        view.addSubview(completionPopup)
//        completionPopup.isHidden = false
//    }
    
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

    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl)
    {
       getActivities()
       tableView.reloadData()
       self.refreshControl.endRefreshing()
    }
    
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //delegate funct for adding picture:
    
    func uploadImgPopup(button: UIButton, index: IndexPath) {
        self.actIndexPath = index
        completionPopup = PopupDialog(title: "Activity Complete!", message: "Would you like to upload a picture to describe your activity?")
        let okBtn = CancelButton(title: "OK") {
            button.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            print("done without uploading")
        }
        let uploadImgBtn = DefaultButton(title: "Upload Image") {
            print("uploading image")
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion:nil)

        }
        completionPopup.addButtons([okBtn, uploadImgBtn])
        completionPopup.buttonAlignment = .horizontal
        
        self.present(completionPopup, animated: true, completion: nil)
    }

    
    
    
    // imag picker
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.pickedImage = editedImage
        //temp.image = originalImage
        
        // Do something with the images (based on your use case)
        
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: {
            // save image with the act
            // Do something here
            self.saveImgToAct()
        })
        
    }
    
    func saveImgToAct() {
        let index = self.actIndexPath
        let userActivities = self.userActivities
        let currentAct = userActivities[index.row]
        let currentActID = currentAct.activity.objectId
        Activity.fetchActivity(actId: currentActID!) { (activities: [Activity]?, error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let curAct = activities![0]
                Activity.saveActImage(image: self.pickedImage, currentAct: curAct, withCompletion: { (success: Bool?, error: Error?) in
                    if success != nil{
                        print("save Image")
                        let alertController = UIAlertController(title: "Image Saved!", message: nil , preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true)
                        
                    } else {
                        print("\(String(describing: error?.localizedDescription))")
                    }
                })
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        let userActivities = self.userActivities
        let currentAct = userActivities[indexPath.row]
        let currentActID = currentAct.activity.objectId
        cell.thisAct = currentAct
        cell.delegate = self
        cell.indexPath = indexPath
        

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
    
    func  tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let act = actsInList[indexPath.row]
//        // action one
//        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
//            print("Edit tapped")
//            let alert = UIAlertController(title: "Edit", message: "Edit Activity Name?", preferredStyle: .alert)
//            
//            //2. Add the text field. You can configure it however you need.
//            alert.addTextField { (textField) in
//                textField.text = act.actName
//            }
//            
//            // 3. Grab the value from the text field, and print it when the user clicks OK.
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
//                print("Text field: \(textField?.text)")
//                
//            }))
//            
//            // 4. Present the alert.
//            self.present(alert, animated: true, completion: nil)
//            
//        })
//        editAction.backgroundColor = UIColor.lightGray
//        
//        // action two
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, indexPath) in
//            self.deleteIndexPath = indexPath as NSIndexPath
//            let thisAct = self.userActivities[indexPath.row]
//            let name = self.actsInList[indexPath.row].actName
//            //delete act
//            print("deleting act")
//            self.confirmDelete(act: thisAct,name: name! )
//        })
//        
//        
//        return [editAction, deleteAction]
//    }

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
                    UserActivity.fetchActivity(listId: self.list.objectId!) { (userActs: [UserActivity]?, error:Error?) in
                        if error == nil {
                            if let userActs = userActs {
                                self.userActivities = userActs
                                self.tableView.reloadData()
                            }
                        }
                    }
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
        addNewActVC.allActNames = allActNames
        addNewActVC.allActs = allActs
        
        // FOR addNewActVC.actNamesInList = actnamesInList
        // update acts in lists
        let curUser = User.current()
        userLikedActs = (curUser?.likedActivities)!
        let curList = self.list
        let listId = curList.objectId
        
        UserActivity.fetchActivity(listId: listId!) { (userActivities: [UserActivity]?, error: Error?) in
            if error == nil {
                print(userActivities!)
                if let userActs = userActivities {
                    print("self.activities", self.userActivities )
                    for act in userActs{
                        Activity.fetchActivity(actId: act.activity.objectId!) { (activities: [Activity]?, error: Error?) in
                            if activities! != [] {
                                let activities = activities
                                print("ACTIVITIES:", activities![0])
                                let curAct = activities![0]
                                self.actsInList.append(activities![0])
                                addNewActVC.actsInList = self.actsInList
                                addNewActVC.actNamesInList.append(activities![0].actName)
                            }
        
                        }
                    }
                    print("addNewActVC.actNamesInList", addNewActVC.actNamesInList)
//                    print("addNewActVC.actNamesInList", addNewActVC.actNamesInList)
                } else{
                    print(error?.localizedDescription as Any)
                }
            }
        }
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
