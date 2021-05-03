//
//  OverlayView.swift
//  boredom
//
//  Created by Jigyasaa Sood on 5/2/21.
//  Copyright © 2021 Codacity LLC. All rights reserved.
//

import UIKit
import Parse

class OverlayView: UIViewController {
    
    
    

    @IBOutlet weak var locationIcon: UIImageView!
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var activity: Activity!
    var list: List!
    
    @IBOutlet weak var slideIdicator: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
       // subscribeButton.roundCorners(.allCorners, radius: 10)
        
       
                       
            
            if (self.activity != nil){
                self.descriptionLabel.text = self.activity.actDescription ?? ""
                self.nameLabel.text = self.activity.actName ?? ""
                self.locationLabel.text = "📍 \(self.activity.location ?? "")"
            
                    var tagsArr = [String]()
                        for (tag, tagValue) in self.activity.tags {
                        if tagValue == true {
                            tagsArr.append(tag)
                        }
                    }
            
                self.tagsLabel.text = tagsArr.joined(separator: ", ")
                
                let pfFileImage = self.activity.backgroundImg
                pfFileImage?.getDataInBackground{(imageData, error) in
                 if(error == nil){
                     if let imageData = imageData{
                         let img = UIImage(data: imageData)
                        self.imageView.image = img
                        self.imageView.alpha = 0.7
                     }
                 }
            
            
                switch self.activity.cost {
            case 1:
                self.costLabel.text = "$"
            case 2:
                self.costLabel.text = "$$"
            case 3:
                self.costLabel.text = "$$$"
            case 4:
                self.costLabel.text = "$$$$"
            default:
                self.costLabel.text = "$"
            }
            
                self.likeCountLabel.text = String(self.activity.activityLikeCount)
                
                
            
            }
                
                if User.current() != nil {
                    if User.current()?.likedActivities.contains(self.activity.objectId!) == true {
                        self.likeBtn.setImage(UIImage(named:"heart-red"), for: .normal)
                    }
                    else{
                        self.likeBtn.setImage(UIImage(named:"heart-white"), for: .normal) 
                    }
                }
                
            }
            
           
       
            
        
        
        
    }
        
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
        

        
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }

}
