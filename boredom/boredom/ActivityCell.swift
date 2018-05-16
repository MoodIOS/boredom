//
//  ActivityCell.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/13/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var completionBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    var thisAct = UserActivity()
    var actID = String()
    var currentAct: Activity!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkForCompletion()
    }
    
    func checkForCompletion(){
        if thisAct.done == false {
        // set done = true and change the image to green for done!
        // pop up asking user to either submit a picture or not
            completionBtn.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
        } else {
            completionBtn.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
        }
    }
    
    @IBAction func onLikeAct(_ sender: UIButton) {
        print("like clicked.....")
        let curUser = User.current()
        let actsUserLiked = curUser?.likedActivities
        let likeBtn = self.likeBtn.imageView?.image
        let like = UIImage(named:"heart-red")
        let unlike = UIImage(named:"heart-gray")
        
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
            self.likeCountLabel.text = "\(newLikeCount)"
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
            self.likeCountLabel.text = "\(newLikeCount)"
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
        

    
    @IBAction func onCompleteAct(_ sender: UIButton) {
        if thisAct.done == false {
            // set done = true and change the image to green for done!
            // pop up asking user to either submit a picture or not
            completionBtn.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            let update = thisAct
            update.done = true
            UserActivity.updateUserAct(updatedAct: update) { (userActs: [UserActivity]?, error: Error?) in
                if userActs != nil {
                    print("save userAct",userActs!)
                    
                } else {
                    print("problem updating", error?.localizedDescription)
                }
            }
        } else {
            completionBtn.setImage(#imageLiteral(resourceName: "unchecked"), for: .normal)
            let update = thisAct
            update.done = false
            UserActivity.updateUserAct(updatedAct: update) { (userActs: [UserActivity]?, error: Error?) in
                if userActs != nil {
                    print("save userAct", userActs!)
                } else {
                    print("problem updating", error?.localizedDescription)
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
