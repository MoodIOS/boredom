//
//  List.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation
import Parse

@objc class List: PFObject, PFSubclassing {
    @NSManaged var listName: String!
    @NSManaged var category: String!
    @NSManaged var activities: [Activity]?
    //var rating: Int?
    @NSManaged var author: PFUser!

    class func parseClassName() -> String {
        return "List"
    }
    

    
    
    class func addNewList(name: String?, category: String?, withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let list = List()
        
        list.listName = name ?? "No name"
        list.category = category ?? "No category"
        list.activities = []
        list.author = PFUser.current()
        
        // Save object (following function will save the object in Parse asynchronously)
        list.saveInBackground(block: completion)
    }
}

