# iOS-GoodCodeExerciseSample

This project is a sample project to practice writing clean and manageable protocol oriented code. It is an app that contains all information necessary for recruiters to examine candidates. It may eliminate the need for candidates to keep submitting applications to multiple website over and over, if standardized. In this sample, I have added Resume, Github link, LinkedIn link, my iOS app, Business Insider article featureing my app, and transcript. Please take a look!
##### Note
* Please feel free to run it on your iPhone!
* Time of development: 20 hrs


## Sample Images
<img width="924" height="451" src="Resource/SampleImages.png"/>

## Data Model
#### UserData
This object is responsible for storing user's attributes. Because UserData should be mutable, reference type is more appropriate.
```
class UserData: Codable {
    var id: String
    var name: String
    var email: String
    var userApplicationMaterial: [UserApplicationData]
    
    init (id: String, name: String, email: String) {
        
        self.id = id
        self.name = name
        self.email = email
        self.userApplicationMaterial = []
    }
}
```
#### UserApplicationData
UserApplicationData object contains user generated values for each of their application materials. Value type is sufficient for this object, as it does not need to be mutable.
```
struct UserApplicationData: Codable {
    
    var id: String
    var material: ApplicationMaterial
    var name: String
    var url: String
    
}
```

#### ApplicationMaterial
This is an enumerator for differet types of application materials such as linkedin, resume, etc.
```
enum ApplicationMaterial: String, Codable, ColorStyles {

    case resume
    case github
    // so on
    
    var iconImage: UIImage {
        // return icon for each case
    }
    
    var backgroundColor: UIColor {
        switch self {
        
        //Each case goes here
        
        default:
            return self.getRed()
        }
    ]
}
```

## Network Layer
Here comes the fun part.

### NetworkManager
NetworkManager is responsible for communicating with Firebase, and is the only one that is making calls to Firebase 
* Or, retrieving data from local json file for testing purpose. (mentioned in 'unit testing' section)
```
protocol NetworkManager {
    var firebaseDBConnection: DatabaseReference { get set }
    
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoints, completion: @escaping (_ result: T?, _ error: Error?) -> Void)
    func fetchAuth(endpoint: FirebaseEndpoints, completion: @escaping (_ id: String?, _ error: Error?) -> Void)
    func firebaseAtomicStore(endpoints: [FirebaseEndpoints], completion: @escaping ( _ success: Bool) -> Void)
}
```


One of the functions here, fetchFirebase, is solely responsible for communicating with real time database. A clever use of endpoints allows fetchFirebase to stay absctract, so it can be re-used over and over. 

* The description for endpoint is in the next subsection.

##### fetchFirebase
This function is an abstract function which should be used for any calls to real time database. Variables that need to be changed based on network calls should be injected as an endpoint. In addition, this function only returns generic type variable that is gurenteed to be decodable. Therefore, it is responsibility of interfaces to convert from generic type variable to concrete type that app uses.

###### Path
path can be created by combining realtimeRef variable (declared in NetworkManager) and path of endpoint. The variable, realtimeRef, is fixed for all kinds of call. On the other hand, path is a variable of FirebaseEndpoints, which is injected to this function every time the network call is made. Of course, this endpoint should be unique for every calls.
```
var realtimeRef: DatabaseReference!
        
if let path = endpoint.path {
    realtimeRef = self.firebaseDBConnection.child(path)
}else{
    realtimeRef = self.firebaseDBConnection
}
```

###### Querying or updating
Whether the call is read or write can be determined based on the body of endpoints. When you are reading from database, body must be empty. On the other hand, body has to exist if you are writing to database.
```
if let body = endpoint.body {

    // If body exists, it is write operation

    realtimeRef.setValue(body)

    if let storedData = body as? T{
        completion(storedData, nil)
    }else{
        completion(nil, nil)
    }
    
} else {

    // Else, it is read operation
    
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
```

### Endpoints
As briefly mentioned earlier, a clever use of endpoints is the reason why I could keep re-using one function to query / update any data from real time database.

#### FirebaseEndpoints
This protocol promises variables, which are needed to make calls to database, will be provided. By changing the value of those variables in FirebaseEndpoints and injecting them to fetchFirebase() function in NetworkManager, you can make fetchFirebase() function to stay abstract.
```
protocol FirebaseEndpoints {
    
    var path: String? { get }
    var body: Any? { get }
    
    func toData<T: Encodable>(object: T) -> Any?
    
}
```

This protocol also gurantees a method which takes Encodable object as parameter and convert to accepted types for firebase real time database.
```
import CodableFirebase

extension FirebaseEndpoints {
    func toData<T: Encodable>(object: T) -> Any? {
        let encoder = FirebaseEncoder()
        do{
            let jsonData = try encoder.encode(object)
            return jsonData
        }catch{
            return nil
        }
    }
}
```


Generally, there are many different types of calls you have to make to real time database as the app gets more complex. Therefore, it may be a good practice to group endpoints by theme. 


For example, all the UserData related endpoints might be grouped as following:
```
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
        //irrelevant for now..
    }
    
}
```
### Interface
With NetworkManager and FirebaseEndpoints being set up, it is time to work on interface for NetworkManager. As briefly mentioned earlier, it is responsibility of interfaces to convert generic type variables to concrete type variables that are used within the app.

