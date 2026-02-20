/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)

 # Model-view-controller (MVC)
 - - - - - - - - - -
 ![MVC Diagram](MVC_Diagram.png)

 The model-view-controller (MVC) pattern separates objects into three types: models, views and controllers.

 **Models** hold onto application data. They are usually structs or simple classes.

 **Views** display visual elements and controls on screen. They are usually subclasses of `UIView`.

 **Controllers** coordinate between models and views. They are usually subclasses of `UIViewController`.

 ## Code Example
 */
import UIKit

// MARK: - Model

public struct Address {

    // MARK: - Properties

    public var street: String
    public var city: String
    public var state: String
    public var zipCode: String

}

// MARK: - View

public final class AddressView: UIView {

    // MARK: - Properties

    public var streetTextField: UITextField = {
        let textField = UITextField()

        return textField
    }()

    public var cityTextField: UITextField = {
        let textField = UITextField()

        return textField
    }()

    public var stateTextField: UITextField = {
        let textField = UITextField()

        return textField
    }()

    public var zipCodeTextField: UITextField = {
        let textField = UITextField()

        return textField
    }()

}

// MARK: - Controller

public final class AddressViewController: UIViewController {

    // MARK: - Properties

    public var address: Address? {
        didSet { updateViewFromAddress() }
    }
    public let addressView = AddressView()

    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        updateViewFromAddress()
    }

}

// MARK: - Helpers

extension AddressViewController {

    private func updateViewFromAddress() {
        guard let address else { return }

        addressView.streetTextField.text = address.street
        addressView.cityTextField.text = address.city
        addressView.stateTextField.text = address.state
        addressView.zipCodeTextField.text = address.zipCode
    }

    private func updateAddressFromView(_ sender: Any) {
        guard
            let street = addressView.streetTextField.text, !street.isEmpty,
            let city = addressView.cityTextField.text, !city.isEmpty,
            let state = addressView.stateTextField.text, !state.isEmpty,
            let zipCode = addressView.zipCodeTextField.text, !zipCode.isEmpty
        else {
            return
        }

        address = Address(
            street: street,
            city: city,
            state: state,
            zipCode: zipCode
        )
    }

}
