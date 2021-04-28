//
//  SDCodersViewController.swift
//  boredom
//
//  Created by Jigyasaa Sood on 4/28/21.
//  Copyright © 2021 Codacity LLC. All rights reserved.
//

import UIKit
import WebKit

class SDCodersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let link = URL(string:"https://socialspark.app/")!
        let request = URLRequest(url: link)
        webViewOutlet.load(request)
    }
    
    @IBOutlet weak var webViewOutlet: WKWebView!
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
