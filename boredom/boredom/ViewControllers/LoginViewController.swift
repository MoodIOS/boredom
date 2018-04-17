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
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onTapLogin(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if(usernameField.text?.isEmpty == true || userPasswordField.text?.isEmpty == true || (usernameField.text?.isEmpty == true && userPasswordField.text?.isEmpty == true)){
            print("incorrect login credentials, try again")
        }
        else{//TODO might have to use prepareforsegue isntead(or something else), since right now, we are still proceeding to the user page even with incorrect login credentials, because of our segue.
                PFUser.logInWithUsername(inBackground: usernameField.text!, password: userPasswordField.text!) { (user: PFUser?, error:Error?) -> Void in
                if user != nil {
                    appDelegate.login()
                    print("you are logged in!")
                }
                //self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            
        }
       
        
    }
    
    
    @IBAction func onTapSignIn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = userPasswordField.text
        newUser.signUpInBackground{ (success:Bool, error:Error?) -> Void in
            if success{
                print("yay created a user!")
                appDelegate.login()
//                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            } else{
                print(error?.localizedDescription)
                if error?._code == 202{
                    print("Username is taken")
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

