//
//  ActivitiesDetailViewController.swift
//  boredom
//
//  Created by jsood on 4/27/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

class ActivitiesDetailViewController: UIViewController {
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var activityLocation: UILabel!
    @IBOutlet weak var activityCost: UILabel!
    @IBOutlet weak var activityDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addActivity(_ sender: Any) {
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
