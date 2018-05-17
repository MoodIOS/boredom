//
//  TagsCollectionViewCell.swift
//  boredom
//
//  Created by jsood on 5/13/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagBtn: UIButton!
    
    @IBAction func onTapTagBtn(_ sender: Any) {
        tagBtn.backgroundColor = UIColor.yellow
    }
    
}
