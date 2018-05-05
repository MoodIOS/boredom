//
//  ExploreTableViewCell.swift
//  boredom
//
//  Created by jsood on 5/4/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var tableCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ExploreTableViewCell{
    func setCollectionViewDataSourceDelegate <D: UICollectionViewDelegate & UICollectionViewDataSource>(_ dataSourceDelegate:D, forRow row:Int){
            tableCollectionView.delegate = dataSourceDelegate
            tableCollectionView.dataSource = dataSourceDelegate
        
            tableCollectionView.reloadData()
        
        }
    }


