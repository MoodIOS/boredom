//
//  AddNewActivityVCViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/12/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
import SearchTextField
import GooglePlaces
import GoogleMaps
//import GooglePlacePicker

class AddNewActivityVCViewController: UIViewController , CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var actName: UITextField!
    @IBOutlet weak var actDescription: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var costControl: UISegmentedControl!
    
    @IBOutlet weak var name: SearchTextField!
    
    var pickedImage:UIImage!
    
    var list = List()
//    var allActivities: [Activity]?
    var activityNames: [SearchTextFieldItem]!
    var activityId: [String]!
    
    var actNamesInList =  [String]()
    var allActNames = [String]()
    var actsInList =  [Activity]()
    var allActs = [Activity]()
    var actInDatabase = Activity()
    var tags = [String: Bool]()
    
    var locationLat:Double! = -1
    var locationLong:Double! = -1
    
    @IBOutlet weak var restaurantTag: UIButton!
    @IBOutlet weak var brunchTag: UIButton!
    @IBOutlet weak var movieTag: UIButton!
    @IBOutlet weak var outdoorTag: UIButton!
    @IBOutlet weak var bookTag: UIButton!
    @IBOutlet weak var coffeeTag: UIButton!
    @IBOutlet weak var nightlifeTag: UIButton!
    @IBOutlet weak var happyhoursTag: UIButton!
    
    
    var tagsBtn = [UIButton]()
    var locationManager:CLLocationManager!
    var userLocation:CLLocation! = nil
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        
        tagsBtn = [restaurantTag, brunchTag, movieTag, outdoorTag, bookTag, coffeeTag, nightlifeTag, happyhoursTag]
        
        self.activityNames = []
        self.activityId = []
        
       // print("self.list", self.list)
      //  loadActivity()
        
        self.tags["Restaurant"] = false
        self.tags["Brunch"] = false
        self.tags["Movie"] = false
        self.tags["Outdoor"] = false
        self.tags["Book"] = false
        self.tags["Coffee"] = false
        self.tags["Nightlife"] = false
        self.tags["Happy hours"] = false
        
        
        
     /*   locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }*/
        
        placesClient = GMSPlacesClient.shared()
      //  location.addTarget(self, action: #selector(locationDidChange), for: .touchDown)
        
//        location.addTarget(self, action: #selector(locationDidChange), for: .)
        var i = 0
        while i < tagsBtn.count {
            let tagBtn = tagsBtn[i]
            tagBtn.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
            tagBtn.layer.cornerRadius = 7
            tagBtn.layer.borderWidth = 1
            tagBtn.layer.borderColor = UIColor(displayP3Red: 255/255, green: 193/255, blue: 0.0, alpha: 1.0).cgColor
            tagBtn.backgroundColor = UIColor.darkGray
            i += 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("self.list", self.list)
        loadActivity()
    }
    
    
    @IBAction func locationTextFieldTouchDown(_ sender: Any) {
        
        location.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cameraBtnTapped(_ sender: Any) {
        let vc = UIImagePickerController()
                vc.delegate = self
                vc.allowsEditing = true
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("Camera is available 📸")
                    vc.sourceType = .camera
                } else {
                    print("Camera 🚫 available so we will use photo library instead")
                    vc.sourceType = .photoLibrary
                }
                
                self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [String : Any]) {
            // Get the image captured by the UIImagePickerController
            
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            self.pickedImage = editedImage
            
            
            // Do something with the images (based on your use case)
            
            // Dismiss UIImagePickerController to go back to your original view controller
            
            dismiss(animated: true, completion: {
                // save image with the act
                // Do something here
               
            })
    }
    
    /**
         Method to convert UIImage to PFFile
         
         - parameter image: Image that the user wants to upload to parse
         
         - returns: PFFile for the the data in the image
         */
        func getPFFileFromImage(image: UIImage?) -> PFFileObject? {
            // check if image is not nil
            if let image = image {
                // get image data and check if that is not nil
                if let imageData = UIImagePNGRepresentation(image) {
                    return PFFileObject(name: "image.png", data: imageData)
                }
            }
            return nil
        }
            

    
    
