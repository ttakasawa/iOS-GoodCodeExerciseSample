//
//  Network.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/4/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol SampleNetwork: NetworkManager, UserNetwork { } 

struct Global {
    class Network: SampleNetwork {
        //var baseURLString: String = "https://us-central1-moxie1-7fca0.cloudfunctions.net/app"
        
        var firebaseDBConnection: DatabaseReference
        var user: UserData?
        
        init() {
            self.firebaseDBConnection = Database.database().reference(fromURL: "https://kaiwa-1fe22.firebaseio.com/")
        }
    }
    
    class DemoNetwork: SampleNetwork {
        
        //var baseURLString: String = "https://us-central1-moxie1-7fca0.cloudfunctions.net/app"
        var firebaseDBConnection: DatabaseReference
        var user: UserData?
        
        init() {
            self.firebaseDBConnection = Database.database().reference(fromURL: "https://kaiwa-1fe22.firebaseio.com/")
        }
        
    }
    
    static var network: SampleNetwork = Network()
}

