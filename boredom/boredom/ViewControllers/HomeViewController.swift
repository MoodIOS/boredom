//
//  HomeViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {

    @IBOutlet weak var actImage: UIImageView!
    @IBOutlet weak var actName: UILabel!
    var userActivities = [UserActivity]()
    var allActivities = [Activity]()
    var userList = [List]()
    var currentUser = PFUser.current()
    var currentRandomAct = Activity()
    var isSaved = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getUserActs()
//        randomActivity()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isSaved = UserDefaults.standard.integer(forKey: "savedBoolean")
        if(isSaved == 2){
            self.userActivities.removeAll()
            print("whatttttttttt", isSaved)
            getUserActs()
            randomActivity()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func changeGenOptions(_ sender: Any) {
    }
    
    @IBAction func randomizeAct(_ sender: UIButton) {
        randomActivity()
    }
    
    
    
    
    func getUserActs(){
//        (completion: @escaping () -> Void) {
        let userId = currentUser?.objectId
        List.fetchLists(userId: userId! ){ (lists: [List]?, error: Error?) in
            if error == nil {
                let userLits = lists
                for list in userLits! {
                    let listId = list.objectId
                    UserActivity.fetchActivity(listId: listId!, completion: { (activities: [UserActivity]?, error: Error?) in
                        if error == nil {
                            let actsInList = activities
                            for act in actsInList! {
                               let actId = act.activity.objectId
                                
                                
                                Activity.fetchActivity(actId: actId!, completion: { (acts: [Activity]?, error: Error?) in
                                    let firstOption = UserDefaults.standard.integer(forKey: "whichOne")
                                    if (acts![0].cost == firstOption){
                                        //need to add distance, tags, etc. to filter out activities.
                                        self.userActivities.append(act)
                                    }
                                    
                                })
                            }
                        }
                        
                    })
                }
               
            }
            
        }
    }

    
    func randomActivity(){
        if userActivities != [] {
            let randomindex = Int(arc4random_uniform(UInt32(userActivities.count)))
            let userRandomAct = userActivities[randomindex]
            let actId = userRandomAct.activity.objectId
            print("actID", actId!)
            Activity.fetchActivity(actId: actId!, completion: { (activities: [Activity]?, error: Error?) in
                if (error == nil) && ((activities?.count)! > 0) {
                    let randomAct = activities![0]
                    print("randomAct", randomAct)
                    self.actName.text = randomAct.actName
//                    let curUser = User.current
                    
                }
            })
        }
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