//    https://developers.google.com/places/ios-sdk/start
    
    
   /* @objc func locationDidChange(location: UITextField){
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
//                self.location.text = place.name
                self.location.text = place.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: ", " )
            } else {
//                self.nameLabel.text = "No place selected"
//                self.location.text = "No Address Found"
            }
        })
    }*/
    
    
    
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        self.userLocation = userLocation
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
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func saveNewActivity(_ sender: UIBarButtonItem) {
        
        if(self.actName.text?.isEmpty == true){
            DispatchQueue.main.async {
                
                let alertController = UIAlertController(title: "Can't Add Activity", message: "You must add a name for the activity" , preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
                alertController.addAction(cancelAction)
                let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                }
            
        }
        
        else { //just require name, if it exists, then everything else is run, else, it isn't!
        
        // TO-DO: check if the data already has this item, if user already have this item in this list.
        let backgroundImg:PFFileObject!
        let image = UIImage(named: "lilacBackground.png")
        
        if(pickedImage == nil){
            backgroundImg = getPFFileFromImage(image: image)
        }
        else{
            backgroundImg = getPFFileFromImage(image: pickedImage)
        }
        
        
        
        checkForDuplicateInList { (duplicateInList: Int, error: Error?) in
            print("duplicate? ", duplicateInList)
            if duplicateInList != 0 {
                self.actName.text = ""
                self.actDescription.text = ""
                self.location.text = ""
                self.costControl.selectedSegmentIndex = 0
                let alertController = UIAlertController(title: "Can't Add Activity", message: "You already have this item in your list. Please add a different item." , preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action) in}
                alertController.addAction(cancelAction)
                let OKAction = UIAlertAction(title: "OK", style: .default){ (action) in }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            } else {
                self.checkForDuplicateInDatabase(done: { (duplicateInDatabase: Int, error: Error?) in
                    
                    if (duplicateInDatabase > 0 ) {
                        UserActivity.addNewActivity(activity: self.actInDatabase, list: self.list, completion: { (userAct: UserActivity? , error: Error?) in
                            if error == nil {
                                print("User activity created")
                                List.addActToList(currentList: self.list, userAct: userAct!, tags: self.actInDatabase.tags , completion: { (list: List?, error: Error?) in
                                    if error == nil {
                                        print("list", list!)
                                    }
                                })
                                self.dismiss(animated: true, completion: nil)
                                self.loadActivity()
                            } else if let error = error {
                                print("Problem saving User activity: \(error.localizedDescription)")
                            }
                        })
                    } else {
                        print("duplicate? ", duplicateInList)
                        let choseMon = [1,2,3,4]
                        let result = choseMon[self.costControl.selectedSegmentIndex]
                        var savedValue = 5
                        if(result == 1){
                            savedValue = 1
                        }
                        else if(result == 2){
                            savedValue = 2
                        }
                        else if(result == 3){
                            savedValue = 3
                        }
                        else if(result == 4){
                            savedValue = 4
                        }
                        print("self.tags", self.tags)
                        if self.location.text?.isEmpty ?? true {
                            Activity.addNewActivity(actName: self.actName.text, actDescription: self.actDescription.text, cost: savedValue, location: "Nearby", lon: -1, lat: -1, tags: self.tags, backgroundImg: backgroundImg){ (activity, error) in
                                if let activity = activity  {
                                    print("Activity ID:", activity)
                                    UserActivity.addNewActivity(activity: activity, list: self.list, completion: { (userAct: UserActivity? , error: Error?) in
                                        if error == nil {
                                            print("User activity created")
                                            List.addActToList(currentList: self.list, userAct: userAct!, tags: self.tags, completion: { (list: List?, error: Error?) in
                                                if error == nil {
                                                    print("list", list!)
                                                }
                                            })
                                            //activity.saveInBackground()//////////////
                                            self.dismiss(animated: true, completion: nil)
                                            self.loadActivity()
                                        } else if let error = error {
                                            print("Problem saving User activity: \(error.localizedDescription)")
                                        }
                                    })
                                }
                                else if let error = error {
                                    print("Problem saving activity: \(error.localizedDescription)")
                                }
                            }
                        } else {
                            Activity.addNewActivity(actName: self.actName.text, actDescription: self.actDescription.text, cost: savedValue, location: self.location.text!, lon: self.locationLong, lat: self.locationLat, tags: self.tags) { (activity, error) in
                                if let activity = activity  {
                                    print("Activity ID:", activity)
                                    UserActivity.addNewActivity(activity: activity, list: self.list, completion: { (userAct: UserActivity? , error: Error?) in
                                        if error == nil {
                                            print("User activity created")
                                            List.addActToList(currentList: self.list, userAct: userAct!, tags: self.tags, completion: { (list: List?, error: Error?) in
                                                if error == nil {
                                                    print("list", list!)
                                                }
                                            })
                                            //activity.saveInBackground()//////////////
                                            self.dismiss(animated: true, completion: nil)
                                            self.loadActivity()
                                        } else if let error = error {
                                            print("Problem saving User activity: \(error.localizedDescription)")
                                        }
                                    })
                                }
                                else if let error = error {
                                    print("Problem saving activity: \(error.localizedDescription)")
                                }
                            }
                            /*Activity.addNewActivity(actName: self.actName.text, actDescription: self.actDescription.text, cost: savedValue, location: self.location.text, tags: self.tags){ (activity, error) in
                                if let activity = activity  {
                                    print("Activity ID:", activity)
                                    UserActivity.addNewActivity(activity: activity, list: self.list, completion: { (userAct: UserActivity? , error: Error?) in
                                        if error == nil {
                                            print("User activity created")
                                            List.addActToList(currentList: self.list, userAct: userAct!, tags: self.tags, completion: { (list: List?, error: Error?) in
                                                if error == nil {
                                                    print("list", list!)
                                                }
                                            })
                                            //activity.saveInBackground()//////////////
                                            self.dismiss(animated: true, completion: nil)
                                            self.loadActivity()
                                        } else if let error = error {
                                            print("Problem saving User activity: \(error.localizedDescription)")
                                        }
                                    })
                                }
                                else if let error = error {
                                    print("Problem saving activity: \(error.localizedDescription)")
                                }
                            }
                            */
                        }
                        
                    }
                })
            }
        }
        }
    }
    
    
    @IBAction func clickedOnTags(_ sender: UIButton) {
        let button = sender
        print("button sender ", button.backgroundColor!)
        handleTags(tagName: button.currentTitle!) { (tags: [String: Bool]?, error: Error?) in
            for (tag, value) in tags!{
                if (value == true) && (button.currentTitle == tag)  {
                    button.backgroundColor = UIColor(displayP3Red: 255/255, green: 193/255, blue: 0.0, alpha: 1.0)
                } else if (value == false) && (button.currentTitle == tag) {
                    button.backgroundColor = UIColor.darkGray
                }
            }
        }
    }
    
    func handleTags (tagName: String, completion: @escaping ([String:Bool]?, Error? ) -> Void){
        print("handleTag: ", tagName)
        if tags[tagName] == false || tags[tagName] == nil {
            tags[tagName] = true
        } else {
            tags[tagName] = false
        }
        print("tags: ", tags)
        return completion(tags, nil)
        
    }
    

    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil )
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForDuplicateInList(done: @escaping (Int, Error?) -> Void){
        let newName = actName.text
        var duplicateInList = 0
        for act in actNamesInList {
            if act == newName {
                duplicateInList = duplicateInList + 1
            }
        }
        return done(duplicateInList,  nil)
    }
    
    func checkForDuplicateInDatabase(done: @escaping (Int, Error?) -> Void){
        let newName = actName.text
        var duplicateInDatabase = 0
        for act in allActs {
            let name = act.actName
            if name == newName {
                duplicateInDatabase = duplicateInDatabase + 1
                self.actInDatabase = act
            }
        }
        return done(duplicateInDatabase,  nil)
    }
    
    func loadActivity(){
        Activity.fetchActivity(completion: { (activities: [Activity]?, error: Error?) in
            if error == nil {
                self.allActs = activities!
                
                self.getActivityNames()
                print("self.activityNames", self.activityNames.count)
                self.name.filterItems(self.activityNames)
                self.handleUserPicker()
                print("self.activityNames", self.activityNames)
                
            } else {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    func handleUserPicker() {
        self.name.itemSelectionHandler = {item, index in
            let result = item[index]
            self.name.text = "\(result.title)"
            for (_, act) in (self.allActs).enumerated() {
                if act.actName == result.title {
                    self.actDescription.text = act.actDescription
//                    self.cost.text = act.cost
                    self.location.text = act.location
                }
            }
        }
        
        
    }
    
    
    func getActivityNames() {
        if activityNames.count == 0 {
            print("allActNames", allActNames)
            for name in allActNames {
                if activityNames.count < allActs.count{
                    let item = SearchTextFieldItem(title: name)
                    activityNames?.append(item)
                    print (name)
                }
                
            }
            
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

extension AddNewActivityVCViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        location.text = place.name
        locationLat = place.coordinate.latitude
        locationLong = place.coordinate.longitude
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
}

}


