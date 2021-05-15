//
//  CategoryDto.swift
//  GazetaExpressApp
//
//  Created by Esra on 11/9/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import Foundation

class Category: Codable {
    var id: Int
    var count: Int?
    var description: String?
    var link: String?
    var name: String?
    var slug: String?
    var taxonomy: String?
    var parent: Int?
    var meta: [String]?
    var _links: Links?
}

struct Links: Codable {
    var _self: [Href]?
    var collection: [Href]?
    var about: [Href]?
    var post_type: [Href]?
    var curies: [Curie]?
    
    enum CodingKeys: String, CodingKey {
      case _self = "self"
      case post_type = "wp:post_type"

      }
}

struct Href: Codable {
    var href: String?
}

struct Curie: Codable {
    var name: String?
    var href: String?
    var templated: Bool?
}
