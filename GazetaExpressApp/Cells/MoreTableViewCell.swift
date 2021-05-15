//
//  MoreTableViewCell.swift
//  GazetaExpressApp
//
//  Created by Esra on 10/10/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    @IBOutlet weak var moreLabel: UILabel!
    var moreContent: String?
    
    func configureCell(with more: MoreItem) {
        moreLabel.text = more.moreLabel
        moreContent = more.moreDesc
        
}
}
