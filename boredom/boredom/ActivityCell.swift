//
//  ActivityCell.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/13/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var completionBtn: UIButton!
    
    var thisAct = UserActivity()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func onLikeAct(_ sender: UIButton) {
        
    }
    
    @IBAction func onCompleteAct(_ sender: UIButton) {
        if let userAct = thisAct as? UserActivity{
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
