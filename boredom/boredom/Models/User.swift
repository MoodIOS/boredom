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
    
    /*var name: String
    
    //var username: String //commented out because changed to type PFUser
    var userEmail: String
    var profileImageURL: String
    //var password: String //commented out because changed to type PFUser
//    var userCoordinate: CGPoint!
    var userLocation: String
    
    // Define this:
    var randomActivity: Activity!
    */
    //var userDict: [String: Any]
    @NSManaged var likedActivity: [String]
    @NSManaged var profileImage : PFFile
    
    /*override class func parseClassName() -> String {
        return "PFUser"
    }*/
    
    //static var current = PFUser.current()
    /*private static var _current: User?
    static var current: User?{
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.userDict, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }*/
    
    
    //init(dictionary: [String: Any]) {
        /*name = dictionary["name"] as! String
        //username = dictionary["username"] as! String
        
        profileImageURL = dictionary["profileImageURL"] as! String
        //password = dictionary["password"] as! String
        userEmail = dictionary["userEmail"] as!  String
        userLocation = dictionary["userLocation"] as! String
 */
        //self.userDict = dictionary
        //likedActivity = dictionary["likeActivity"] as! [String]
        
        //profileImage = dictionary["profileImage"] as! PFFile
    //}
    override init() {
        super.init()
    }
    
    /*public func currentUser() -> User {
        return PFUser.current() as! User
    }*/
    
    class func updateUserLikedAct(curUserId: String, likedAct: String, completion: (User?, Error?) -> Void ){
        current()?.likedActivity.append(likedAct)
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
