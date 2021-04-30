//
//  HomeViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/9/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
// //////////////Shuffle Page//////////////////

import UIKit
import Parse
import MapKit
import GoogleMaps

class HomeViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBOutlet weak var noListsLabel: UILabel!
    
    //var center: CGPoint!
    @IBOutlet weak var actImage: UIImageView!
    @IBOutlet weak var actName: UILabel!
    @IBOutlet weak var actDescriptionLabel: UILabel!
    
    @IBOutlet weak var mapDisplay: MKMapView!
    
    @IBOutlet weak var backView: UIView!
    
    var i = 0
    var prevColor = 0
    let purple = UIColor(displayP3Red: 139/255, green: 22/255, blue: 1.0, alpha: 1.0)
    let yellow = UIColor(displayP3Red: 255/255, green: 193/255, blue: 0.0, alpha: 1.0)
    var annotation: MKPointAnnotation! = nil
    
    var locationManager:CLLocationManager!
    var userLocation:CLLocation! = nil
    
    var userActivities = [UserActivity]()
    var allActivities = [Activity]()
    var userList = [List]()
    var currentUser = PFUser.current()
    var currentRandomAct = Activity()
    var isSaved = 0
    
    var allOptions = [[String : [String]]]()
    var actDescription:String!
    var randomAct = Activity()
    var userLists = [List]()
    var combinedLists = [List]()
    var combinedListsSet = Set<List>()

    
    var itemForPickerView = [[String : [String]]]()
    var pickedListID = [String]()
    @IBOutlet weak var listPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noListsLabel.isHidden = true
        self.listPicker.isHidden = false
        actImage.backgroundColor = UIColor.systemPurple
        actImage.layer.cornerRadius = 10.0
        actImage.clipsToBounds = true
        self.actDescriptionLabel.text = ""
        //listPicker.setValue(UIColor.white, forKeyPath: "textColor")
        listPicker.dataSource = self
        listPicker.delegate = self
        //getLists()
        getAddedListsRe()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if userLocation == nil {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            
        }
        
        if self.mapDisplay.isHidden == true {
            self.mapDisplay.isHidden = false
        }
        
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(openMap))
        mapDisplay.delegate = self
        //center = actImage.center
        mapDisplay.addGestureRecognizer(mapTapGesture)

    }
    
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapDisplay.setRegion(coordinateRegion, animated: true)
    }
    
    
    func displayMap(location: CLLocation, title: String, address: String){
        
        if annotation != nil{
            mapDisplay.removeAnnotation(annotation)
        } else {
            annotation = MKPointAnnotation()
        }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.subtitle = address
        
        mapDisplay.addAnnotation(annotation)
        
        centerMapOnLocation(location: location)
        

        
    }
    
    @objc func openMap(){
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            
            if(randomAct.location != nil){
                let lat = randomAct.locationLatitude
                let lon = randomAct.locationLongitude
                let address = randomAct.location as! String
                let urlGoogle = URL(string: "comgooglemaps://?center=\(lat),\(lon)&zoom=19&x-success=sourceapp://resume=true&x-source=Spark")
              //  let urlApple = URL(string: "comgooglemaps://?center=\(lat),\(lon)&zoom=18&x-source=SourceApp&x-success=sourceapp://?resume=true")
                let urlApple = URL(string:  "http://maps.apple.com/?daddr=\(lat),\(lon)")
                
               
                let redirect = UIAlertController(title: "Open in Map? " , message: nil, preferredStyle: .actionSheet)
                
                let gmap = UIAlertAction(title: "Google Maps", style: .default ){ (action) in
                     UIApplication.shared.open(urlGoogle! , options: [:], completionHandler: nil)
                }
                redirect.addAction(gmap)
                let amap = UIAlertAction(title: "Apple Map", style: .default ){ (action) in
                     UIApplication.shared.open(urlApple! , options: [:], completionHandler: nil)
                }
                redirect.addAction(amap)
                let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel){ (action) in }
                redirect.addAction(cancelBtn)
                self.present(redirect, animated: true)
            }
           
        } else {
            print("Can't use comgooglemaps://");
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isSaved = UserDefaults.standard.integer(forKey: "savedBoolean")
        listPicker.selectRow(0, inComponent: 0, animated: false)
        self.actDescriptionLabel.text = ""
        self.actName.text = "Let's see what we're doing today."
       // if(isSaved == 2) {
            self.userActivities.removeAll()
            print("whatttttttttt", isSaved)
            getLists()
            getActFromList(ids: pickedListID)
            
       // }
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
            let idsArr = list["ids"]!
            getActFromList(ids: idsArr)
            print("self.pickedList", self.pickedListID)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let optionVC = navVC.topViewController as! OptionsViewController
        optionVC.pickedListId = self.pickedListID
    }
    
    func getAddedListsRe(){
        let currUser = PFUser.current() as! User
        let listIds = currUser.addedLists
        combinedListsSet = Set<List>()
       // for listId in listIds {
            let query = PFQuery(className: "List")
            query.whereKey("objectId", containedIn: listIds)
       
            
        query.findObjectsInBackground { [self] (lists: [PFObject]? , error: Error?) in
            print("ADDED LISTS FOUND......", lists)
                let lists = lists as! [List]
                if lists.count == 0 {
                   // self.noListsLabel.isHidden = false
                    print("user has no lists yet")
                }
                else {
                    if error == nil {
                        if lists != nil{
                            let lists = lists
                            self.noListsLabel.isHidden = true
                            print(lists)
                            //self.addLists = lists
                            for item in lists {
                                print("ITEM to compare...", item)
                                combinedListsSet.insert(item)
                                /*if(self.combinedLists.contains(item) == false){
                                    self.combinedLists.append(contentsOf: self.lists)
                                    print("COMBINED LISTS IS...", self.combinedLists)
                                }*/
                            }
                            
                            self.combinedLists = Array(combinedListsSet)
                            
                            self.userLists = self.combinedLists
                            self.noListsLabel.isHidden = true
                            self.listPicker.isHidden = false
                            print(lists)
                            allOptions = [[String : [String]]]()
                            
                            var listIDsArr = [String]()
                            
                            for list in self.combinedLists{
                                listIDsArr.append(list.objectId!)
                            }
                            
                            let allLists : [String : [String]]
                            allLists = ["name" : ["All Lists"], "ids": listIDsArr]
                            
                            allOptions.append(allLists)

                            for list in self.combinedLists{
                                let option : [String : [String]]
                                let id = list.objectId
                                option = ["name" : [list.listName ], "ids": [id]] as! [String : [String]]
                                allOptions.append(option)
                            }
                            
                            self.itemForPickerView = allOptions
                            self.pickedListID = listIDsArr
                            self.getActFromList(ids: listIDsArr)
                            self.listPicker.reloadAllComponents()
                            
                        } else {
                            //self.editBtn.title = "Edit"
                            print(error?.localizedDescription)
                        }
                    
                    }
                }
                
                
            }
       // }
    }
    
    func getLists() {
        getAddedListsRe()
        let curUser = PFUser.current()
        let userId = curUser?.objectId
        List.fetchLists(userId: userId!) { (lists: [List]?, error: Error?) in
            if lists?.count == 0 {
                print("user has no lists yet")
                self.itemForPickerView.append(["name" : ["You have no list"], "ids": ["id"]])
                self.noListsLabel.isHidden = false
                self.listPicker.isHidden = true
            }
            else {
                if error == nil {
                    let lists = lists!
                    for item in lists {
                        print("ITEM to compare...", item)
                        self.combinedListsSet.insert(item)
                        /*if(self.combinedLists.contains(item) == false){
                            self.combinedLists.append(contentsOf: self.lists)
                            print("COMBINED LISTS IS...", self.combinedLists)
                        }*/
                    }
                    
                    self.combinedLists = Array(self.combinedListsSet)
                    
                    self.userLists = self.combinedLists
                    self.noListsLabel.isHidden = true
                    self.listPicker.isHidden = false
                    print(lists)
                    self.allOptions = [[String : [String]]]()
                    
                    var listIDsArr = [String]()
                    
                    for list in self.combinedLists{
                        listIDsArr.append(list.objectId!)
                    }
                    
                    let allLists : [String : [String]]
                    allLists = ["name" : ["All Lists"], "ids": listIDsArr]
                    
                    self.allOptions.append(allLists)

                    for list in self.combinedLists{
                        let option : [String : [String]]
                        let id = list.objectId
                        option = ["name" : [list.listName ], "ids": [id]] as! [String : [String]]
                        self.allOptions.append(option)
                    }
                    
                    self.itemForPickerView = self.allOptions
                    self.pickedListID = listIDsArr
                    self.getActFromList(ids: listIDsArr)
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
        
        self.userLocation = userLocation
        if i == 0 {
            if (userLocation != nil) {
                displayMap(location: userLocation, title: "Current Location", address: "")
                i += 1
            }
        }
        
        
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
    
    func getActFromList(ids: [String]){
        print("getActFromList")
        print("pickedListID", pickedListID)
        for id in ids {
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

                                if (acts![0].cost <= firstOption ){
                                    if (self.userLocation != nil) && (acts![0].locationLatitude != nil){
                                        print("(acts![0].locationLongitude)", (acts![0].locationLongitude))
                                        // THIS crashing
                                        
                                        if(acts![0].locationLongitude == -1 || acts![0].locationLongitude == -1){
                                            self.userActivities.append(act)
                                        }
                                        else{
                                            let lat = CLLocationDegrees(acts![0].locationLatitude)
                                            let lon = CLLocationDegrees(acts![0].locationLongitude)
                                            
                                            let actLocation =  CLLocation(latitude: lat , longitude: lon)
                                            
                                            print("actLocation", actLocation)
                                            print("user location", self.userLocation)
                                            print("user location", self.userLocation)
                                            
                                            //let testLocation = CLLocation(latitude: 32.873636, longitude: -117.237814)
                                            let distanceInMeters = self.userLocation.distance(from: actLocation)
                                            //let distanceInMeters = testLocation.distance(from: actLocation)
                                            if(Double(secondOption) >= distanceInMeters){
                                                self.userActivities.append(act)
                                                print("yes it works")
                                            }
                                            print("secondOption", Double(secondOption))
                                            print("distanceWorking:", distanceInMeters)
                                        }
                                        
                                    } else {

                                        self.userActivities.append(act)
                
                                    } 
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
            var randoms = [Int]()
            let randomindex = Int(arc4random_uniform(UInt32(userActivities.count)))
            
            let userRandomAct = userActivities[randomindex]
            let actId = userRandomAct.activity.objectId
            print("actID", actId!)
            Activity.fetchActivity(actId: actId!, completion: { (activities: [Activity]?, error: Error?) in
                if (error == nil) && ((activities?.count)! > 0) {
                    let randomAct = activities![0]
                    print("randomAct", randomAct)
                    self.randomAct = randomAct
                    //actImage.ani
                    UIView.animate(withDuration: 0.5, animations: {
                        if (self.prevColor == 0) {
                            self.prevColor = 1
                            self.actImage.backgroundColor = self.yellow
                        }
                        else {
                            self.prevColor = 0
                            self.actImage.backgroundColor = self.purple
                            
                        }
                    })
                    self.actName.text = randomAct.actName
                    if randomAct.actDescription == ""  {
                        self.actDescriptionLabel.text = " "
                    } else {
                        self.actDescriptionLabel.text = randomAct.actDescription ?? "no Description available"
                    }
                    
                    if(randomAct.locationLatitude == -1 || randomAct.locationLongitude == -1){
                        
                        self.mapDisplay.isHidden = true
                                        
                    }
                    else{
                        self.mapDisplay.isHidden = false
                        let location = CLLocation(latitude: CLLocationDegrees(randomAct.locationLatitude), longitude: CLLocationDegrees(randomAct.locationLongitude))
                        
                        self.displayMap(location: location , title: randomAct.actName, address: randomAct.location)
                    }
                    
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
