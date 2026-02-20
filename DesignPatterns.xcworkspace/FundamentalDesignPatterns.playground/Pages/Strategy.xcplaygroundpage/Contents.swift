/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)

 # Strategy
 - - - - - - - - - -
 ![Strategy Diagram](Strategy_Diagram.png)

 The strategy pattern defines a family of interchangeable objects.

 This pattern makes apps more flexible and adaptable to changes at runtime, instead of requiring compile-time changes.

 ## Code Example
 */
import UIKit

public protocol MovieRatingStrategy {

    var ratingSystemName: String { get }

    func fetchRating(
        for movieTitle: String,
        success: (_ rating: String, _ review: String) -> Void
    )

}

public class RottenTomatoesClient: MovieRatingStrategy {

    public let ratingSystemName: String = "Rotten Tomatoes"

    public func fetchRating(
        for movieTitle: String,
        success: (_ rating: String, _ review: String) -> Void
    ) {
        let rating = "95%"
        let review = "It rocked!"

        success(rating, review)
    }

}

public class IMDbClient: MovieRatingStrategy {

    public let ratingSystemName: String = "IMDb"

    public func fetchRating(
        for movieTitle: String,
        success: (_ rating: String, _ review: String) -> Void
    ) {
        let rating = "3 / 10"
        let review = """
            It was terrible! The audience was throwing rotten
            tomatoes!
            """

        success(rating, review)
    }

}

public class MovieRatingController: UIViewController {

    // MARK: - Properties

    public var movieRatingClient: MovieRatingStrategy!

    public let movieTitleTextField = UITextField()
    public let ratingServiceNameLabel = UILabel()
    public let ratingLabel = UILabel()
    public let reviewLabel = UILabel()

    // MARK: - View Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        ratingServiceNameLabel.text = movieRatingClient.ratingSystemName
    }

}

// MARK: - Actions

extension MovieRatingController {

    @objc public func searchButtonTapped(_ sender: UIButton) {
        guard
            let movieTitle = movieTitleTextField.text,
            !movieTitle.isEmpty
        else { return }

        movieRatingClient.fetchRating(for: movieTitle) {
            [weak self] rating, review in

            guard let self else { return }

            self.ratingLabel.text = rating
            self.reviewLabel.text = review
        }
    }

}
