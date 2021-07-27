//
//  MoreOpenedViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 12/8/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit

class MoreOpenedViewController: UIViewController {
    
    @IBOutlet weak var settingsNameLabel: UILabel!
    @IBOutlet weak var settingsDescTextView: UITextView!
    
    var nameLbl: String!
    var item: MoreItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsNameLabel.text = item.moreLabel
        settingsDescTextView.text = item.moreDesc
        
    }
    
}
