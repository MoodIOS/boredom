//
//  List.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation
import Parse

@objc class List: PFObject {
    var listName: String!
    var category: String!
    var rating: Int?
    var author: String!
    
    init (dictionary: [String: Any]) {
        listName = dictionary["listName"] as? String ?? "No name"
        category = dictionary["category"] as? String ?? "No category"
        rating = dictionary["rating"] as? Int ?? 0
        author = dictionary["author"] as? String ?? "No author"
        super.init()
    }
    
    
    
    class func lists(dictionaries: [[String: Any]]) -> [List] {
        var lists: [List] = []
        for dictionary in dictionaries {
            let list = List(dictionary: dictionary)
            lists.append(list)
        }
        return lists
    }
}

