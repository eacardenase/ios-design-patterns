/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)

 # Delegation
 - - - - - - - - - -
 ![Delegation Diagram](Delegation_Diagram.png)

 The delegation pattern allows an object to use a helper object to perform a task, instead of doing the task itself.

 This allows for code reuse through object composition, instead of inheritance.

 ## Code Example
 */
import UIKit

public protocol MenuViewControllerDelegate: AnyObject {

    func menuViewController(
        _ menuViewController: MenuViewController,
        didSelectItemAt indexPath: IndexPath
    )

}

public class MenuViewController: UIViewController {

    // MARK: - Properties

    private let items = ["Item 1", "Item 2", "Item 3"]

    public weak var delegate: MenuViewControllerDelegate?

    public lazy var tableView: UITableView = {
        let _tableView = UITableView()

        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self)
        )

        return _tableView
    }()

    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {

    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return items.count
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NSStringFromClass(UITableViewCell.self),
            for: indexPath
        )

        cell.textLabel?.text = items[indexPath.row]

        return cell
    }

}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {

    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        delegate?.menuViewController(self, didSelectItemAt: indexPath)
    }

}
