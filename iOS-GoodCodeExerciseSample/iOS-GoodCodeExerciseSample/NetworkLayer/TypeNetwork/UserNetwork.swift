//
//  UserNetwork.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/4/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

protocol UserNetwork {
    var user: UserData? { get set }
    
    func login(email: String, password: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func queryUser(userId: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func updateUserInfo(user: UserData, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
}


extension UserNetwork where Self: NetworkManager {
    func login(email: String, password: String, completion: @escaping (_ user: UserData? , _ error: Error?) -> Void) {
        
//        self.fetchAuth(endpoint: UserEndpoints.login(email: email, password: password)){ (returnUserId: String?, error: Error?) in
//            self.queryUser(completion: { (user: UserData?, error: Error?) in
//                completion(user, error)
//            })
//        }
    }
    
    
    func updateUserInfo(user: UserData, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void) {
        
        self.fetchFirebase(endpoint: UserEndpoints.updateUser(user: user)) { (user: UserData?, error: Error?) in
            completion(user, error)
        }
    }
    
    func queryUser(userId: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void){
        
        self.fetchFirebase(endpoint: UserEndpoints.queryUser(userId: userId)) { (userData: UserData?, error: Error?) in
            if error != nil {
                completion(nil, error)
            }else{
                
                completion(userData, nil)
            }
        }
        
    }
}
