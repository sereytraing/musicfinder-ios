//
//  UserInfoSaver.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation

class UserInfoSaver {
    static let USER_ID_KEY = "user_id"
    
    let userDefault: UserDefaults?
    
    init() {
        userDefault = UserDefaults.standard
    }
    
    func saveUser(id: String) {
        
    }
}
