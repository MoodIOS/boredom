//
//  OptionsViewController.swift
//  boredom
//
//  Created by Justin Lee on 4/20/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
 
    
    @IBOutlet weak var costControl: UISegmentedControl!
    
    @IBOutlet weak var distanceControl: UISegmentedControl!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let saved = UserDefaults.standard
        let which = saved.integer(forKey: "whichOne")
        let whichTwo = saved.integer(forKey: "whichTwo")

        costControl.selectedSegmentIndex = which
        distanceControl.selectedSegmentIndex = whichTwo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        //Cost Segmented Control
        let choseMon = [1, 2, 3, 4]
        let result = choseMon[costControl.selectedSegmentIndex]
        let savedBool = UserDefaults.standard
        if(result == 1){
            savedBool.set(0, forKey: "whichOne")
            print("yah")
        }
        else if(result == 2){
            savedBool.set(1, forKey: "whichOne")
            print("yah1")
        }
        else if(result == 3){
            savedBool.set(2, forKey: "whichOne")
            print("yah1")
        }
        else{
            savedBool.set(3, forKey: "whichOne")
            print("yah2")
        }
        //Distance Segmented Control
        let choseDist = [1, 2, 3, 4]
        let resultTwo = choseDist[distanceControl.selectedSegmentIndex]
        if(resultTwo == 1){
            savedBool.set(0, forKey: "whichTwo")
            print("yah")
        }
        else if(resultTwo == 2){
            savedBool.set(1, forKey: "whichTwo")
            print("yah1")
        }
        else if(resultTwo == 3){
            savedBool.set(2, forKey: "whichTwo")
            print("yah1")
        }
        else{
            savedBool.set(3, forKey: "whichTwo")
            print("yah2")
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
   
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
