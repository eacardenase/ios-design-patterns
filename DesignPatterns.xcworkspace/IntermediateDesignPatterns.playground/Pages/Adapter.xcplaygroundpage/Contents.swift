/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)

 # Adapter
 - - - - - - - - - -
 ![Adapter Diagram](Adapter_Diagram.png)

 The adapter pattern allows incompatible types to work together. It involves four components:

 1. An **object using an adapter** is the object that depends on the new protocol.

 2. The **new protocol** that is desired to be used.

 3. A **legacy object** that existed before the protocol was made and cannot be modified directly to conform to it.

 4. An **adapter** that's created to conform to the protocol and passes calls onto the legacy object.

 ## Code Example
 */
import UIKit

// MARK: - Legacy Object

public struct GoogleUser {
    public var email: String
    public var password: String
    public var token: String
}

public class GoogleAuthenticator {
    public func login(
        email: String,
        password: String,
        completion: @escaping (Result<GoogleUser, Error>) -> Void
    ) {
        let token = "special-token-value"
        let user = GoogleUser(email: email, password: password, token: token)

        completion(.success(user))
    }
}

// MARK: - New Protocol

public struct User {
    public let email: String
    public let password: String
}

public struct Token {
    public let value: String
}

public protocol AuthenticationService {
    func login(
        email: String,
        password: String,
        success: @escaping (User, Token) -> Void,
        failure: @escaping (Error?) -> Void
    )
}

// MARK: - Adapter

public class GoogleAuthenticatorAdapter: AuthenticationService {
    private var authenticator = GoogleAuthenticator()

    public func login(
        email: String,
        password: String,
        success: @escaping (User, Token) -> Void,
        failure: @escaping ((any Error)?) -> Void
    ) {
        authenticator.login(email: email, password: password) { result in
            switch result {
            case .success(let googleUser):
                let token = Token(value: googleUser.token)
                let user = User(
                    email: googleUser.email,
                    password: googleUser.password
                )

                success(user, token)
            case .failure(let error):
                failure(error)
            }
        }
    }
}

// MARK: - Object Using an Adapter

class LoginController: UIViewController {

    // MARK: - Properties

    public let authService: AuthenticationService

    var emailTextField = UITextField()
    var passwordTextField = UITextField()

    // MARK: - Object Lifecycle

    public init(authService: AuthenticationService) {
        self.authService = authService

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - AuthenticationService

    public func login() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text
        else {
            print("Email and password are required inputs!")

            return
        }

        authService.login(email: email, password: password) { user, token in
            print("Auth succeeded: \(user.email), \(token.value)")
        } failure: { error in
            print("Auth failed with error: no error provided")
        }

    }
}

// MARK: - Example

let viewController = LoginController(authService: GoogleAuthenticatorAdapter())

viewController.emailTextField.text = "user@example.com"
viewController.passwordTextField.text = "password"

viewController.login()
