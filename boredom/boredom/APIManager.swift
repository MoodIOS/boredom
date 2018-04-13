//
//  APIManager.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/11/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation
class APIManager {
    
    
    /*func fetchMovies(){
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        
        //getting data
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //task to get the data
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
                //based on error, display corresponding message
                
                //create a alert view controller
                let alertController = UIAlertController(title: "Cannot load movies", message: "Please check your wifi connection", preferredStyle: .alert)
                
                //create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) {(action) in
                    //handle response here
                }
                
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                print(dataDictionary)
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                self.userListsCollectionView.reloadData()
                self.activitiesCollectionView.reloadData()
                //.refreshControl.endRefreshing()
                
            }
        }
        //ALWAYS NEED TO CALL THIS FUNCTION! this will actually start the task
        task.resume()
    }*/
}
