//
//  UserListsCell.swift
//  boredom
//
//  Created by jsood on 4/7/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse


protocol InfoListButtonDelegate {
    func infoBtnClicked(at index: IndexPath, type: String)
//    func likeBtnClicked(at index: IndexPath, type: String, btn: UIButton)
    func addBtnClicked (adding: Bool, type: String, message: String)
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
    var currentList: List!
    var listId: String!
    var type: String = "List"
    var listsUserLiked = [String]()
    var globalAct = [Activity]()
        
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
            var newArray = [String]()
            var i = 0
            while i < listsUserLiked.count {
                let id = listsUserLiked[i]
                if listId != id {
                    print(listId, "is different than", id)
                    newArray.append(listsUserLiked[i])
                }
                i = i + 1
            }
            // updating the current data in User in session
            print("newArray", newArray)
            curUser?.likedLists = newArray
            print("current User liked lists", curUser?.likedLists )
            
            let newLikeCount = currentList.likeCount - 1
            currentList.likeCount = newLikeCount
            List.updateListLikeCount(updateList: currentList) { (list: List?, error: Error?) in
                if error == nil{
                    print("update list:", list)
                } else {
                    print("error updating user liked list", "\(String(describing: error?.localizedDescription))")
                }
            }
            
            
            User.updateUserListArray(updateArray: newArray) { (user: User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                }
            }

        } else {
            print("just liked")
            self.likeBtn.setImage(like, for: .normal)
            let newLikeCount = currentList.likeCount + 1
            currentList.likeCount = newLikeCount
            // updating the current data in User in session
            curUser?.likedLists.append(currentList.objectId!)
            List.updateListLikeCount(updateList: currentList) { (list: List?, error: Error?) in
                if error == nil{
                    print("update list:", list)
                } else {
                    print("error updating user liked list", "\(String(describing: error?.localizedDescription))")
                }
            }
            User.updateUserLikedList(curUserId: (curUser?.objectId)!, likedList: listId) { (user:User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    let curUser = User.current()
                    curUser?.likedLists = user.likedLists
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                }
            }
            
        }
        
        
        
    }
    
    @IBAction func addBtnClicked(_ sender: UIButton) {
        
        let actsInList = currentList.activities
        print("actInList", actsInList!)
        if actsInList! != [] {
            List.addNewList(name: currentList.listName, category: currentList.category, likeCount: 0, activities: actsInList) { (addedList: List?, error: Error?) in
                if (addedList != nil) {
                    print("List created!")
                    print("copy list", addedList!)
                    print("Add Btn globalAct", self.globalAct)
                    for act in self.globalAct {
                        UserActivity.addNewActivity(activity: act, list: addedList, completion: { (userAct: UserActivity?, error: Error?) in
                            if error == nil {
                                print ("userAct", userAct!)
                                self.delegate.addBtnClicked(adding: true, type: "List", message: "You have successfully added this item to your account")
                            }
                        })
                    }
                } else if let error = error {
                    self.delegate.addBtnClicked(adding: true, type: "List", message: "Error Adding: \(error.localizedDescription)")
//                    print("Problem saving list: \(error.localizedDescription)")
                }
            }
        }

        
//        self.delegate.addBtnClicked(at: indexPath, type: self.type)
    }

    func checkForUserLiked(){

    }
}

