//
//  User.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation
class User {
    
    var name: String
    var userDict: [String: Any]
    var username: String
    var userEmail: String
    var profileImageURL: String
    var password: String
//    var userCoordinate: CGPoint!
    var userLocation: String
    
    // Define this:
    var randomActivity: Activity!
    
    private static var _current: User?
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
    }
    
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as! String
        username = dictionary["username"] as! String
        self.userDict = dictionary
        profileImageURL = dictionary["profileImageURL"] as! String
        password = dictionary["password"] as! String
        userEmail = dictionary["userEmail"] as!  String
        userLocation = dictionary["userLocation"] as! String

    }
}
