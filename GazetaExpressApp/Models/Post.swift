//
//  Category.swift
//  GazetaExpressApp
//
//  Created by Esra on 12/17/20.
//  Copyright © 2020 GazetaExpress. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


@objcMembers class Post: Object, Decodable {
    dynamic var id: CLong = 0
    dynamic var date: String? = nil
    dynamic var date_gmt: String? = nil
    dynamic var guid: Guid? = nil
    dynamic var modified: String? = nil
    dynamic var modified_gmt: String? = nil
    dynamic var slug: String? = nil
    dynamic var status: String? = nil
    dynamic var type: String? = nil
    dynamic var link: String? = nil
    dynamic var title: Guid? = nil
    dynamic var content: Content? = nil
    dynamic var excerpt: Content? = nil
    dynamic var author: CLong? = 0
    dynamic var featured_media: CLong? = 0
    dynamic var comment_status: String? = nil
    dynamic var ping_status: String? = nil
    dynamic var sticky: Bool = false
    dynamic var template: String? = nil
    dynamic var format: String? = nil
    dynamic var meta: Meta1? = nil
    var categories = List<Int?>()
    var yst_prominent_words = List<Int?>()
    dynamic var _links: _Links? = nil
    dynamic var _embedded: Embedded?
    
    override class func primaryKey() -> String? {
        return "id"
    }

}

@objcMembers class Guid: Object, Decodable {
    dynamic var rendered: String? = nil
}

@objcMembers class Content: Object, Decodable {
    dynamic var rendered: String? = nil
    let protected: Bool = false
}

@objcMembers class Meta1: Object, Decodable {
    dynamic var amp_status: String? = nil
}

@objcMembers class _Links: Object, Decodable {
    let _self = List<Href_>()
    let collection = List<Href_>()
    let about = List<Href_>()
    let author = List<Author_>()
    let replies = List<Author_>()
    let version_history = List<VHistory>()
    let wp_featuredmedia = List<Author_>()
    let wp_attachment = List<Href_>()
    let wp_term = List<WPTerm>()
    let curies = List<Curies>()

    enum CodingKeys: String, CodingKey {
        case _self = "self"
        case version_history = "version-history"
        case wp_featuredmedia = "wp:featuredmedia"
        case wp_attachment = "wp:attachment"
        case wp_term = "wp:term"
    }
}
@objcMembers class Href_: Object, Decodable {
    dynamic var href: String? = nil
}
@objcMembers class Author_: Object, Decodable {
    dynamic var embeddable: Bool = false
    dynamic var href: String? = nil
    
}
@objcMembers class VHistory: Object, Decodable {
    let count = RealmOptional<Int>()
    dynamic var href: String? = nil
}
@objcMembers class WPTerm: Object, Decodable {
    dynamic var taxonomy: String? = nil
    let embeddable = RealmOptional<Bool>()
    dynamic var href: String? = nil
}
@objcMembers class Curies: Object, Decodable {
    dynamic var name: String? = nil
    dynamic var href: String? = nil
    let templated = RealmOptional<Bool>()
}

@objcMembers class Embedded: Object, Decodable {
    var author = List<_Author>()
    var wpfeaturedmedia = List<WPFeaturedMedia>()
    let wpterm = List<WPTRM>()

    enum CodingKeys: String, CodingKey {
        case wpfeaturedmedia = "wp:featuredmedia"
        case wpterm = "wp:term"
    }
}
@objcMembers class _Author: Object, Decodable {
    dynamic var id: CLong? = 0
    dynamic var name: String? = nil
    dynamic var url: String? = nil
    dynamic var description_: String? = nil
    dynamic var link: String? = nil
    dynamic var slug: String? = nil
    dynamic var avatar_urls: AvatarURL? = nil
    dynamic var mpp_avatar: MPPAvatar? = nil
    dynamic var _links: _Links2? = nil
    
    enum CodingKeys: String, CodingKey {
        case description_ = "description"
    }
}

@objcMembers class AvatarURL: Object, Decodable {
    dynamic var _24 : String? = nil
    dynamic var _48 : String? = nil
    dynamic var _96 : String? = nil

    enum CodingKeys: String, CodingKey {
        case _24 = "24"
        case _48 = "48"
        case _96 = "96"
    }
}

