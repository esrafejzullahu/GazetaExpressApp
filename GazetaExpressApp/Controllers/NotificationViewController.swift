//
//  NotificationViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 9/1/21.
//  Copyright © 2021 GazetaExpress. All rights reserved.
//

import UIKit
import WebKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var linkToLoad: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(NSURLRequest(url: NSURL(string: "google.com")! as URL) as URLRequest)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
