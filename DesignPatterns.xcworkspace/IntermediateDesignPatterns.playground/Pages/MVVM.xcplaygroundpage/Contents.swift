/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)

 # Model-View-ViewModel (MVVM)
 - - - - - - - - - -
 ![MVVM Diagram](MVVM_Diagram.png)

 The Model-View-ViewModel (MVVM) pattern separates objects into three types: models, views and view-models.

 - **Models** hold onto application data. They are usually structs or simple classes.
 - **View-models** convert models into a format that views can use.
 - **Views** display visual elements and controls on screen. They are usually subclasses of `UIView`.

 ## Code Example
 */
import PlaygroundSupport
import UIKit

// MARK: - Model

class Pet {
    public enum Rarity {
        case common
        case uncommon
        case rare
        case veryRare
    }

    public let name: String
    public let birthday: Date
    public let rarity: Rarity
    public let image: UIImage

    public init(name: String, birthday: Date, rarity: Rarity, image: UIImage) {
        self.name = name
        self.birthday = birthday
        self.rarity = rarity
        self.image = image
    }
}

// MARK: - ViewModel

class PetViewModel {
    private let pet: Pet
    private let calendar = Calendar(identifier: .gregorian)

    public var name: String {
        return pet.name
    }

    public var image: UIImage {
        return pet.image
    }

    public var ageText: String {
        let today = calendar.startOfDay(for: .now)
        let birthday = calendar.startOfDay(for: pet.birthday)
        let components = calendar.dateComponents(
            [.year],
            from: birthday,
            to: today
        )
        let age = components.year!

        return "\(age) years old"
    }

    public var adoptionFeeText: String {
        switch pet.rarity {
        case .common: "$50.00"
        case .uncommon: "$75.00"
        case .rare: "$150.00"
        case .veryRare: "$500.00"
        }
    }

    public init(pet: Pet) {
        self.pet = pet
    }
}

extension PetViewModel {
    public func configure(_ view: PetView) {
        view.nameLabel.text = viewModel.name
        view.imageView.image = viewModel.image
        view.ageLabel.text = viewModel.ageText
        view.adoptionFeeLabel.text = viewModel.adoptionFeeText
    }
}

// MARK: - View

class PetView: UIView {
    public let imageView: UIImageView = {
        let _imageView = UIImageView()

        _imageView.translatesAutoresizingMaskIntoConstraints = false
        _imageView.contentMode = .scaleAspectFit

        return _imageView
    }()

    public let nameLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    public let ageLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    public let adoptionFeeLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 420)
    }

    private func setupViews() {
        backgroundColor = .systemBackground

        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            ageLabel,
            adoptionFeeLabel,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing

        addSubview(imageView)
        addSubview(stackView)

        // imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            imageView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])

        // stackView
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 8
            ),
            stackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -16
            ),
        ])
    }
}

// MARK: - Example

let birthday = Date(timeIntervalSinceNow: (-6 * 86400 * 366))
let image = UIImage(named: "stuart")!
let model = Pet(
    name: "Stuart",
    birthday: birthday,
    rarity: .veryRare,
    image: image
)

let viewModel = PetViewModel(pet: model)

let view = PetView()
viewModel.configure(view)

PlaygroundPage.current.liveView = view
