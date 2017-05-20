//
//  UserSpotify.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class UserSpotify : Mappable{
    
    var birthdate: String?
    var country: String?
    var display_name: String?
    var email: String?
    var href: String?
    var type: String?
    var images: [String :String?]?
    
    required init?(map: Map) {
        
    }
     
     func mapping(map: Map) {
        display_name <- map["display_name"]
     }
}

