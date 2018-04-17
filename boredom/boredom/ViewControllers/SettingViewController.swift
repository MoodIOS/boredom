//
//  SettingViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse

class SettingViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var userPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = PFUser.current()?.username
        userPassword.text = PFUser.current()?.password
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
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
