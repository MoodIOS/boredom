//
//  ActivitiesCell.swift
//  boredom
//
//  Created by jsood on 4/8/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

protocol InfoActButtonDelegate {
    func infoBtnClicked(at index: IndexPath, type: String)
//    func likeBtnClicked(at index: IndexPath, type: String, btn: UIButton)
//    func addBtnClicked (at index: IndexPath, type: String)
}

class ActivitiesCell: UICollectionViewCell {
    
    @IBOutlet weak var activitiesImageView: UIImageView!
    @IBOutlet weak var activityName: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var delegate: InfoActButtonDelegate!
    var indexPath: IndexPath!
    var actId: String!
    var type: String! = "Act"
    var img: URL!
    var actsIdLike = [String]()
    
    @IBAction func infoBtnClicked(_ sender: UIButton) {
        self.delegate.infoBtnClicked(at: indexPath, type: self.type)
    }
    
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        print("like clicked")
        let curUser = User.current()
        let likeBtn = self.likeBtn.imageView?.image
        let like = UIImage(named:"heart-gray")
        let unlike = UIImage(named:"heart-red")
        if (likeBtn?.isEqual(like))! {
            self.likeBtn.setImage(unlike, for: .normal)
            User.updateUserLikedAct(curUserId: (curUser?.objectId)!, likedAct: actId) { (user:User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    
                } else {
                    print("error updating user liked act", error?.localizedDescription)
                }
            }
        } else if (likeBtn?.isEqual(unlike))!{
            self.likeBtn.setImage(like, for: .normal)
            User.updateUserLikedAct(curUserId: (curUser?.objectId)!, likedAct: actId) { (user:User?, error: Error?) in
                if let user = user {
                    print("user", user)
                    
                } else {
                    print("error updating user liked act", error?.localizedDescription)
                }
            }
            
        }
    }
    
    
    @IBAction func addBtnClicked(_ sender: UIButton) {
//        self.delegate.addBtnClicked(at: indexPath, type: self.type)
    }
    
    
}
