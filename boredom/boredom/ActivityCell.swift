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
        
        print("INSIDE METHOD")
        //if means we pressed the like button
        if (likeBtn.imageView?.image?.isEqual(UIImage(named:"favor-icon-1")))!{
            
            print("INSIDE IF STATEMENT")
            likeBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
            print("userAct", thisAct)
            //print("activity", activity)
            //oldLikeCount = activity.activityLikeCount
            //print("............old like count is: ", oldLikeCount)
            
            Activity.changeLikeCount(actId: thisAct.activity.objectId!, likeCount: thisAct.activity.activityLikeCount) { (activities: [Activity]?, error: Error?) in
                if activities! != []{
                    let activities = activities
                    print("ACTIVITIES:", activities![0])
                    let activity = activities![0]
                    activity.activityLikeCount = activity.activityLikeCount + 1
                    self.likeCountLabel.text = String(describing: activity.activityLikeCount)
                    //self.newLikeCount = activity.activityLikeCount
                    let currUser = PFUser.current()
                    var count = 0
                    if(!activity.activityLikedByUsers.isEmpty)
                    {
                        count = activity.activityLikedByUsers.count - 1
                    }
                    print("...........", (currUser?.objectId)!)
                    
                    activity.activityLikedByUsers.append((currUser?.objectId)!)
                    activity.saveInBackground()
                }
            }
            
            //newLikeCount = activity.activityLikeCount
            //print("....................new like count is: ", newLikeCount)
            
            
        }
        else{ //else means we pressed the like button again, hence, unlike
            
            likeBtn.setImage(UIImage(named:"favor-icon-1"), for: UIControlState.normal)
            Activity.changeLikeCount(actId: thisAct.activity.objectId!, likeCount: thisAct.activity.activityLikeCount) { (activities: [Activity]?, error: Error?) in
                if activities! != []{
                    let activities = activities
                    print("ACTIVITIES:", activities![0])
                    let activity = activities![0]
                    activity.activityLikeCount = activity.activityLikeCount - 1
                    self.likeCountLabel.text = String(describing: activity.activityLikeCount)
                    //self.newLikeCount = activity.activityLikeCount
                    activity.saveInBackground()
                }
            }
            
            
            var indexOfUser = 0
            while indexOfUser < thisAct.activity.activityLikedByUsers.count{
                if thisAct.activity.activityLikedByUsers[indexOfUser] == PFUser.current()?.objectId{
                    print("INSIDE REMOVE IF.........")
                    thisAct.activity.activityLikedByUsers.remove(at: indexOfUser)
                    thisAct.activity.saveInBackground()
                }
                indexOfUser = (indexOfUser + 1)
            }
            print("INSIDE ELSE STATEMENT")
        }
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
