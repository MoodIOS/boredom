//
//  HomeViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
// //////////////Shuffle Page//////////////////

import UIKit
import Parse

class HomeViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    @IBOutlet weak var actImage: UIImageView!
    @IBOutlet weak var actName: UILabel!
    @IBOutlet weak var actDescriptionLabel: UILabel!
    
    
    var locationManager:CLLocationManager!
    let userLocation:CLLocation! = nil
    
    var userActivities = [UserActivity]()
    var allActivities = [Activity]()
    var userList = [List]()
    var currentUser = PFUser.current()
    var currentRandomAct = Activity()
    var isSaved = 0
    
    var actDescription:String!
    
    var userLists = [List]()
    
    var itemForPickerView = [[String : [String]]]()
    var pickedListID = [String]()
    @IBOutlet weak var listPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //listPicker.setValue(UIColor.white, forKeyPath: "textColor")
        listPicker.dataSource = self
        listPicker.delegate = self
        getLists()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        isSaved = UserDefaults.standard.integer(forKey: "savedBoolean")
        if(isSaved == 2) {
            self.userActivities.removeAll()
            print("whatttttttttt", isSaved)
            getActFromList()
            getLists()
//            randomActivity()
        }
    }
    
    // make font white
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let list = itemForPickerView[row]
        let titleData = list["name"]![0]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemForPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let list = itemForPickerView[row]
        let name = list["name"]
        let listName = name![0]
        print("listName", listName)
        return listName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if userList != nil {
            let list = itemForPickerView[row]
            self.pickedListID = list["ids"]!
            getActFromList()
            print("self.pickedList", self.pickedListID)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let optionVC = navVC.topViewController as! OptionsViewController
        optionVC.pickedListId = self.pickedListID
    }
    
    func getLists() {
        let curUser = PFUser.current()
        let userId = curUser?.objectId
        List.fetchLists(userId: userId!) { (lists: [List]?, error: Error?) in
            if lists?.count == 0 {
                print("user has no lists yet")
                self.itemForPickerView.append(["name" : ["You have no list"], "ids": ["id"]])
            }
            else {
                if error == nil {
                    let lists = lists!
                    //                    self.noListsLabel.isHidden = true
                    self.userLists = lists
                    print(lists)
                    var allOptions = [[String : [String]]]()
                    
                    var listIDsArr = [String]()
                    
                    for list in lists{
                        listIDsArr.append(list.objectId!)
                    }
                    
                    let allLists : [String : [String]]
                    allLists = ["name" : ["All Lists"], "ids": listIDsArr]
                    
                    allOptions.append(allLists)

                    for list in lists{
                        let option : [String : [String]]
                        let id = list.objectId
                        option = ["name" : [list.listName ], "ids": [id]] as! [String : [String]]
                        allOptions.append(option)
                    }
                    
                    self.itemForPickerView = allOptions
                    self.pickedListID = listIDsArr
                    self.getActFromList()
                    self.listPicker.reloadAllComponents()
                } else {
                    print("\(error?.localizedDescription)")
                }
            }
        }
    }
    
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
            } else {
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    print(placemark.locality!)
                    print(placemark.administrativeArea!)
                    print(placemark.country!)
                    
                }
            }
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func changeGenOptions(_ sender: Any) {
        
    }
    
    @IBAction func randomizeAct(_ sender: UIButton) {
        randomActivity()
    }
    
    func getActFromList(){
        print("getActFromList")
        print("pickedListID", pickedListID)
        for id in pickedListID {
            UserActivity.fetchActivity(listId: id, completion: { (activities: [UserActivity]?, error: Error?) in
                if error == nil {
                    let actsInList = activities
                    for act in actsInList! {
                        let actId = act.activity.objectId
                        self.userActivities = []
                        Activity.fetchActivity(actId: actId!, completion: { (acts: [Activity]?, error: Error?) in
                            if (acts! != []){
                                let firstOption = UserDefaults.standard.integer(forKey: "whichOne")
                                let secondOption = UserDefaults.standard.integer(forKey: "whichTwo")

                                if (acts![0].cost == firstOption ){
                                    self.userActivities.append(act)
                                } else {
                                self.userActivities.append(act)
                                //                                    self.locationManager.requestAlwaysAuthorization()
                                }
                                
                                
                            } else {
                                print("error", "\(String(describing: error?.localizedDescription))")
                            }
                        })
                    }
                }
            })
        }
    }
        
    
    func filterByOption(){
        
    }
    
    func randomActivity(){
        if userActivities != [] {
            let randomindex = Int(arc4random_uniform(UInt32(userActivities.count)))
            let userRandomAct = userActivities[randomindex]
            let actId = userRandomAct.activity.objectId
            print("actID", actId!)
            Activity.fetchActivity(actId: actId!, completion: { (activities: [Activity]?, error: Error?) in
                if (error == nil) && ((activities?.count)! > 0) {
                    let randomAct = activities![0]
                    print("randomAct", randomAct)
                    self.actName.text = randomAct.actName
                    self.actDescriptionLabel.text = randomAct.actDescription ?? "no Description available"
                }else {
                    print("error", "\(String(describing: error?.localizedDescription))")
                    let alertController = UIAlertController(title: "Error Generating Your Activity ", message: "\(error?.localizedDescription ?? "Please narrow down your options")" , preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
                    alertController.addAction(cancelAction)
                    let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true)
                }
            })
        } else {
            print("userActivities in random", userActivities)
            let alertController = UIAlertController(title: "No Matched Activity ", message: "Please narrow down your options" , preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        }
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
