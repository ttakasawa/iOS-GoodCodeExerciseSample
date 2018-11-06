# iOS-GoodCodeExerciseSample

This project is a sample project to practice writing clean and manageable protocol oriented code. 

## Data Model
UserData: This is a concrete instance 

## Network Layer

UserNetwork: This is model object responsible for querying, updating, and login of UserData object
```
protocol UserNetwork {

    var user: UserData? { get set }
    
    func login(email: String, password: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func queryUser(userId: String, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    func updateUserInfo(user: UserData, completion: @escaping (_ user: UserData?, _ error: Error?) -> Void)
    
}
```

NetworkManager: This is responsible for communicating with Firebase real time database.
```
protocol NetworkManager {
    var firebaseDBConnection: DatabaseReference { get set }
    
    func fetchFirebase<T: Decodable>(endpoint: FirebaseEndpoints, completion: @escaping (_ result: T?, _ error: Error?) -> Void)
    func fetchAuth(endpoint: FirebaseEndpoints, completion: @escaping (_ id: String?, _ error: Error?) -> Void)
    func firebaseAtomicStore(endpoints: [FirebaseEndpoints], completion: @escaping ( _ success: Bool) -> Void)
}
```
In this demo, only fetchFirebase is used. This function is solely responsible for communicating with real time database. This is only possible by FirebaseEndpoints protocol, which is introduced in next section. Clever use of endpoint allows fetchFirebase to stay absctract, so it can be used over and over.

SampleNetwork: All of Network objects listed above are attached to this protocol. Because this app is very simple one, it only has few protocols attached. However, you can keep adding more stuff with other themes here.

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

If you'd like to test without real network call to Firebase, you can use DemoNetowrk and query from local json. This is convenient for the testing UI of app. For example, it enables you to test how UI interact with new data without actually updating real time database. You can have different implementation like following:
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
Clever use of endpoints is the reason why I could keep reusing one function to query/update real time database.

FirebaseEndpoints: This protocol promises variables needed to make call to database.
```
protocol FirebaseEndpoints {
    
    var path: String? { get }
    var body: Any? { get }
    
    func toData<T: Encodable>(object: T) -> Any?
    
}
```
As you can see, you can use body to distinguish whether a call is read or write. (When you would like to read from database, you do not need body)
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

Displayable is responsible for providing information that is needed to draw a view on ViewController.

ApplicationDisplayable: This is responsible for providing information about application material. Each UserApplicationData object comforms this protocol. ViewController that needs to display such information only knows about this displayable, and not about a concrete instance of data. 
```
protocol ApplicationDisplayable {

    var name: String { get }
    var url: String { get }
    var icon: UIImage { get }
    var themeColor: UIColor { get }
    
}
```

This protocol is an interface for concrete object, UserApplicationData. By creating such a protocol, ViewController does not need to know anything about concrete instance of data model. Instead, it uses ApplicationDisplayable to make sure that all necessary information has been provided.
```
extension UserApplicationData: ApplicationDisplayable {
    //may need to supply computed values here
}
```


## Stylable

Stylable is responsible for styling views. It can be composition of multiple protocols such as ColorStyles or FontStyles, which may look like this:
```
protocol ColorStyles {
    
    func getMainColor() -> UIColor
    func getSecondaryColor() -> UIColor
    
}
```

It can be used for any object by making extension.

```
extension Stylable where Self: DetailViewController {

    func getMainColor() -> UIColor {
        return UIColor.white
    }

}
```

## ViewControllers

RootTableViewController: This ViewController is responsible for initiating a network call from Global.network, which is injected in the initialization of this ViewController. This network object can be injected to other ViewController, which requires to make netwrok call, if needed. 
```
init (network: SampleNetwork) {

    self.network = network
    
}
```
Then, you can simply call any network call as follows:
```
self.network.queryUser(userId: "User_Id_Goes_Here") { (user: UserData?, error: Error?) in
    if error != nil {
    
        return
                
    }else{
    
        //Now, you have user data
    }
}
```
Here, it is important not to call any functions in NetworkManager directly.


DetailViewController: This is just WkWebView displaying website or pdf stored in Firebase Storage

