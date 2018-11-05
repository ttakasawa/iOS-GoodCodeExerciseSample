//
//  NetworkManager.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/4/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase
import FirebaseStorage
import FirebaseDatabase

//MARK: NetworkManager is responsible for retrieving / updating data on Firebase real-time DB and Authentication. 
protocol NetworkManager {
    var firebaseDBConnection: DatabaseReference { get set }
    
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoints, completion: @escaping (_ result: T?, _ error: Error?) -> Void)
    func fetchAuth(endpoint: FirebaseEndpoints, completion: @escaping (_ id: String?, _ error: Error?) -> Void)
    func firebaseAtomicStore(endpoints: [FirebaseEndpoints], completion: @escaping ( _ success: Bool) -> Void)
}


//MARK: This is the actual implementation of NetworkManager.
extension NetworkManager where Self: Global.Network {
    
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoints, completion: @escaping (_ result: T?, _ error: Error?) -> Void) {
        
        var realtimeRef: DatabaseReference!
        
        if let path = endpoint.path {
            realtimeRef = self.firebaseDBConnection.child(path)
        }else{
            realtimeRef = self.firebaseDBConnection
        }
        
        
        if let body = endpoint.body {
            // If body exists, it is write operation
            
            if (endpoint.type == EndpointsType.storeSingleObject){
                
                realtimeRef.setValue(body)
                
                if let storedData = body as? T{
                    completion(storedData, nil)
                }else{
                    completion(nil, nil)
                }
                
            }
        } else {
            // Else, it is read operation
            
            if (endpoint.type == EndpointsType.querySingleObject){
                realtimeRef.observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let value = snapshot.value else { return }
                    
                    do {
                        let model = try FirebaseDecoder().decode(T.self, from: value)
                        completion(model, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                    
                })
            }
        }
        
    }
    
    func fetchAuth(endpoint: FirebaseEndpoints, completion: @escaping (_ id: String?, _ error: Error?) -> Void) {
        
    }
    
    func firebaseAtomicStore(endpoints: [FirebaseEndpoints], completion: @escaping ( _ success: Bool) -> Void) {
        
        let ref = self.firebaseDBConnection
        var fanoutObj: [String: Any] = [:]
        
        for i in 0..<endpoints.count{
            
            guard let path = endpoints[i].path else {
                print("path not found")
                return
            }
            
            guard let body = endpoints[i].body else {
                print("body not found")
                return
            }
            
            fanoutObj[path] = body
        }
        
        ref.updateChildValues(fanoutObj) { (error, ref) in
            if error != nil {
                completion(false)
            }else{
                completion (true)
            }
        }
    }
    
}


//MARK: This can be used for test purpose. Using this implementation allows me to test UI before storing data to real database in Firebase. One might just mock a json data locally.
extension NetworkManager where Self: Global.DemoNetwork {
    
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoints, completion: @escaping (_ result: T?, _ error: Error?) -> Void) {
    }
    
    func fetchAuth(endpoint: FirebaseEndpoints, completion: @escaping (_ id: String?, _ error: Error?) -> Void) {
        
    }
    
    func firebaseAtomicStore(endpoints: [FirebaseEndpoints], completion: @escaping ( _ success: Bool) -> Void) {
        
    }
    
}