@objcMembers class MPPAvatar: Object, Decodable {
    dynamic var _24 : String? = nil
    dynamic var _48 : String? = nil
    dynamic var _96 : String? = nil
    dynamic var _150 : String? = nil
    dynamic var _300 : String? = nil
    dynamic var full : String? = nil

    enum CodingKeys: String, CodingKey {
        case _24 = "24"
        case _48 = "48"
        case _96 = "96"
        case _150 = "150"
        case _300 = "300"
    }
}

@objcMembers class _Links2: Object, Decodable {
    let _self = List<Href_>()
    let collection = List<Href_>()

    enum CodingKeys: String, CodingKey {
        case _self = "self"
    }
}

@objcMembers class WPFeaturedMedia: Object, Decodable {
    dynamic var id: CLong? = 0
    dynamic var date: String? = nil
    dynamic var slug: String? = nil
    dynamic var type: String? = nil
    dynamic var link: String? = nil
    dynamic var title: Guid? = nil
    dynamic var author: CLong? = 0
    dynamic var caption: Guid? = nil
    dynamic var alt_text: String? = nil
    dynamic var media_type: String? = nil
    dynamic var mime_type: String? = nil
    dynamic var media_details: Media_details? = nil
    dynamic var source_url: String?
    dynamic var _links: Links3? = nil

}

@objcMembers class Media_details: Object, Decodable {
    var width = RealmOptional<Int>()
    var height = RealmOptional<Int>()
    dynamic var file: String? = nil
    dynamic var sizes: Sizes1? = nil
    dynamic var image_meta: Image_Meta? = nil
}

@objcMembers class Sizes1: Object,Decodable {
    dynamic var medium: Size1? = nil
    dynamic var thumbnail: Size1? = nil
    dynamic var medium_large: Size1? = nil
    dynamic var custom_size: Size1? = nil
    dynamic var profile_24: Size1? = nil
    dynamic var profile_48: Size1? = nil
    dynamic var profile_96: Size1? = nil
    dynamic var profile_150: Size1? = nil
    dynamic var profile_300: Size1? = nil
    dynamic var full: Size1? = nil

    enum CodingKeys: String, CodingKey {
        case custom_size = "custom-size"
    }
}
@objcMembers class Size1: Object, Decodable {
    dynamic var file: String? = nil
    let width = RealmOptional<Int>()
    let height = RealmOptional<Int>()
    dynamic var mime_type: String? = nil
    dynamic var source_url: String? = nil
}

@objcMembers class Image_Meta: Object, Decodable {
    let aperture = RealmOptional<Int>()
    dynamic var credit: String? = nil
    dynamic var camera: String? = nil
    dynamic var caption: String? = nil
    dynamic var created_timestamp: String? = nil
    dynamic var copyright: String? = nil
    dynamic var focal_length: String? = nil
    dynamic var iso: String? = nil
    dynamic var shutter_speed: String? = nil
    dynamic var title: String? = nil
    dynamic var orientation: String? = nil
    let kw = List<String?>()

    enum CodingKeys: String, CodingKey {
        case kw = "keywords"
    }
}

@objcMembers class Links3: Object, Decodable {
        let _self = List<Href_>()
        let collection = List<Href_>()
        let about = List<Href_>()
        let author = List<Author_>()
        let replies = List<Author_>()

    enum CodingKeys: String, CodingKey {
        case _self = "self"
    }
}

@objcMembers class WpTerm1: Object, Decodable {
    dynamic var id: CLong? = 0
    dynamic var link: String? = nil
    dynamic var name: String? = nil
    dynamic var slug: String? = nil
    dynamic var taxonomy: String? = nil
    dynamic var _links: _Links4? = nil
}
@objcMembers class _Links4: Object, Decodable {
    let _self = List<Href_>()
    let collection = List<Href_>()
    let about = List<Href_>()
    let wppost_type = List<Href_>()
    let curies = List<Curies>()

    enum CodingKeys: String, CodingKey {
        case _self = "self"
        case wppost_type = "wp:post_type"
    }
}

@objcMembers class WPTRM: Object, Decodable {
    let term = List<WpTerm1>()
}
