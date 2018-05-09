//
//  ExploreTableViewCell.swift
//  boredom
//
//  Created by jsood on 5/4/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var insideTableCollectionView: UICollectionView!
    var collectionViewVariable: CollectionViewClass!
    var listArray:[List]!
    var actArray:[Activity]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.insideTableCollectionView.backgroundColor = UIColor.clear;
        self.insideTableCollectionView = self.collectionViewVariable
        //self.collectionViewVariable = self.insideTableCollectionView as! CollectionViewClass?
//        self.collectionViewVariable.listArray = self.listArray
//        self.collectionViewVariable.actArray = self.actArray
        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

/*extension ExploreTableViewCell{
    func setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate:D, forRow row:Int){
        
        insideTableCollectionView.delegate = dataSourceDelegate
        insideTableCollectionView.dataSource = dataSourceDelegate
        
            insideTableCollectionView.reloadData()
        
        }
    }
*/

