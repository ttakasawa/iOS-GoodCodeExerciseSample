# iOS-GoodCodeExerciseSample

This project is a sample project to practice writing clean and manageable protocol oriented code. Please take a look!

## Sample Images
<img width="924" height="451" src="Resource/SampleImages.png"/>

## Data Model
### UserData
This is responsible for storing user's attributes.
### ApplicationMaterial
This is enum for differet types of application materials such as linkedin, resume, etc.

## Network Layer

#### UserNetwork
This is model object responsible for querying, updating, and login of UserData object. It executes all networking stuff for UserData object.
```
protocol UserNetwork {

    var user: UserData? { get set }
    
    func login(email: String, password: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func queryUser(userId: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func updateUserInfo(user: UserData, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    
}
```


#### NetworkManager
This is responsible for communicating with Firebase real time database.
```
protocol NetworkManager {
    var firebaseDBConnection: DatabaseReference { get set }
    
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoints, completion: @escaping (_ result: T?, _ error: Error?) -> Void)
    func fetchAuth(endpoint: FirebaseEndpoints, completion: @escaping (_ id: String?, _ error: Error?) -> Void)
    func firebaseAtomicStore(endpoints: [FirebaseEndpoints], completion: @escaping ( _ success: Bool) -> Void)
}
```
In this demo, only fetchFirebase is used. This function is solely responsible for communicating with real time database.  Clever use of endpoint allows fetchFirebase to stay absctract, so it can be reused over and over. The description for FirebaseEndpoints is in the later subsection.




#### SampleNetwork
All of Network objects listed above are attached to this protocol. As the app gets larger and more complex, you can attach more Networking Protocols here.
```
protocol SampleNetwork: NetworkManager, UserNetwork { } 
```



#### Top Level Network Layer

SampleNetwork can be used as a singleton on Global struct like following:
```
struct Global {

    class Network: SampleNetwork {
        //initialize necessary information here.
    }
    
    class DemoNetwork: SampleNetwork {
    }
    
    static var network: SampleNetwork = Network()
}
```

This Global.network should be injected to the first ViewController upon initialization. Afterwards, it can be passed to any other ViewControllers that needs to make network calls. 




#### Unit Testing

If you'd like to see UI of the app without making real network calls to Firebase, you can use DemoNetowrk and query from local json. This is convenient for the testing purpose. For example, it enables you to test how UI interact with new data without actually updating real time database. 


Depending on whether or not you would make network call to firebase, you might want to have different implementation of NetworkManager like following:
```
extension NetworkManager where Self: Global.Network {
    //real
}
extension NetworkManager where Self: Global.DemoNetwork {
    //test
}
```

In order to switch to DemoNetwork, you'd simpley add
```
Global.network = Global.DemoNetwork()
```
in AppDelegate.




### Endpoints
As briefly mentioned earlier, a clever use of endpoints is the reason why I could keep reusing one function to query / update any data from real time database.

#### FirebaseEndpoints
This protocol promises variables needed to make call to database.
```
protocol FirebaseEndpoints {
    
    var path: String? { get }
    var body: Any? { get }
    
    func toData<T: Encodable>(object: T) -> Any?
    
}
```
As you can see, you can use 'body' to distinguish whether a call is read or write. (When you would like to read from database, your 'body' variable is nil.)


Generally, there are many different types of calls you have to make to operate more complex app. Therefore, it may be a good practice to group endpoints by theme. 


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
    
}
```





## Displayables

Displayable is responsible for providing data that is needed to draw a view on ViewController.

### ApplicationDisplayable

This is responsible for providing data about application materials. Each UserApplicationData object comforms this protocol. 
```
protocol ApplicationDisplayable {

    var name: String { get }
    var url: String { get }
    var icon: UIImage { get }
    var themeColor: UIColor { get }
    
}
```


This protocol is an interface for concrete object, UserApplicationData. By using such a protocol, ViewController does not need to know anything about concrete instance of data object to draw a view. Instead, it has ApplicationDisplayable to make sure that all necessary data would be provided.
```
extension UserApplicationData: ApplicationDisplayable {
    //may need to supply data that is not in UserApplicationData, such as computed values here
}
```




## Stylable

Stylable is responsible for styling views. It can be the composition of multiple protocols such as ColorStyles or FontStyles, which may look like this:
```
protocol ColorStyles {
    
    func getMainColor() -> UIColor
    func getSecondaryColor() -> UIColor
    
}
```



It can be customized and used for any objects by making extension.

```
extension Stylable where Self: DetailViewController {

    func getMainColor() -> UIColor {
        return UIColor.white
    }

}
```






## ViewControllers

RootTableViewController: This ViewController is responsible for initiating a network call from Global.network, which is injected in the initialization. This network object can be injected to other ViewController, which requires to make netwrok call, if needed. 
```
init (network: SampleNetwork) {

    self.network = network
    
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



Here, it is important not to call any functions in NetworkManager directly. The whole purpose of UserNetwork is to offer a layer of abstractions. This way, code remains more transparent, and also protocols such as NetworkManager can remain abstract.




DetailViewController: This is just WkWebView displaying website or pdf stored in Firebase Storage.


