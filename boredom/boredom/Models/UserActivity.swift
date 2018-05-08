//
//  UserActivity.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation
import Parse

@objc class UserActivity: PFObject, PFSubclassing {
    @NSManaged var activity: Activity!
    @NSManaged var list: List!
    @NSManaged var done: Bool

    
    class func parseClassName() -> String {
        return "UserActivity"
    }

    class func addNewActivity(activity: Activity, list: List?, completion: @escaping (UserActivity?, Error?) -> Void) {
        let userActivity = UserActivity()
        userActivity.activity = activity
        userActivity.list = list
        userActivity.done = false
        userActivity.saveInBackground { (success, error) in
            completion(userActivity, nil)
        }
    }
        
    
    class func fetchActivity (completion: @escaping ([UserActivity]?, Error?) -> Void) {
        print("inside getActitivy")
        let query = PFQuery(className: "UserActivity")
        query.includeKey("activityLikedByUsers")
        query.includeKey("_p_list")
        query.includeKey("_p_activity")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
            completion(activities as? [UserActivity], nil)
        }
    }
    
    class func fetchActivity (listId: String, completion: @escaping ([UserActivity]?, Error? ) -> Void) {
        print("inside getActitivy for user")
        let query = PFQuery(className: "UserActivity")
        query.includeKey("activityLikedByUsers")
        query.includeKey("_p_list")
        query.includeKey("_p_activity")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        print("List$" + "\(listId)")
        query.whereKey("list", equalTo: "List$" + listId)
        return query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
            completion( activities as? [UserActivity], nil)
        }
    }
    
    class func updateUserAct (updatedAct: UserActivity ,completion: @escaping ([UserActivity]?, Error? ) -> Void){
        let userAct = updatedAct
        userAct.saveInBackground { (success, error) in
            if success {
                let query = PFQuery(className: "UserActivity")
                query.whereKey("objectId", equalTo: userAct.objectId!)
                return query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
                    completion( activities as? [UserActivity], nil)
                }
            } else if let error = error {
                print( "error update user activity" ,error.localizedDescription)
            }
        }
    }
    
}



