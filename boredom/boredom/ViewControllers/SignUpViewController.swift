//
//  SignUpViewController.swift
//  boredom
//
//  Created by jsood on 4/19/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class SignUpViewController: UIViewController, CLLocationManagerDelegate, ATCWalkthroughViewControllerDelegate{

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpBtn.layer.cornerRadius = 8.0
        signUpBtn.clipsToBounds = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
        
        let walkthroughVC = self.walkthroughVC()
        walkthroughVC.delegate = self
        self.addChildViewControllerWithView(walkthroughVC)
    }
    
    
    @IBAction func hideKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        //self.labelL.text = "\(userLocation.coordinate.latitude)"
        //self.labelLongi.text = "\(userLocation.coordinate.longitude)"
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)
                
                self.locationLabel.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    
    @IBAction func onTapSignUp(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let newUser = User()
        newUser.username = usernameField.text
        newUser.password = userPasswordField.text
        newUser.signUpInBackground{ (success:Bool, error:Error?) -> Void in
            if success{
                print("yay created a new user!")
                self.dismiss(animated: true, completion: nil)
                appDelegate.login()
                
            } else{
                print(error?.localizedDescription)
                if error?._code == 202{
                    print("Username is taken")
                }
            }
        }
    }
    
    @IBAction func onTapCancel(_ sender: Any) {
       // self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let walkthroughs = [
      ATCWalkthroughModel(title: "Create", subtitle: "Make your own lists of activities to do when bored such as hiking, drawing, dinner at a particular restaurant, \n input details and location of activity, \n and save and share it with the rest of the world!", icon: "contact"),
      ATCWalkthroughModel(title: "Discover", subtitle: "Looking for a first-date idea? \n Where to celebrate your birthday? \n What to do on a boring Sunday evening? \n Spark got you! Search through most liked activities and lists for inspiration on what to do. \n Like, save, and share lists of activities!", icon: "flash"),
      ATCWalkthroughModel(title: "Shuffle", subtitle: "Gosh, so many fun things to do, so little time, how to choose? \n Spark's shuffle feature will pick an activity for you based on your chosen preferences like budget and location! \n After picking an activity, we will navigate you to it via google and/or apple maps", icon: "shuffle"),
      ATCWalkthroughModel(title: "Let's Go!", subtitle: "Whatcha waiting for? \n Sign up and explore! :)", icon: "heart-red"),
    ]
    

    
    func walkthroughViewControllerDidFinishFlow(_ vc: ATCWalkthroughViewController) {
      UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
        vc.view.removeFromSuperview()
        //let viewControllerToBePresented = UIViewController()
        //self.view.addSubview(viewControllerToBePresented.view)
      }, completion: nil)
    }
    
    fileprivate func walkthroughVC() -> ATCWalkthroughViewController {
      let viewControllers = walkthroughs.map { ATCClassicWalkthroughViewController(model: $0, nibName: "ATCClassicWalkthroughViewController", bundle: nil) }
      return ATCWalkthroughViewController(nibName: "ATCWalkthroughViewController",
                                          bundle: nil,
                                          viewControllers: viewControllers)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
