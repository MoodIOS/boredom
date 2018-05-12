//
//  UserListsCell.swift
//  boredom
//
//  Created by jsood on 4/7/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

protocol InfoButtonDelegate {
    func infoBtnClicked(at index: IndexPath)
}

class UserListsCell: UICollectionViewCell {
    @IBOutlet weak var userListsImageView: UIImageView!
//    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listName: UILabel!
    
//    @IBOutlet weak var userListsImageView2: UIImageView!
//
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var delegate: InfoButtonDelegate!
    var indexPath: IndexPath!
    
    @IBAction func infoBtnClicked(_ sender: UIButton) {
    }
    
    
    
}

