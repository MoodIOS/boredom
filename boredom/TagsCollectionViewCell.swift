//
//  TagsCollectionViewCell.swift
//  boredom
//
//  Created by jsood on 5/13/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

protocol TagsCollectionViewCellDelegate: class {
    func tagCellButtonPressed(data: Bool, button: UIButton)
}

class TagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagBtn: UIButton!
    var tagBtnClicked:Bool!
    var tags: [String] = ["Restaurant", "Brunch", "Movie", "Outdoor", "Book", "Coffee", "Nightlife", "Happy hours"]
    var tagsBool =  [String: Bool]()
    var delegate: TagsCollectionViewCellDelegate? = nil
    
    @IBAction func onTapTagBtn(_ sender: Any) {
        handleTagsFilter(button: tagBtn)
        tagBtnClicked = true
        
        if delegate != nil
        {
            let data = true
            
            delegate?.tagCellButtonPressed(data: data, button: tagBtn)
                
            
        }
        /*if(tagBtn.backgroundColor == UIColor.yellow)
        {
            tagBtn.backgroundColor = UIColor.blue
            tagBtnClicked = false
        }
        else{
            tagBtn.backgroundColor = UIColor.yellow
            tagBtnClicked = true
        }*/
    }
    
    func handleTagsFilter(button : UIButton){
        print("button sender ", button.backgroundColor!)
        let blueColor = UIColor.init(red: 0, green: 122/255, blue:1 , alpha: 1)
        let grayColor = UIColor.lightGray
        print("blueColor", blueColor)
        print("grayColor", grayColor)
        handleTags(tagName: button.currentTitle!) { (tags: [String: Bool]?, error: Error?) in
            for (tag, value) in tags!{
                if (value == true) && (button.currentTitle == tag)  {
                    button.backgroundColor = UIColor.init(red: 0, green: 122/255, blue:1 , alpha: 1)
                } else if (value == false) && (button.currentTitle == tag) {
                    button.backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    
    func handleTags (tagName: String, completion: @escaping ([String:Bool]?, Error? ) -> Void){
        print("handleTag: ", tagName)
        if tagsBool[tagName] == false || tagsBool[tagName] == nil {
            tagsBool[tagName] = true
        } else {
            tagsBool[tagName] = false
        }
        print("tags: ", tags)
        return completion(tagsBool, nil)
        
    }
    
}
