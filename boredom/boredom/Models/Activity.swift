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
    @NSManaged var actType: String!
    @NSManaged var author: PFUser!
    
    class func parseClassName() -> String {
        return "Activity"
    }
    
    class func addNewActivity(actName: String?, actDescription: String?, actType: String?, withCompletion completion: PFBooleanResultBlock?){
        let activity = Activity()
        
        activity.actName = actName ?? "No name"
        activity.actDescription = actDescription ?? "No description"
        activity.actType = actType ?? "No Type"
        activity.author = PFUser.current()
        
        activity.saveInBackground(block: completion)
    }
    
    
}



