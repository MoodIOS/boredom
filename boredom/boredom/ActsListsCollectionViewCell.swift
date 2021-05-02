//
//  ActsListsCollectionViewCell.swift
//  boredom
//
//  Created by Jigyasaa Sood on 5/1/21.
//  Copyright © 2021 Codacity LLC. All rights reserved.
//

import UIKit

class ActsListsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var actsListsNameLabel: UILabel!
    @IBOutlet weak var actsListsImgView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var likedCountLabel: UILabel!
    
    var thisAct = UserActivity()
    var actID = String()
    var currentAct: Activity!
    
    var currentList: List!
    var listId: String!
    var type: String = "List"
    var listName: String!
    var listsUserLiked = [String]()
    var inListView:Bool!
    
    
    @IBAction func likeBtnTapped(_ sender: Any) {
        if inListView != nil && inListView == false {
        print("like clicked.....")
        let curUser = User.current()
        let actsUserLiked = curUser?.likedActivities
        let likeBtn = self.likeBtn.imageView?.image
        let like = UIImage(named:"heart-red")
        let unlike = UIImage(named:"heart-white")
        
        if (likeBtn?.isEqual(like))! {
            print("just unliked")
            self.likeBtn.setImage(unlike, for: .normal)
            // need to remove the id from array:
            var newArray = [String]()
            var i = 0
            while i < (actsUserLiked?.count)! {
                let id = actsUserLiked![i]
                if actID != id {
                    print(actID, "is different than", id)
                    newArray.append(actsUserLiked![i])
                }
                i = i + 1
            }
            print("newArray", newArray)
            let curUser = User.current()
            curUser?.likedLists = newArray
            print("current User liked lists", curUser?.likedLists )
            
            let newLikeCount = currentAct.activityLikeCount - 1
            currentAct.activityLikeCount = newLikeCount
            self.likedCountLabel.text = "\(newLikeCount)"
            Activity.updateActivityLikeCount(updateAct: currentAct) { (act: Activity?, error: Error?) in
                if error == nil{
                    print("update list:", act)
                } else {
                    print("error updating user liked list", "\(String(describing: error?.localizedDescription))")
                }
            }
            
            User.updateUserActArray(updateArray: newArray) { (user: User?, error: Error?) in
                if let user = user {
                    print("user", user)
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                }
            }
            
        } else {
            print("just liked")
            self.likeBtn.setImage(like, for: .normal)
            let newLikeCount = currentAct.activityLikeCount + 1
            currentAct.activityLikeCount = newLikeCount
            self.likedCountLabel.text = "\(newLikeCount)"
            Activity.updateActivityLikeCount(updateAct: currentAct) { (act: Activity?, error: Error?) in
                if error == nil{
                    print("update list:", act!)
                } else {
                    print("error updating user liked list", "\(String(describing: error?.localizedDescription))")
                }
            }
            User.updateUserLikedAct(curUserId: (curUser?.objectId)!, likedAct: actID) { (user: User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                }
            }
            
        }
        }
        
        else{
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
                self.likedCountLabel.text = "\(newLikeCount)"

               // self.delegate.handleLikedCell(likedId: listId)
                
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
                self.likedCountLabel.text = "\(newLikeCount)"
               // self.delegate.handleLikedCell(likedId: listId)
                
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
                        
                    } else {
                        print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                    }
                }
                
            }
        }
        
    }
        
}
