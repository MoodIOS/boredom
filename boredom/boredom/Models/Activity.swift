//
//  Activity.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation
import CoreLocation
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
    @NSManaged var usersLikedActivity: [String]!
    @NSManaged var activityLikedByUsers: [String]!
    @NSManaged var tags: [String: Bool]!
    @NSManaged var actImgs: [PFFile]!
    
    
    class func parseClassName() -> String {
        return "Activity"
    }
    
    class func addNewActivity(actName: String?, actDescription: String?, cost: Int, location: String?,tags: [String: Bool], completion: @escaping (Activity?, Error?) -> Void){
        let activity = Activity()
        activity.actName = actName ?? "No name"
        activity.actDescription = actDescription ?? "No description"
        activity.location = location ?? "No location specified"
        activity.cost = cost
        print("cost: ", cost)
        activity.activityLikeCount = 0
        activity.activityLikedByUsers = []
        activity.tags = tags
        return activity.saveInBackground { (success, error) in
            completion(activity, nil)
        }
    }
    
    class func fetchActivity (completion: @escaping ([Activity]?, Error?) -> Void) {
        print("inside getActitivy")
        let query = PFQuery(className: "Activity")
        query.includeKey("activityLikeCount")
        query.includeKey("activityLikedByUsers")
        query.includeKey("actName")
        query.includeKey("_created_at")
        //query.addDescendingOrder("_created_at")
        query.addDescendingOrder("activityLikeCount")
        return query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
           completion(activities as? [Activity], nil)
        }
    }
    
    class func fetchRecentActivity (completion: @escaping ([Activity]?, Error?) -> Void) {
        print("inside getActitivy")
        let query = PFQuery(className: "Activity")
        query.includeKey("activityLikeCount")
        query.includeKey("activityLikedByUsers")
        query.includeKey("actName")
        query.includeKey("_created_at")
        query.addDescendingOrder("_created_at")
        //query.addDescendingOrder("activityLikeCount")
        return query.findObjectsInBackground { (activities: [PFObject]? , error: Error?) in
            completion(activities as? [Activity], nil)
        }
    }
    
    class func fetchActivity (actId: String, completion: @escaping ([Activity]?, Error? ) -> Void) {
        let query = PFQuery(className: "Activity")
        query.includeKey("_created_at")
        query.includeKey("activityLikedByUsers")
        query.addDescendingOrder("_created_at")
        print("Activity ID " + "\(actId)")
        query.whereKey("objectId", equalTo: actId)
        return query.findObjectsInBackground {(activity: [PFObject]? , error: Error?) in
            completion(activity as? [Activity], nil)
            print("return findObjectsInBackground() ", activity!)
        }
    }
    
    class func changeLikeCount(actId: String, likeCount: Int, completion: @escaping ([Activity]?, Error?) -> Void){
        let query = PFQuery(className: "Activity")
        query.includeKey("_created_at")
        query.includeKey("activityLikedByUsers")
        query.includeKey("activityLikeCount")
        query.addDescendingOrder("_created_at")
        print("Activity ID " + "\(actId)")
        query.whereKey("objectId", equalTo: actId)
        return query.findObjectsInBackground{(activity: [PFObject]? , error: Error?) in
            completion(activity as? [Activity], nil)
            
            //saveChangedLikeCount(actId: actId)
            print("return..... findObjectsInBackground() ", activity!)
        }
        
        // Need to save the new like count
        //return query.
    }
    
    class func changeLikeCount00(actId: String, likeCount: Int, completion: @escaping (Activity?, Error?) -> Void){
        let query = PFQuery(className: "Activity")
        query.includeKey("_created_at")
        query.includeKey("activityLikedByUsers")
        query.includeKey("activityLikeCount")
        query.addDescendingOrder("_created_at")
        print("Activity ID " + "\(actId)")
        query.whereKey("objectId", equalTo: actId)
        query.findObjectsInBackground{(activities: [PFObject]? , error: Error?) in
            if activities! != []{
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let activity = activities![0] as! Activity
                activity.activityLikeCount = likeCount
                return activity.saveInBackground { (success, error) in
                    completion(activity, nil)
                }
            }
        }
    }
    
    class func saveUserIDLikedAct(actId: String, userId: String, completion: @escaping (Activity?, Error?) -> Void){
        let query = PFQuery(className: "Activity")
        query.includeKey("_created_at")
        query.includeKey("activityLikedByUsers")
        query.includeKey("activityLikeCount")
        query.addDescendingOrder("_created_at")
        print("Activity ID " + "\(actId)")
        query.whereKey("objectId", equalTo: actId)
        query.findObjectsInBackground{(activities: [PFObject]? , error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let activity = activities![0] as! Activity
                var usersArray = activity.usersLikedActivity
                usersArray?.append(userId)
                return activity.saveInBackground { (success, error) in
                    completion(activity, nil)
                }
            }
        }
    }
    
    class func isLikedByUser(actId: String, currentUserId: String, completion: @escaping (Int, Error?) -> Void){
        let query = PFQuery(className: "Activity")
        query.includeKey("_created_at")
        query.includeKey("activityLikedByUsers")
        query.includeKey("activityLikeCount")
        query.addDescendingOrder("_created_at")
        print("Activity ID " + "\(actId)")
        query.whereKey("objectId", equalTo: actId)
        query.findObjectsInBackground{(activities: [PFObject]? , error: Error?) in
            if activities! != [] {
                let activities = activities
                print("ACTIVITIES:", activities![0])
                let activity = activities![0] as! Activity
                var usersArray = activity.usersLikedActivity
                var i = 0
                var userDidLike = 0
                while i < (usersArray?.count)! {
                    let userId = usersArray![i]
                    if userId == currentUserId {
                        userDidLike = userDidLike + 1
                    }
                    i = i + 1
                }
                // If return 0, user doesn't like this activity
                // if return > 0, user likes this activity
                return completion(userDidLike, nil)
            }
        }
    }
    
    class func findCoordinates() -> CLLocation {
        let geocoder = CLGeocoder()
        var longAndLat = CLLocation()
        geocoder.geocodeAddressString("your address") {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            //print("Lat: \(lat), Lon: \(lon)")
            longAndLat = CLLocation(latitude: lat!, longitude: lon!)
            
        }
        return longAndLat
    }
    


}



