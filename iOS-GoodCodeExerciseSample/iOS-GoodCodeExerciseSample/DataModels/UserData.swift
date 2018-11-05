//
//  UserData.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/4/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

class UserData: Codable {
    var id: String
    var name: String
    var email: String
    
    init (id: String, name: String, email: String) {
        
        self.id = id
        self.name = name
        self.email = email
    }
}
