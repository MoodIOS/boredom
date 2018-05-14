//
//  User.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation
import Parse

class User: PFUser {
    

    @NSManaged var likedActivities: [String]
    @NSManaged var likedLists: [String]
    @NSManaged var profileImage : PFFile

    
    override init() {
        super.init()
    }
    

    
    class func updateUserLikedAct(curUserId: String, likedAct: String, completion: (User?, Error?) -> Void ){
        let user = current()
        user?.likedActivities.append(likedAct)
        user?.saveInBackground()
    }
    
    class func updateUserLikedList(curUserId: String, likedList: String, completion: (User?, Error?) -> Void ){
        let user = current()
        user?.likedLists.append(likedList)
        user?.saveInBackground()
    }
    
    class func updateUserListArray(updateArray: [String], completion: (User?, Error?) -> Void ){
        let user = current()
        user?.likedLists = updateArray
        user?.saveInBackground()
    }
    
    class func updateUserActArray(updateArray: [String], completion: (User?, Error?) -> Void ){
        let user = current()
        user?.likedActivities = updateArray
        user?.saveInBackground()
    }
    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    class func makeProfPic(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        
        // Add relevant fields to the object
        current()?.profileImage = getPFFileFromImage(image: image)! // PFFile column type

        
        // Save object (following function will save the object in Parse asynchronously)
        current()?.saveInBackground(block: completion)
        //return true
    }
}
