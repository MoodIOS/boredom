//
//  UserListsCell.swift
//  boredom
//
//  Created by jsood on 4/7/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

protocol InfoListButtonDelegate {
    func infoBtnClicked(at index: IndexPath, type: String)
//    func likeBtnClicked(at index: IndexPath, type: String, btn: UIButton)
//    func addBtnClicked (at index: IndexPath, type: String)
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
    
    var delegate: InfoListButtonDelegate!
    var indexPath: IndexPath!
    var listId: String!
    var type: String = "List"
    var listsUserLiked = [String]()
    
    override func awakeFromNib() {
        print("hi")
//        let likeBtn = self.likeBtn.imageView?.image
//        let like = UIImage(named:"heart-gray")
//        let unlike = UIImage(named:"heart-red")
//            self.likeBtn.setImage(unlike, for: .normal)
//        if (likeBtn?.isEqual(like))! {
//             self.likeBtn.setImage(unlike, for: .normal)
//        } else if (likeBtn?.isEqual(unlike))!{
//
//        }
        
    }

    
    @IBAction func infoBtnClicked(_ sender: UIButton) {
        self.delegate.infoBtnClicked(at: indexPath, type: self.type)
    }
 
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        print("like clicked.....")
        let curUser = User.current()
        let likeBtn = self.likeBtn.imageView?.image
        let like = UIImage(named:"heart-red")
        let unlike = UIImage(named:"heart-white")
        
        if (likeBtn?.isEqual(like))! {
            print("just unliked")
            self.likeBtn.setImage(unlike, for: .normal)
            // need to remove the id from array:
            
            User.updateUserLikedList(curUserId: (curUser?.objectId)!, likedList: listId) { (user: User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    
                } else {
                    print("error updating user liked act", error?.localizedDescription)
                }
            }
        } else {
            print("just liked")
            self.likeBtn.setImage(like, for: .normal)
            User.updateUserLikedList(curUserId: (curUser?.objectId)!, likedList: listId) { (user:User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    
                } else {
                    print("error updating user liked act", error?.localizedDescription)
                }
            }
            
        }
        
        
        
    }
    
    @IBAction func addBtnClicked(_ sender: UIButton) {
//        self.delegate.addBtnClicked(at: indexPath, type: self.type)
    }

    func checkForUserLiked(){

    }
}

