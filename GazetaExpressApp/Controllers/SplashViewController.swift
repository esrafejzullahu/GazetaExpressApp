//
//  SplashViewController.swift
//  GazetaExpressApp
//
//  Created by Esra on 3/14/21.
//  Copyright © 2021 GazetaExpress. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.animate(newText: "Portali numër 1 në Ballkan" ?? "Gazeta Express", characterDelay: 0.03)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.3, execute: {
            self.performSegue(withIdentifier:"goToMain",sender: self)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}
extension UILabel {
    
    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            
            self.text = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
    
}
