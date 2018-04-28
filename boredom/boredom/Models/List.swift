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
    //@NSManaged var listImage: UIImage!
    @NSManaged var activities: [Activity]?
    //var rating: Int?
    @NSManaged var author: PFUser!
    @NSManaged var likeCount: Int
    
    class func parseClassName() -> String {
        return "List"
    }
    
    class func addNewList(name: String?, category: String?, likeCount: Int?, withCompletion completion: @escaping (List?, Error?) -> Void) {
        // use subclass approach
        let list = List()
        
        list.listName = name ?? "No name"
        list.category = category ?? "No category"
        list.activities = []
        list.author = PFUser.current()
        list.likeCount = likeCount ?? 0
        
        // Save object (following function will save the object in Parse asynchronously)
        ///list.saveInBackground(block: completion)
        //return list
        return list.saveInBackground { (success,error) in completion(list,nil) }
        //return list
    }
    
    //fetching all lists possible
    class func fetchLists(completion: @escaping ([List]?, Error?) -> Void){
        let query = PFQuery(className: "List")
        query.includeKey("likeCount")
        query.includeKey("_p_author")
        query.includeKey("_p_activity")
        query.includeKey("_created_at")
        query.addDescendingOrder("likeCount")
        
        return query.findObjectsInBackground { (lists: [PFObject]? , error: Error?) in
            completion( lists as? [List], nil)
            
        }
    }
    
    //fetching lists for each specific user
    class func fetchLists(userId: String, completion: @escaping ([List]?, Error?) -> Void ){
        let query = PFQuery(className: "List")
        query.includeKey("_p_author")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        query.whereKey("author", equalTo: "_User$" + userId)
        return query.findObjectsInBackground { (lists: [PFObject]? , error: Error?) in
            completion(lists as? [List], nil)
        }
    }
}

