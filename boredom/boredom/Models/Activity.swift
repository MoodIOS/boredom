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
    @NSManaged var cost: Int // Free, $, $$, $$$
    @NSManaged var activityLikeCount: Int
    
    class func parseClassName() -> String {
        return "Activity"
    }
    
    class func addNewActivity(actName: String?, actDescription: String?, list: List?, cost: Int, location: String?, completion: @escaping (Activity?, Error?) -> Void){
        let activity = Activity()
        activity.actName = actName ?? "No name"
        activity.actDescription = actDescription ?? "No description"
        activity.location = location ?? "No location specified"
        activity.cost = cost
        print("cost: ", cost)
        activity.activityLikeCount = 0
        return activity.saveInBackground { (success, error) in
            completion(activity, nil)
        }
    }
    
    class func fetchActivity (completion: @escaping ([Activity]?, Error?) -> Void) {
        print("inside getActitivy")
        let query = PFQuery(className: "Activity")
        query.includeKey("activityLikeCount")
        query.includeKey("_p_list")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        query.addDescendingOrder("activityLikeCount")
        return query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
           completion(activities as? [Activity], nil)
        }
    }
    
    class func fetchActivity (actId: String, completion: @escaping ([Activity]?, Error? ) -> Void) {
        let query = PFQuery(className: "Activity")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        print("Activity ID " + "\(actId)")
        query.whereKey("objectId", equalTo: actId)
        return query.findObjectsInBackground {(activity: [PFObject]? , error: Error?) in
            completion(activity as? [Activity], nil)
            print("return findObjectsInBackground() ", activity!)
        }
    }

}



