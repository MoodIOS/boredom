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
   
    @NSManaged
    var actName: String!
    
    @NSManaged
//    var description: String!
    //optional?
    
    var actType: String!
    var author: String!
    
//    init(dictionary: [String: Any]) {
////        actName = dictionary["actName"] as! String
////        description
//
//    }
}
