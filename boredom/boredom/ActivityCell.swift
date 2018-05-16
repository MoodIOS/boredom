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
        
        
        
        
        
//        print("INSIDE METHOD")
//        //if means we pressed the like button
//        if (likeBtn.imageView?.image?.isEqual(UIImage(named:"favor-icon-1")))!{
//
//            print("INSIDE IF STATEMENT")
//            likeBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
//            print("userAct", thisAct)
//            //print("activity", activity)
//            //oldLikeCount = activity.activityLikeCount
//            //print("............old like count is: ", oldLikeCount)
//
//            Activity.changeLikeCount(actId: thisAct.activity.objectId!, likeCount: thisAct.activity.activityLikeCount) { (activities: [Activity]?, error: Error?) in
//                if activities! != []{
//                    let activities = activities
//                    print("ACTIVITIES:", activities![0])
//                    let activity = activities![0]
//                    activity.activityLikeCount = activity.activityLikeCount + 1
//                    self.likeCountLabel.text = String(describing: activity.activityLikeCount)
//                    //self.newLikeCount = activity.activityLikeCount
//                    let currUser = PFUser.current()
//                    var count = 0
//                    if(!activity.activityLikedByUsers.isEmpty)
//                    {
//                        count = activity.activityLikedByUsers.count - 1
//                    }
//                    print("...........", (currUser?.objectId)!)
//
//                    activity.activityLikedByUsers.append((currUser?.objectId)!)
//                    activity.saveInBackground()
//                }
//            }
//
//            //newLikeCount = activity.activityLikeCount
//            //print("....................new like count is: ", newLikeCount)
//
//
//        }
//        else{ //else means we pressed the like button again, hence, unlike
//
//            likeBtn.setImage(UIImage(named:"favor-icon-1"), for: UIControlState.normal)
//            Activity.changeLikeCount(actId: thisAct.activity.objectId!, likeCount: thisAct.activity.activityLikeCount) { (activities: [Activity]?, error: Error?) in
//                if activities! != []{
//                    let activities = activities
//                    print("ACTIVITIES:", activities![0])
//                    let activity = activities![0]
//                    activity.activityLikeCount = activity.activityLikeCount - 1
//                    self.likeCountLabel.text = String(describing: activity.activityLikeCount)
//                    //self.newLikeCount = activity.activityLikeCount
//                    activity.saveInBackground()
//                }
//            }
//
//
//            var indexOfUser = 0
//            while indexOfUser < thisAct.activity.activityLikedByUsers.count{
//                if thisAct.activity.activityLikedByUsers[indexOfUser] == PFUser.current()?.objectId{
//                    print("INSIDE REMOVE IF.........")
//                    thisAct.activity.activityLikedByUsers.remove(at: indexOfUser)
//                    thisAct.activity.saveInBackground()
//                }
//                indexOfUser = (indexOfUser + 1)
//            }
//            print("INSIDE ELSE STATEMENT")
//        }
    }
        
        
        
//        print("INSIDE METHOD")
//        //if means we pressed the like button
//        if(favoritesBtn.imageView?.image?.isEqual(UIImage(named:"favor-icon-1")))!{
//
//            print("INSIDE IF STATEMENT")
//            favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
//            print("userAct", userAct)
//            print("activity", activity)
//            oldLikeCount = activity.activityLikeCount
//            print("............old like count is: ", oldLikeCount)
//
//            Activity.changeLikeCount(actId: activity.objectId!, likeCount: activity.activityLikeCount) { (activities: [Activity]?, error: Error?) in
//                if activities! != []{
//                    let activities = activities
//                    print("ACTIVITIES:", activities![0])
//                    let activity = activities![0]
//                    activity.activityLikeCount = activity.activityLikeCount + 1
//                    self.newLikeCount = activity.activityLikeCount
//                    let currUser = PFUser.current()
//                    var count = 0
//                    if(!activity.activityLikedByUsers.isEmpty)
//                    {
//                        count = activity.activityLikedByUsers.count - 1
//                    }
//                    print("...........", (currUser?.objectId)!)
//                    //var mergeString = ["userid": (currUser?.objectId)!]
//                    /*let newItem: [String: Any] = [
//                     "key": (currUser?.objectId)!
//                     ]*/
//
//                    //activity.activityLikedByUsers.insert((currUser?.objectId)!, at: count)
//                    //activity.activityLikedByUsers.append((currUser?.objectId)!)
//                    //activity.activityLikedByUsers.merge(mergeString, uniquingKeysWith: (Any, Any) -> Any)
//                    activity.activityLikedByUsers.append((currUser?.objectId)!)
//                    activity.saveInBackground()
//                }
//            }
//
//            //newLikeCount = activity.activityLikeCount
//            print("....................new like count is: ", newLikeCount)
//
//
//        }
//        else{ //else means we pressed the like button again, hence, unlike
//
//            favoritesBtn.setImage(UIImage(named:"favor-icon-1"), for: UIControlState.normal)
//            Activity.changeLikeCount(actId: activity.objectId!, likeCount: activity.activityLikeCount) { (activities: [Activity]?, error: Error?) in
//                if activities! != []{
//                    let activities = activities
//                    print("ACTIVITIES:", activities![0])
//                    let activity = activities![0]
//                    activity.activityLikeCount = activity.activityLikeCount - 1
//                    self.newLikeCount = activity.activityLikeCount
//                    activity.saveInBackground()
//                }
//            }
//
//
//            var indexOfUser = 0
//            while indexOfUser < activity.activityLikedByUsers.count{
//                if activity.activityLikedByUsers[indexOfUser] == PFUser.current()?.objectId{
//                    print("INSIDE REMOVE IF.........")
//                    activity.activityLikedByUsers.remove(at: indexOfUser)
//                    activity.saveInBackground()
//                }
//                indexOfUser = (indexOfUser + 1)
//            }
//            print("INSIDE ELSE STATEMENT")
//        }
    
    
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
