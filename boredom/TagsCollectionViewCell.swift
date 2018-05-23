//
//  TagsCollectionViewCell.swift
//  boredom
//
//  Created by jsood on 5/13/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

protocol TagsCollectionViewCellDelegate: class {
//    func tagCellButtonPressed(data: Bool, button: UIButton)
    func handleTagsFilter(button : UIButton)
}

class TagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagBtn: UIButton!
    
    var tagBtnClicked:Bool!
    var tags: [String] = ["Restaurant", "Brunch", "Movie", "Outdoor", "Book", "Coffee", "Nightlife", "Happy hours"]
    var tagsBool =  [String: Bool]()
    var delegate: TagsCollectionViewCellDelegate!
    
    override func awakeFromNib() {
        tagBtn.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        tagBtn.layer.cornerRadius = 7
        tagBtn.layer.borderWidth = 1
        tagBtn.layer.borderColor = UIColor(displayP3Red: 255/255, green: 193/255, blue: 0.0, alpha: 1.0).cgColor
    }
    
    @IBAction func onTapTagBtn(_ sender: UIButton) {

        self.delegate?.handleTagsFilter(button: tagBtn)

    }
    
    
}
