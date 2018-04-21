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
    //@NSManaged var actName: String!
    //@NSManaged var actDescription: String!
    //@NSManaged var actImageUrl: String!
    @NSManaged var list: List!
    @NSManaged var done: BooleanLiteralType
    //@NSManaged var location: String!
    //@NSManaged var cost: String // Free, $, $$, $$$
    //@NSManaged var likeCount: Int
    
    class func parseClassName() -> String {
        return "UserActivity"
    }
    
    class func addNewActivity(activity: Activity, list: List?, withCompletion completion: PFBooleanResultBlock?){
        let userActivity = UserActivity()
        //userActivity.actName = actName ?? "No name"
        //userActivity.actDescription = actDescription ?? "No description"
        //activity.actImageUrl = "//cdn.shopify.com/s/files/1/1061/1924/products/Blow_Kiss_Emoji_grande.png?v=1480481051"
        userActivity.activity = activity
        userActivity.list = list
        userActivity.done = false
        //activity.location = location ?? "No location specified"
        //activity.cost = cost
        //activity.likeCount = 0
        userActivity.saveInBackground(block: completion)
    }
    
    class func fetchActivity (completion: @escaping ([UserActivity]?, Error?) -> Void) {
        print("inside getActitivy")
        let query = PFQuery(className: "UserActivity")
        query.includeKey("_p_list")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
            completion(activities as? [UserActivity], nil)
        }
    }
    
    class func fetchActivity (listId: String, completion: @escaping ([UserActivity]?, Error? ) -> Void) {
        print("inside getActitivy")
        let query = PFQuery(className: "UserActivity")
        query.includeKey("_p_list")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        print("List$" + "\(listId)")
        query.whereKey("list", equalTo: "List$" + listId)
        //        query.whereKey("list", equalTo: "List$" + "qMDPU2MqRj")
        return query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
            completion(activities as? [UserActivity], nil)
        }
    }
}



