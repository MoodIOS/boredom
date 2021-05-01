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
    func addBtnClicked (actsInList: [UserActivity], currentList: List, globalActs: [Activity])
    func emptyListAlert()
    func handleLikedCell(likedId: String)
    func handleAddedCell(addedId: String)
}

protocol ListsInYourListDelegate{
    func handlingDeleteList(at index: IndexPath)
}

class UserListsCell: UICollectionViewCell {
    @IBOutlet weak var profileListsImageView: UIImageView!
    @IBOutlet weak var userListsImageView: UIImageView!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var deleteListBtn: UIButton!
    
    var delegate: InfoListButtonDelegate!
    var delegate2: ListsInYourListDelegate!
    var indexPath: IndexPath!
    var currentList: List!
    var listId: String!
    var type: String = "List"
    var listsUserLiked = [String]()
    var listsUserAdded = [String]()
    var globalActs = [Activity]()
    var userActs = [UserActivity]()
    
    var duplicate: Int!
    override func awakeFromNib() {
        print("hi")
    }
    

    
    @IBAction func onDeleteList(_ sender: UIButton) {
        print("deleting list")
        //alert asking if user want to delete list
        delegate2.handlingDeleteList(at: indexPath)
        
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

            self.delegate.handleLikedCell(likedId: listId)
            
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
            
            self.delegate.handleLikedCell(likedId: listId)
            
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
    
    

    
    @IBAction func addBtnClicked(_ sender: UIButton) {
        /*if let actsInList = currentList.activities{
            self.delegate.addBtnClicked(actsInList: actsInList, currentList: currentList, globalActs: globalActs)
        }else {
            
            self.delegate.emptyListAlert()
        } -- old code, works kinda! */
        
        print("add clicked.....")
        let curUser = User.current()
        let addBtn = self.addBtn.imageView?.image
        let add = UIImage(named:"added")
        let unAdd = UIImage(named:"add-white")
        
        if (addBtn?.isEqual(add))! {
            print("just unliked")
            self.addBtn.setImage(unAdd, for: .normal)
            // need to remove the id from array:
            var newArray = [String]()
            var i = 0
            while i < listsUserAdded.count {
                let id = listsUserAdded[i]
                if listId != id {
                    print(listId, "is different than", id)
                    newArray.append(listsUserAdded[i])
                }
                i = i + 1
            }
            // updating the current data in User in session
            print("newArray", newArray)
            curUser?.addedLists = newArray
            print("current User liked lists", curUser?.addedLists )
            
            //let newLikeCount = currentList.likeCount - 1
            //currentList.likeCount = newLikeCount

            self.delegate.handleAddedCell(addedId: listId)
            
            
            User.updateUserAddedListArray(updateArray:  newArray) { (user: User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                }
            }
            
            

        } else {
            print("just liked")
            self.addBtn.setImage(add, for: .normal)
           // let newLikeCount = currentList.likeCount + 1
          //  currentList.likeCount = newLikeCount
            // updating the current data in User in session
            curUser?.addedLists.append(currentList.objectId!)
            
            self.delegate.handleAddedCell(addedId: listId)
            let addingAlert = UIAlertController(title: "Add Message", message:"Successfully Added List" , preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
            addingAlert.addAction(OKAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(addingAlert, animated: true, completion: nil)
            
            User.updateUserAddedList(curUserId: (curUser?.objectId)!, addedList: listId) { (user:User?, error: Error?) in
                if let user = user {
                    print("update added list successful!", user)
                    
                

                    
                    
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                    
                    let addingAlert = UIAlertController(title: "Add Message", message:"Error: \(error!.localizedDescription)" , preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                    addingAlert.addAction(OKAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(addingAlert, animated: true, completion: nil)
                }
            }
            
        }
        
        

        
//        self.delegate.addBtnClicked(at: indexPath, type: self.type)
    }
    

    func checkForUserLiked(){

    }
}

