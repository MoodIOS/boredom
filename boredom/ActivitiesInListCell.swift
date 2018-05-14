//
//  ActivitiesInListCell.swift
//  boredom
//
//  Created by jsood on 4/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class ActivitiesInListCell: UITableViewCell {

    @IBOutlet weak var favoritesBtn: UIButton!
    
    @IBOutlet weak var activityNameLabel: UILabel!
    
    
    var listViewController: ListsDetailViewController!
    var oldLikeCount:Int!
    var newLikeCount:Int!
    
    var activity: Activity!
    var userAct: UserActivity!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    

    @IBAction func didTapFavoritesBtn(_ sender: Any) {
        print("INSIDE METHOD")
        //if means we pressed the like button
        if(favoritesBtn.imageView?.image?.isEqual(UIImage(named:"heart-gray")))!{
           
            print("INSIDE IF STATEMENT")
            favoritesBtn.setImage(UIImage(named:"heart-red"), for: UIControlState.normal)
            print("userAct", userAct)
            print("activity", activity)
            oldLikeCount = activity.activityLikeCount
            print("............old like count is: ", oldLikeCount)
            
            Activity.changeLikeCount(actId: activity.objectId!, likeCount: activity.activityLikeCount) { (activities: [Activity]?, error: Error?) in
                if activities! != []{
                    let activities = activities
                    print("ACTIVITIES:", activities![0])
                    let activity = activities![0]
                    activity.activityLikeCount = activity.activityLikeCount + 1
                    self.newLikeCount = activity.activityLikeCount
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
            print("....................new like count is: ", newLikeCount)
            
            
        }
        else{ //else means we pressed the like button again, hence, unlike
            
            favoritesBtn.setImage(UIImage(named:"heart-gray"), for: UIControlState.normal)
            Activity.changeLikeCount(actId: activity.objectId!, likeCount: activity.activityLikeCount) { (activities: [Activity]?, error: Error?) in
                if activities! != []{
                    let activities = activities
                    print("ACTIVITIES:", activities![0])
                    let activity = activities![0]
                    activity.activityLikeCount = activity.activityLikeCount - 1
                    self.newLikeCount = activity.activityLikeCount
                    activity.saveInBackground()
                }
            }
            
            
            var indexOfUser = 0
            while indexOfUser < activity.activityLikedByUsers.count{
                if activity.activityLikedByUsers[indexOfUser] == PFUser.current()?.objectId{
                    print("INSIDE REMOVE IF.........")
                    activity.activityLikedByUsers.remove(at: indexOfUser)
                    activity.saveInBackground()
                }
                indexOfUser = (indexOfUser + 1)
            }
            print("INSIDE ELSE STATEMENT")
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       

        // Configure the view for the selected state
    }

}
