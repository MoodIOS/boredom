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
    @NSManaged var listDescription: String!
    @NSManaged var backgroundPic: PFFileObject!
    @NSManaged var activities: [UserActivity]?
    //var rating: Int?
    @NSManaged var author: PFUser!
    @NSManaged var likeCount: Int
    @NSManaged var tags: [String: Bool]!
//    @NSManaged var usersThatLikeAct: [User]!
    class func parseClassName() -> String {
        return "List"
    }
    
    
    class func addNewList(name: String?, category: String?, likeCount: Int?, activities: [UserActivity]?, completion: @escaping (List?, Error?) -> Void) {
        // use subclass approach
        let list = List()
        list.tags = [
            "Coffee": false,
            "Brunch": false,
            "Book": false,
            "Happy hours": false,
            "Restaurant": false,
            "Nightlife": false,
            "Movie": false,
            "Outdoor": false
        ]
        list.listName = name ?? "No name"
        list.listDescription = category ?? "No category"
        list.activities = activities
        list.author = PFUser.current()
        list.likeCount = likeCount ?? 0
      
        
        // Save object (following function will save the object in Parse asynchronously)
        ///list.saveInBackground(block: completion)
        //return list
        return list.saveInBackground { (success,error) in completion(list,nil) }
        //return list
    }
    
    
    class func addNewList(name: String?, category: String?, likeCount: Int?, activities: [UserActivity]?,backgroundImage:PFFileObject,  completion: @escaping (List?, Error?) -> Void) {
        // use subclass approach
        let list = List()
        list.tags = [
            "Coffee": false,
            "Brunch": false,
            "Book": false,
            "Happy hours": false,
            "Restaurant": false,
            "Nightlife": false,
            "Movie": false,
            "Outdoor": false
        ]
        list.listName = name ?? "No name"
        list.listDescription = category ?? "No category"
        list.activities = activities
        list.author = PFUser.current()
        list.likeCount = likeCount ?? 0
        list.backgroundPic = backgroundImage
        
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
    
    //fetching all lists possible
    class func fetchRecentLists(completion: @escaping ([List]?, Error?) -> Void){
        let query = PFQuery(className: "List")
        query.includeKey("likeCount")
        query.includeKey("_p_author")
        query.includeKey("_p_activity")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        
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
        query.includeKey("activities")
        query.whereKey("author", equalTo: "_User$" + userId)
        return query.findObjectsInBackground { (lists: [PFObject]? , error: Error?) in
            completion(lists as? [List], nil)
        }
    }
    
    class func addActToList(currentList: List, userAct: UserActivity, tags: [String: Bool]!, completion: @escaping (List?, Error?) -> Void){
        let list = currentList
        for (tag, value) in tags {
            print("tag, value:", tag, " ", value)
            if value == true {
                list.tags[tag] = true
            }
        }
        
        if list.activities == nil {
            list.activities = [userAct]
        } else {
            list.activities?.append(userAct)
        }
        print("saving List: ", list)
        
//        try? list.save()
        list.saveInBackground(block: { (success, error) in
            if success {
                completion(list, nil)
            } else{
                print("error ", error?.localizedDescription)
            }
        })
    }
    
    class func deleteList(deletingList: List, completion: @escaping (List?, Error?) -> Void){
        let list = deletingList
        list.deleteInBackground()
        return completion(list, nil)
    }
    
    class func updateListLikeCount(updateList: List,  completion: @escaping (List?, Error?) -> Void){
        let list = updateList
        return list.saveInBackground { (success, error) in
            if error == nil {
                completion(list, nil)
            }
        }
    }
    
    class func fetchWithID(listID: String, completion: @escaping ([List]?, Error?) -> Void ){
        let query = PFQuery(className: "List")
        query.includeKey("_p_author")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        query.whereKey("objectId", equalTo: listID)
        return query.findObjectsInBackground { (lists: [PFObject]? , error: Error?) in
            completion(lists as? [List], nil)
        }
    }
}

