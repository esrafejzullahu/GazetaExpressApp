//
//  MenuTableViewCell.swift
//  GazetaExpressApp
//
//  Created by Esra on 10/30/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var itemTitleLabel: UILabel!
    
    func configureCell(with menu: MenuItem) {
        itemTitleLabel.text = menu.itemTitle
    }

}
