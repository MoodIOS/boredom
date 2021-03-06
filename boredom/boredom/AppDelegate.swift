//
//  AppDelegate.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 3/6/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        Parse.enableLocalDatastore()
        
        // Override point for customization after application launch.
       /* Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
//                configuration.applicationId = "boredomID"
//                configuration.clientKey = "boredomMasterKey"  // set to nil assuming you have not set clientKey
//                configuration.server = "https://boredom-ios.herokuapp.com/parse"
                configuration.applicationId = "Spark"
                configuration.clientKey = "fiv94sjvo3g_gh2/gidie0335{fi"
                configuration.server = "https://spark-adventureawaits.herokuapp.com/parse"
            })
        )*/
        
        // --- Copy this only
        
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "ISTclrEvFKx5BqFRtGkn3PXXtKmXeGcvfsxxNDxZ" // <- UPDATE
            $0.clientKey = "uHzxlwjEPucuRUGl0LXkWddpvR1sPAZROWJP7LOC" // <- UPDATE
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        
        // --- end copy
        
        // persisting user
        if PFUser.current() != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "tabViewController")
        }
        
        
      //  GMSPlacesClient.provideAPIKey("AIzaSyBfPd2Cqkw3w2ommVPR_Kxy9zptYDmmrdM")
      //  GMSServices.provideAPIKey("AIzaSyBfPd2Cqkw3w2ommVPR_Kxy9zptYDmmrdM")
        GMSPlacesClient.provideAPIKey("AIzaSyDHwb8Zrvurukr1i7mnN0TNh3FaQO5NHIQ")
          GMSServices.provideAPIKey("AIzaSyDHwb8Zrvurukr1i7mnN0TNh3FaQO5NHIQ")
     
        
        return true
    }
    
    func login(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let exploreViewController = storyboard.instantiateViewController(withIdentifier: "tabViewController")
        self.window?.rootViewController = exploreViewController
        
    }

    func logout(){
        PFUser.logOutInBackground(block: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Successful loggout")
                // Load and show the login view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController")
                self.window?.rootViewController = loginViewController
            }
        })
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

