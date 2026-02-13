/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)

 # Observer
 - - - - - - - - - -
 ![Observer Diagram](Observer_Diagram.png)

 The observer pattern allows "observer" objects to register for and receive updates whenever changes are made to "subject" objects.

 This pattern allows us to define "one-to-many" relationships between many observers receiving updates from the same subject.

 ## Code Example
 */
import Combine

public class User {

    @Published var name: String
    var age = 29

    public init(name: String) {
        self.name = name
    }
}

let user = User(name: "Edwin")
let publisher = user.$name
var suscriber: AnyCancellable? = publisher.sink {
    print("User's name is \($0)")
}

let anotherSuscriber = publisher.sink {
    print("Another subscriber \($0)")
}

user.name = "Luisa"

user.age = 30

suscriber = nil
user.name = "Edwin left the chat group"
