//
//  UserEndpoints.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/4/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

enum UserEndpoints: FirebaseEndpoints {
    
    case login
    case queryUser(userId: String)
    case updateUser(user: UserData)
    
    var path: String? {
        switch self {
        case .updateUser(let user):
            return "Users/\(user.id)"
        case .queryUser(let userId):
            return "Users/\(userId)"
        default:
            return nil
        }
    }
    
    var body: Any? {
        switch self {
        case .updateUser(let user):
            return self.toData(object: user)
        default:
            return nil
        }
    }
    
    var type: EndpointsType? {
        switch self {
        case .updateUser( _):
            return EndpointsType.storeSingleObject
        case .queryUser( _):
            return EndpointsType.querySingleObject
        default:
            return nil
        }
    }
}
