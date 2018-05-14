//
//  CollectionViewClass.swift
//  boredom
//
//  Created by jsood on 5/7/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//
//////////HAVE DELETED THE TABLEVIEW FROM EXPLORE PAGE, SO THIS IS NOT NEEDED ANYMORE

import UIKit
import Parse
import AlamofireImage
import PromiseKit

class CollectionViewClass: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    var bgURL: [String] = ["https://i.imgur.com/2GOE7w9.png", "https://imgur.com/spLeglN.png", "https://imgur.com/SVdeXmg.png", "https://imgur.com/es6rQag.png", "https://imgur.com/VrD2OI3.png", "https://imgur.com/HkECUoG.png", "https://imgur.com/J8lQzBz.png", "https://imgur.com/jpdbJvU.png", "https://imgur.com/3Qm9GDx.png"]
    var table: UITableView!
    var index1 = [Int]()
    var index2 = [Int]()
    var bgUrlAct = [URL]()
    var bgUrlList = [URL]()
    
    var listArray:[List]! = []
    
    var actArray:[Activity]! = []
    
    var indexList:Bool!
    var indexAct:Bool!
    
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        //getTopListsYo()
        //getTopActivitiesYo()
      
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionViewScrollPosition) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "InsideTableCollectionViewCell", for: indexPath) as! InsideTableCollectionViewCell
        
        
//        if(self.indexList == true && self.indexAct == false){
            while bgUrlList.count < 11 {
                let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)))
                let background = bgURL[randomindex]
                let backgroundURL = URL(string: background)
                bgUrlList.append(backgroundURL!)
            }
            let backgroundURL = bgUrlList[indexPath.item]
            cell.collectionImageView.af_setImage(withURL: backgroundURL)
//            let curList = listArray
            print("//////////////////////////////",self.listArray)
            //cell.listOrActNameLabel.text = listArray[indexPath.item].listName
//        }
//        else if(self.indexList == false && self.indexAct == true){
//            print("............................^^^^^^^^^^^^^^^.........index is 1")
//        }
        
        return cell
        
    }
    

    
    

}
