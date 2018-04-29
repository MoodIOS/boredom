//
//  ActivitiesInListCell.swift
//  boredom
//
//  Created by jsood on 4/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

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
        if(favoritesBtn.imageView?.image?.isEqual(UIImage(named:"favor-icon-1")))!{
            print("INSIDE IF STATEMENT")
            favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
            print("userAct", userAct)
            print("activity", activity)
            oldLikeCount = activity.activityLikeCount
            print("............", oldLikeCount)
            
            //This function is in Activity model, still need to complete the function
//            Activity.changeLikeCount()
            
        }
        else{
            favoritesBtn.setImage(UIImage(named:"favor-icon"), for: UIControlState.normal)
            
            print("INSIDE ELSE STATEMENT")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
