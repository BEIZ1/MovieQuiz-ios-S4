import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    private var presenter: MovieQuizPresenter?
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var launchScreen: UIImageView!

    @IBAction private func answerButtonClicked(_ sender: UIButton) {
        let isYesClicked = sender == yesButton
        presenter?.answerButtonClicked(isYesClicked)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    func showNextQuestion(_ viewModel: QuizStepViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showQuestion(quiz: viewModel)
            self?.hideLaunchScreen()
            self?.hideLoadingIndicator()
        }
    }

    func showAnswer(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    func showQuestion(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showLaunchScreen() {
        launchScreen.isHidden = false
    }
    
    func hideLaunchScreen() {
        launchScreen.isHidden = true
    }
    
    func showAlert(_ alertData: AlertModel) {
        let alert = UIAlertController(title: alertData.title, message: alertData.message, preferredStyle: .alert)
        func handler(_: UIAlertAction) {
            alertData.completion()
        }
        let action = UIAlertAction(title: alertData.buttonText, style: .default, handler: handler)
        alert.addAction(action)
        alert.view.accessibilityIdentifier = "Alert"
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
