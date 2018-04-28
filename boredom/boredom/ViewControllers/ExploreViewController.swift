//
//  ExploreViewController.swift
//  boredom
//
//  Created by jsood on 4/7/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import PromiseKit


class ExploreViewController: UIViewController, UICollectionViewDataSource{

    
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    @IBOutlet weak var userListsCollectionView: UICollectionView!
    var movies: [[String:Any]] = []
    var exploreActivities: [Activity]!
    var exploreLists: [List]!
    var activitiesYelp: [Business]!
    var top10List: [List]! = []
    var top10Act: [Activity]! = []
    var bgURL: [String] = ["https://i.imgur.com/2GOE7w9.png", "https://imgur.com/spLeglN.png", "https://imgur.com/SVdeXmg.png", "https://imgur.com/es6rQag.png", "https://imgur.com/VrD2OI3.png", "https://imgur.com/HkECUoG.png", "https://imgur.com/J8lQzBz.png", "https://imgur.com/jpdbJvU.png", "https://imgur.com/3Qm9GDx.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userListsCollectionView.dataSource = self
        activitiesCollectionView.dataSource = self
        
        activitiesCollectionView.backgroundView?.tintColor = UIColor.white
        
        self.view.addSubview(userListsCollectionView)
        self.view.addSubview(activitiesCollectionView)
        
        let layout = userListsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 0
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: 150, height: 150)
        
        let layoutActivities = activitiesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutActivities.minimumInteritemSpacing = 2
        layoutActivities.minimumLineSpacing = 0
        let cellsPerLineActivities: CGFloat = 2
        let interItemSpacingTotalActivities = layoutActivities.minimumInteritemSpacing * (cellsPerLineActivities - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layoutActivities.itemSize = CGSize(width: 120, height: 120)
        
        
        fetchMovies()
        //getTopLists()
        /*Business.searchWithTerm(term: "Thai", completion: { (activitiesYelp: [Business]?, error: Error?) -> Void in
            
            self.activitiesYelp = activitiesYelp
            self.activitiesCollectionView.reloadData()
            if case let self.activitiesYelp = activitiesYelp {
                for self.activitiesYelp in activitiesYelp {
                    print("BUSINESSES")
                }
            }
            
        }
        )*/

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        userListsCollectionView.dataSource = self
        activitiesCollectionView.dataSource = self
        
        let layout = userListsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 0
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: 120, height: 120)
        
        let layoutActivities = activitiesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutActivities.minimumInteritemSpacing = 2
        layoutActivities.minimumLineSpacing = 0
        let cellsPerLineActivities: CGFloat = 2
        let interItemSpacingTotalActivities = layoutActivities.minimumInteritemSpacing * (cellsPerLineActivities - 1)
        //let width = userListsCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layoutActivities.itemSize = CGSize(width: 120, height: 120)
        
        
        fetchMovies()
        getTopLists()
        //getTopActivities()
    }
    
    func getTopLists(){
        //print(".............INSIDE TOP LISTS.........")
        List.fetchLists { (lists: [List]?, error: Error?) in
            if error == nil {
                self.exploreLists = lists
                let lists = lists
                var i = 0
                while i < 10 {
                    print("listLikecount", lists![i].likeCount)
                    let list = lists![i]
                    print("top list", i)
                    print(list)
                    self.top10List.append(list)
                    i = i + 1
                    self.userListsCollectionView.reloadData()
                }
            }
         
        }
        
        
    }
    
    func getTopActivities() {
        Activity.fetchActivity{ (activities: [Activity]?, error: Error?) in
            if error == nil {
                if self.exploreActivities != nil {
                    self.exploreActivities = activities
                    let activities = activities
                    var i = 0
                    while i < (activities?.count)! {
                        print("activityLikeCount", activities![i].activityLikeCount)
                        let act = activities![i]
                        self.top10Act.append(act)
                        self.activitiesCollectionView.reloadData()
                        i = i + 1
                    }
                }
                
            }
            
        }

    }
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == activitiesCollectionView){
        
            return top10Act.count
        }
        else{
            return top10List.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.userListsCollectionView){
            let cell = userListsCollectionView.dequeueReusableCell(withReuseIdentifier: "UserListsCell", for: indexPath) as! UserListsCell
            let list = top10List[indexPath.item]
            cell.listName.text = list.listName
            let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)) )
            let background = bgURL[randomindex]
            let backgroundURL = URL(string: background)
            cell.userListsImageView.af_setImage(withURL: backgroundURL!)
        
        return cell
        }
        
        else{
            let activitiesCell = activitiesCollectionView.dequeueReusableCell(withReuseIdentifier: "ActivitiesCell", for: indexPath) as! ActivitiesCell
//            print(indexPath.item)
//            print("count: ", top10Act.count)
            let act = top10Act[indexPath.item]
//            print("act = top10Act[indexPath.item] ",act)
            activitiesCell.activityName.text = act.actName ?? "Label"
            let randomindex = Int(arc4random_uniform(UInt32(bgURL.count)) )
            let background = bgURL[randomindex]
            let backgroundURL = URL(string: background)
            activitiesCell.activitiesImageView.af_setImage(withURL: backgroundURL!)
            
//            let movie = movies[indexPath.item]
//            if let posterPathString = movie["poster_path"] as? String {
//                let baseURLString = "https://image.tmdb.org/t/p/w500"
//                let posterURL = URL(string: baseURLString + posterPathString)!
//                activitiesCell.activitiesImageView.af_setImage(withURL: posterURL)
           // activitiesCell.activitiesImageView.af_setImage(withURL: URL(string: self.exploreActivity.actImageUrl)!)
//            }
            //activitiesCell.business = activitiesYelp[indexPath.item]
            return activitiesCell
        }
        
    }
    
    
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }
    
    
    func fetchMovies()
    {
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
                //                print(dataDictionary)
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                self.userListsCollectionView.reloadData()
                self.activitiesCollectionView.reloadData()
                //.refreshControl.endRefreshing()
                
            }
        }
        //ALWAYS NEED TO CALL THIS FUNCTION! this will actually start the task
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listDetailSegue" {
            let cell = sender as! UICollectionViewCell
            if let indexPath = userListsCollectionView.indexPath(for: cell) {
                let list = top10List[indexPath.item]
                let detailsViewController = segue.destination as! ListsDetailViewController
                detailsViewController.list = list
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
