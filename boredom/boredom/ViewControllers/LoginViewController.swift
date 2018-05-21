//
//  ViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 3/6/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!

    @IBOutlet weak var loginBtn: UIButton!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func hideKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func onTapLogin(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if(usernameField.text?.isEmpty == true || userPasswordField.text?.isEmpty == true || (usernameField.text?.isEmpty == true && userPasswordField.text?.isEmpty == true)){
            print("incorrect login credentials, try again")
            let alertController = UIAlertController(title: "Empty Field(s)", message: "Please enter your username and password" , preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        }
        else{//TODO might have to use prepareforsegue isntead(or something else), since right now, we are still proceeding to the user page even with incorrect login credentials, because of our segue.
                User.logInWithUsername(inBackground: usernameField.text!, password: userPasswordField.text!) { (user: PFUser?, error:Error?) -> Void in
                if user != nil {
                    appDelegate.login()
                    print("you are logged in!")
                } else {
                    let alertController = UIAlertController(title: "Login Error", message: "\(error?.localizedDescription ?? "Please check your username and password")" , preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
                    alertController.addAction(cancelAction)
                    let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true)
                }
                    
                //self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            
        }
       
        
    }
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

