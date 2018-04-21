//
//  Activity.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation
import Parse

@objc class Activity: PFObject, PFSubclassing {
    @NSManaged var actName: String!
    @NSManaged var actDescription: String!
    //@NSManaged var actImageUrl: String!
    //@NSManaged var list: List!
    //@NSManaged var done: BooleanLiteralType
    @NSManaged var location: String!
    @NSManaged var cost: String // Free, $, $$, $$$
    @NSManaged var activityLikeCount: Int
    
    class func parseClassName() -> String {
        return "Activity"
    }
    
    class func addNewActivity(actName: String?, actDescription: String?, list: List?, cost: String, location: String?, withCompletion completion: PFBooleanResultBlock?){
        let activity = Activity()
        activity.actName = actName ?? "No name"
        activity.actDescription = actDescription ?? "No description"
        //activity.actImageUrl = "//cdn.shopify.com/s/files/1/1061/1924/products/Blow_Kiss_Emoji_grande.png?v=1480481051"
        //activity.list = list
        //activity.done = false
        activity.location = location ?? "No location specified"
        activity.cost = cost
        activity.activityLikeCount = 0
        activity.saveInBackground(block: completion)
    }
    
    class func fetchActivity (completion: @escaping ([Activity]?, Error?) -> Void) {
        print("inside getActitivy")
        let query = PFQuery(className: "Activity")
        query.includeKey("activityLikeCount")
        query.includeKey("_p_list")
        query.includeKey("_created_at")
        //query.addDescendingOrder("_created_at")
        query.addDescendingOrder("activityLikeCount")
        query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
           completion(activities as? [Activity], nil)
        }
    }
    
    /*class func fetchActivity (listId: String, completion: @escaping ([Activity]?, Error? ) -> Void) {
        print("inside getActitivy")
        let query = PFQuery(className: "Activity")
        query.includeKey("_p_list")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        print("List$" + "\(listId)")
        query.whereKey("list", equalTo: "List$" + listId)
        //        query.whereKey("list", equalTo: "List$" + "qMDPU2MqRj")
        return query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
            completion(activities as? [Activity], nil)
        }*/

    
    
    

}



