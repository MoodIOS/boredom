//
//  ATCClassicWalkthroughViewController.swift
// 
//

import UIKit

class ATCClassicWalkthroughViewController: UIViewController {
  @IBOutlet var containerView: UIView!
  @IBOutlet var imageContainerView: UIView!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var subtitleLabel: UILabel!
  
  let model: ATCWalkthroughModel
  
  init(model: ATCWalkthroughModel,
       nibName nibNameOrNil: String?,
       bundle nibBundleOrNil: Bundle?) {
    self.model = model
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = UIImage.localImage(model.icon, template: true)
    //imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.tintColor = .white
    if(model.icon == "heart-red"){
        imageView.tintColor = .red
    }
    
    imageContainerView.backgroundColor = .clear
    
    titleLabel.text = model.title
    titleLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
    titleLabel.textColor = UIColor(displayP3Red: 137/255, green: 147/255, blue: 241/255, alpha: 1.0)
    
    subtitleLabel.attributedText = NSAttributedString(string: model.subtitle)
    subtitleLabel.font = UIFont.systemFont(ofSize: 18.0)
    subtitleLabel.textColor = .white
    
    containerView.backgroundColor = UIColor(displayP3Red: 44/255, green: 47/255, blue: 51/255, alpha: 1.0)
  }
}
