//
//  ActivitiesCell.swift
//  boredom
//
//  Created by jsood on 4/8/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

protocol InfoActButtonDelegate {
    func infoBtnClicked(at index: IndexPath, type: String)
//    func likeBtnClicked(at index: IndexPath, type: String, btn: UIButton)
    func addBtnClicked (at index: IndexPath, type: String)
}

class ActivitiesCell: UICollectionViewCell {
    
    @IBOutlet weak var activitiesImageView: UIImageView!
    @IBOutlet weak var activityName: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var delegate: InfoActButtonDelegate!
    var indexPath: IndexPath!
    var currentAct: Activity!
    var actId: String!
    var type: String! = "Act"
    var img: URL!
    var actsIdLike = [String]()
    
    @IBAction func infoBtnClicked(_ sender: UIButton) {
        self.delegate.infoBtnClicked(at: indexPath, type: self.type)
    }
    
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        print("like clicked")
        let curUser = User.current()
        let likeBtn = self.likeBtn.imageView?.image
        let like = UIImage(named:"heart-red")
        let unlike = UIImage(named:"heart-white")
        if (likeBtn?.isEqual(like))! {
            self.likeBtn.setImage(unlike, for: .normal)
            var newArray = [String]()
            var i = 0
            while i < actsIdLike.count {
                let id = actsIdLike[i]
                if actId != id {
                    print(actId, "is different than", id)
                    newArray.append(actsIdLike[i])
                }
                i = i + 1
            }
            print("newArray", newArray)
            let curUser = User.current()
            curUser?.likedActivities = newArray
            print("current User liked lists", curUser?.likedActivities)
            let newLikeCount = currentAct.activityLikeCount - 1
            currentAct.activityLikeCount = newLikeCount
            Activity.updateActivityLikeCount(updateAct: currentAct) { (activity: Activity?, error: Error?) in
                if error == nil{
                    print("activity", activity!)
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))" )
                }
            }
            User.updateUserActArray(updateArray: newArray) { (user: User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                }
            }

        } else if (likeBtn?.isEqual(unlike))!{
            self.likeBtn.setImage(like, for: .normal)
            curUser?.likedActivities.append(actId)
            let newLikeCount = currentAct.activityLikeCount +  1
            currentAct.activityLikeCount = newLikeCount
            Activity.updateActivityLikeCount(updateAct: currentAct) { (activity: Activity?, error: Error?) in
                if error == nil{
                    print("activity", activity!)
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                }
            }
            User.updateUserLikedAct(curUserId: (curUser?.objectId)!, likedAct: actId) { (user:User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                }
            }
            
        }
    }
    
    
    @IBAction func addBtnClicked(_ sender: UIButton) {
        self.delegate.addBtnClicked(at: indexPath, type: self.type)
    }
    
    
}
