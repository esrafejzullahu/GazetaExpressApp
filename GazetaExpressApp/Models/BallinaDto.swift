//
//  BallinaDto.swift
//  GazetaExpressApp
//
//  Created by Esra on 12/7/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import Foundation
import RealmSwift

class Ballina: Object, Decodable {
    @objc dynamic var ID: CLong
    @objc dynamic var title: String?
    @objc dynamic var link: String?
    @objc dynamic var post_date: String?
    @objc dynamic var post_modified: String?
    @objc dynamic var featured_img: String?
    @objc dynamic var content: String?
    @objc dynamic var position: String?
    
    override class func primaryKey() -> String? {
        return "ID"
    }
    
}
