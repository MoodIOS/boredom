//
//  AddSomeActToYourListViewController.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 5/4/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse



class AddSomeActToYourListViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var listPicker: UIPickerView!
    var userLists = [List]()
    // getting List and UserActivity from parent VC
    var selectedList = List()
    var selectedAct = UserActivity()
    var globalAct = Activity()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listPicker.dataSource = self
        listPicker.delegate = self
        getLists()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func onSaveAct(_ sender: UIBarButtonItem) {
        
        List.addActToList(currentList: self.selectedList, userAct: self.selectedAct, tags: globalAct.tags ) { (list: List?, error: Error?) in
            print("successfully added activity to list")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let thisList = userLists[row]
        self.selectedList = thisList
        print("self.selectedList",self.selectedList)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userLists.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let list = userLists[row]
        let listName = list.listName
        return listName
    }
    

    func getLists() {
        let curUser = PFUser.current()
        let userId = curUser?.objectId
        List.fetchLists(userId: userId!) { (lists: [List]?, error: Error?) in
            if lists?.count == 0 {
//                self.noListsLabel.isHidden = false
                print("user has no lists yet")
            }
            else {
                if error == nil {
                    let lists = lists!
//                    self.noListsLabel.isHidden = true
                    print(lists)
                    self.userLists = lists
                    self.listPicker.reloadAllComponents()
                    print("self.lists", self.userLists )
                    print("lists[0]", self.userLists[0].listName)
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    
    @IBAction func onCancelBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
