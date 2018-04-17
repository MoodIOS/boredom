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
    @NSManaged var list: List!
    @NSManaged var done: BooleanLiteralType
    @NSManaged var location: String!
    @NSManaged var cost: String // Free, $, $$, $$$
    
    class func parseClassName() -> String {
        return "Activity"
    }
    
    class func addNewActivity(actName: String?, actDescription: String?, list: List?, cost: String, location: String?, withCompletion completion: PFBooleanResultBlock?){
        let activity = Activity()
        activity.actName = actName ?? "No name"
        activity.actDescription = actDescription ?? "No description"
        activity.list = list
        activity.done = false
        activity.location = location ?? "No location specified"
        activity.cost = cost
        activity.saveInBackground(block: completion)
    }
    
    class func fetchActivity () {
        
    }
    
    class func fetchActivity (listId: String) {
        
    }
    
    
}



