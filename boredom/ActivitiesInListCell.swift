//
//  ActivitiesInListCell.swift
//  boredom
//
//  Created by jsood on 4/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

protocol AddSomeActDelegate {
    func handleAddingAct (at index: IndexPath)
}


class ActivitiesInListCell: UITableViewCell {

    @IBOutlet weak var favoritesBtn: UIButton!
    
    @IBOutlet weak var activityNameLabel: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var costLabel: UILabel!
    
    
    var listViewController: ListsDetailViewController!
    var oldLikeCount:Int!
    var newLikeCount:Int!
    
    var activity: Activity!
    var userAct: UserActivity!
    
    var delegate: AddSomeActDelegate!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }


    @IBAction func onAddingAct(_ sender: UIButton) {
        
        
        self.delegate.handleAddingAct(at: indexPath)

    }

    
    
    @IBAction func didTapFavoritesBtn(_ sender: Any) {
        print("like clicked.....")
        let curUser = User.current()
        let actsUserLiked = curUser?.likedActivities
        let likeBtn = self.favoritesBtn.imageView?.image
        let like = UIImage(named:"heart-red")
        let unlike = UIImage(named:"heart-gray")
        
        if (likeBtn?.isEqual(like))! {
            print("just unliked")
            self.favoritesBtn.setImage(unlike, for: .normal)
            // need to remove the id from array:
            var newArray = [String]()
            var i = 0
            let actID = activity.objectId
            while i < (actsUserLiked?.count)! {
                let id = actsUserLiked![i]
                if actID != id {
                    print(actID!, "is different than", id)
                    newArray.append(actsUserLiked![i])
                }
                i = i + 1
            }
            print("newArray", newArray)
            let curUser = User.current()
            curUser?.likedLists = newArray
            print("current User liked lists", curUser?.likedLists )
            
            let newLikeCount = activity.activityLikeCount - 1
            activity.activityLikeCount = newLikeCount
            self.likeCount.text = "\(newLikeCount)"
            Activity.updateActivityLikeCount(updateAct: activity) { (act: Activity?, error: Error?) in
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
            self.favoritesBtn.setImage(like, for: .normal)
            let newLikeCount = activity.activityLikeCount + 1
            activity.activityLikeCount = newLikeCount
            self.likeCount.text = "\(newLikeCount)"
            Activity.updateActivityLikeCount(updateAct: activity) { (act: Activity?, error: Error?) in
                if error == nil{
                    print("update list:", act!)
                } else {
                    print("error updating user liked list", "\(String(describing: error?.localizedDescription))")
                }
            }
            User.updateUserLikedAct(curUserId: (curUser?.objectId)!, likedAct: activity.objectId!) { (user: User?, error: Error?) in
                if let user = user {
                    print("user", user)
                } else {
                    print("error updating user liked act", "\(String(describing: error?.localizedDescription))")
                }
            }
            
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       

        // Configure the view for the selected state
    }

}
