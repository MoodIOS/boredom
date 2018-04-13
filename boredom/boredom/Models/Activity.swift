//
//  Activity.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation
import Parse

@objc class Activity: PFObject {
    var actName: String!
    var actDescription: String!
    var actType: String!
    var author: String!
    
    init (dictionary: [String: Any]) {
        actType = dictionary["listName"] as? String ?? "No name"
        actDescription = dictionary["category"] as? String ?? "No description"
        actType = dictionary["rating"] as? String ?? "No activity type"
        author = dictionary["author"] as? String ?? "No author"
        super.init()
    }
    
    class func activities(dictionaries: [[String: Any]]) -> [Activity] {
        var list: [Activity] = []
        for dictionary in dictionaries {
            let activity = Activity(dictionary: dictionary)
            list.append(activity)
        }
        return list
    }
}



