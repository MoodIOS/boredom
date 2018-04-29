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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didTapFavoritesBtn(_ sender: Any) {
        print("INSIDE METHOD")
        if(favoritesBtn.imageView?.image?.isEqual(UIImage(named:"favor-icon-1")))!{
            print("INSIDE IF STATEMENT")
            favoritesBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControlState.normal)
            /* THis is all the code that's crashing since tableView is nil...
            let tableView = listViewController.tableView
            let indexPath = tableView?.indexPathForSelectedRow
            var cell = tableView?.cellForRow(at: indexPath!)
            oldLikeCount = listViewController.activities[(indexPath?.row)!].activity.activityLikeCount
            print("............",oldLikeCount)
            listViewController.activities[(indexPath?.row)!].activity.activityLikeCount = (listViewController.activities[(indexPath?.row)!].activity.activityLikeCount) + 1
            newLikeCount = (listViewController.activities[(indexPath?.row)!].activity.activityLikeCount) + 1
            print(newLikeCount)
             */
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