#### UserNetwork
UserNetwork is responsible for behaviors of UserData object (such as querying, updating, and log-in). It executes all networking stuff for UserData object, and works as an interface of NetworkManager.
```
protocol UserNetwork {

    var user: UserData? { get set }
    
    func login(email: String, password: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func queryUser(userId: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func updateUserInfo(user: UserData, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    
}
```

NetworkManager, is the one that is actually making calls to the firebase. UserNetwork is just an interface of NetworkManager. Therefore, the implementation of UserNetwork should be written as following:

```
extension UserNetwork where Self: NetworkManager {
    func login(email: String, password: String, completion: @escaping (_ user: UserData? , _ error: Error?) -> Void) {
        
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//        }
        
    }
    
    
    func updateUserInfo(user: UserData, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void) {
        
        self.fetchFirebase(endpoint: UserEndpoints.updateUser(user: user)) { (user: UserData?, error: Error?) in
            completion(user, error)
        }
    }
    
    func queryUser(userId: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void){
        
        self.fetchFirebase(endpoint: UserEndpoints.queryUser(userId: userId)) { (userData: UserData?, error: Error?) in
            
            completion(userData, error)
            
        }
    }
}
```




### SampleNetwork
All of Network objects listed above should be attached to this protocol. As the app gets larger and more complex, you can attach more Networking protocols here.
```
protocol SampleNetwork: NetworkManager, UserNetwork { } 
```



### Top Level Network Layer

SampleNetwork can be used as a singleton on Global struct like following:
```
struct Global {

    class Network: SampleNetwork {
    
        var firebaseDBConnection: DatabaseReference
        var user: UserData?
        //initialize necessary information here.
    }
    
    class DemoNetwork: SampleNetwork {
    
        var firebaseDBConnection: DatabaseReference
        var user: UserData?
    }
    
    static var network: SampleNetwork = Network()
}
```

This Global.network should be injected to the first ViewController upon initialization. Afterwards, it can be passed to any other ViewControllers that needs to make network calls. 




### Unit Testing
The ability to make network calls internally without really updating the firebae database can be useful for testing purpose. For example, imagine you are trying to upload new data to database, but you are not sure if new data looks good on the current UI. If you make a real call and upload data, it will affect real users. Therefore, ability to test UI without actually updating real time database can be useful.

#### DemoNetwork

DemoNetwork in Global is designed to solve this problem. 

If you'd like to see the UI of the app without making real network calls to Firebase, you can use DemoNetowrk and query from local json. 

Depending on whether or not you would make real network call to firebase, you need to have different implementations of NetworkManager like following:
```
extension NetworkManager where Self: Global.Network {
    // real call to firebase
    // Please check out the project, it is too long for Readme
}
extension NetworkManager where Self: Global.DemoNetwork {
    // network call from local json file
}
```


In order to switch to DemoNetwork, you'd simpley add
```
if isDemo {

    Global.network = Global.DemoNetwork()
    
}
```
in application(_:didFinishLaunchingWithOptions:) of AppDelegate.




## Displayables

Displayable is responsible for providing data that is needed to draw a view on ViewController. 

### ApplicationDisplayable

ApplicationDisplayable is responsible for providing data about application materials. Each UserApplicationData object should conform this protocol.
```
protocol ApplicationDisplayable {

    var name: String { get }
    var url: String { get }
    var icon: UIImage { get }
    var themeColor: UIColor { get }
    
}
```


This protocol is an interface for concrete object, UserApplicationData. By using such a protocol, ViewController does not need to know anything about concrete instance of data object to draw a view. 
```
extension UserApplicationData: ApplicationDisplayable {

    // You may need to supply data that is not in UserApplicationData, such as computed values here
    
    var icon: UIImage {
        return self.material.iconImage
    }
    
    var themeColor: UIColor {
        return self.material.backgroundColor
    }
}
```




## Stylable

Stylable is responsible for styling views. It can be the composition of multiple protocols such as ColorStyles or FontStyles, which may look like this:
```
protocol Stylable: ColorStyles, FontStyles { }

protocol ColorStyles {
    
    func getMainColor() -> UIColor
    func getSecondaryColor() -> UIColor
    
}

protocol FontStyles {
    // font stuff
}
```



It can be customized for any objects like following: 

```

extension Stylable where Self: DetailViewController {

    func getMainColor() -> UIColor {
        return UIColor.white
    }

}
```

Then, you could attach it to any objects:
```
class DetailViewController: UIViewController, Stylable {

    // You can call any functions in Stylable after init method now.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.getMainColor()
    }
    
}
```





## ViewControllers
### RootTableViewController
RootTableViewController is responsible for initiating a network call from Global.network, which is injected in the initialization of this ViewController. This network object can be injected to other ViewController, that need to make netwrok calls.
```
class RootTableViewController: UITableViewController {

    var network: UserNetwork

    init (network: SampleNetwork) {
    
        self.network = network
        super.init(nibName: nil, bundle: nil)
        
    }
}
```



Then, you can simply call any network call as following:
```
self.network.queryUser(userId: "User_Id_Goes_Here") { (user: UserData?, error: Error?) in

    if error != nil {
        return
    }else{
    
        //Now, you have user data
    }
}
```

##### Important Side Note
Here, it is important not to call any functions in NetworkManager directly. The whole purpose of UserNetwork is to offer a layers of abstractions. This way, code remains more transparent, and also protocols such as NetworkManager can remain abstract. Notice that variable network is type of UserNetwork. 


### DetailViewController
This ViewController just displays WkWebView based on URL that is passed in initialization method. Both website and pdf are displayed in this manner. 


