//
//  OptionsViewController.swift
//  boredom
//
//  Created by Justin Lee on 4/20/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//
//MARK: - make cost required when adding a new activity
import UIKit

class OptionsViewController: UIViewController {
    
 
    
    @IBOutlet weak var costControl: UISegmentedControl!
    
    @IBOutlet weak var distanceControl: UISegmentedControl!
    
    var pickedListId = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let saved = UserDefaults.standard
        let which = saved.integer(forKey: "whichOne")
        let whichTwo = saved.integer(forKey: "whichTwo")
        let savedBoolean = saved.integer(forKey: "savedBoolean")
        

        costControl.selectedSegmentIndex = which
        if(whichTwo == 8046){
            distanceControl.selectedSegmentIndex = 0
        }
        else if(whichTwo == 32186){
            distanceControl.selectedSegmentIndex = 1
        }
        else if(whichTwo == 64373){
            distanceControl.selectedSegmentIndex = 2
        }

        else{
            distanceControl.selectedSegmentIndex = 3
        }
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
        if (resultTwo == 1){
            savedBool.set(8046, forKey: "whichTwo") //5
            print("yah")
        }
        else if(resultTwo == 2){
            savedBool.set(32186, forKey: "whichTwo") //20
            print("yah1")
        }
        else if(resultTwo == 3){
            savedBool.set(64373, forKey: "whichTwo") //40
            print("yah1")
        }
        else{
            savedBool.set(321869, forKey: "whichTwo") //200
            print("yah2")
        }
        
//        let navView = navigationController as? UINavigationController
//        let homeView = navView?.topViewController as? HomeViewController
        savedBool.set(2, forKey: "savedBoolean")
        
        
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
