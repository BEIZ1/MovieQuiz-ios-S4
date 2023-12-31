import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
      private let questionsAmount: Int = 10
      private lazy var questionFactory: QuestionFactoryProtocol = {
          let factory = QuestionFactory()
          factory.delegate = self
          return factory
      }()
      private var currentQuestion: QuizQuestion?
      private var currentQuestionIndex = 0
      private var correctAnswers = 0
      private var alertPresenter: AlertPresenter?
      private var statisticSetvice: StatisticService?
      
    // MARK: - Private functions
    
    private func customizationUI(){
        view.backgroundColor = UIColor.init(named: "YPBlack")
        
        noButton.setTitle("Нет", for: .normal)
        noButton.setTitleColor(UIColor.init(named: "YPBlack"), for: .normal)
        noButton.backgroundColor = UIColor.init(named: "YPWhite")
        noButton.layer.cornerRadius = 15
        noButton.frame.size = CGSize(width: 157, height: 60)
        
        yesButton.setTitle("Да", for: .normal)
        yesButton.setTitleColor(UIColor.init(named: "YPBlack"), for: .normal)
        yesButton.backgroundColor = UIColor.init(named: "YPWhite")
        yesButton.layer.cornerRadius = 15
        yesButton.frame.size = CGSize(width: 157, height: 60)

        textLabel.text = "Вопрос:"
        textLabel.textColor = UIColor.init(named: "YPWhite")
        textLabel.frame.size = CGSize(width: 72, height: 24)
        
        
        counterLabel.textColor = UIColor.init(named: "YPWhite")
        counterLabel.frame.size = CGSize(width: 72, height: 24)
        questionLabel.textColor = UIColor.init(named: "YPWhite")
        questionLabel.frame.size = CGSize(width: 72, height: 24)
        
        imageView.layer.cornerRadius = 20
    }
    private func show(quiz result: QuizResultsViewModel) {
          
      }
      
      private func convert(model: QuizQuestion) -> QuizStepViewModel {
          let questionStep = QuizStepViewModel(
              image: UIImage(named: model.image) ?? UIImage(),
              question: model.text,
              questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
          return questionStep
      }
      
      private func show(quiz step: QuizStepViewModel) {
          imageView.image = step.image
          questionLabel.text = step.question
          counterLabel.text = step.questionNumber
      }
      
      private func showAnswerResult(isCorrect: Bool) {
          if isCorrect { // 1
              correctAnswers += 1 // 2
          }
          
          imageView.layer.masksToBounds = true
          imageView.layer.borderWidth = 8
          imageView.layer.cornerRadius = 20
          imageView.layer.borderColor = isCorrect ? UIColor.init(named: "YPGreen")?.cgColor : UIColor.init(named: "YPRed")?.cgColor
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
              guard let self = self else { return }
              self.showNextQuestionOrResults()
          }
      }
      
      private func showNextQuestionOrResults() {
          
          if currentQuestionIndex == questionsAmount - 1 {
              showFinalResults()
              imageView.layer.borderColor = UIColor.clear.cgColor
          } else {
              currentQuestionIndex += 1
              self.questionFactory.requestNextQuestion()
              imageView.layer.borderColor = UIColor.clear.cgColor
          }
      }
      
      private func showFinalResults(){
          statisticSetvice?.store(correct: correctAnswers, total: questionsAmount)
          let alertModel = AlertModel(
              title: "Игра окончена!",
              message: makeResultMessage(),
              buttonText: "OK",
              buttonAction: {[weak self] in
                  self?.currentQuestionIndex = 0
                  self?.correctAnswers = 0
                  self?.questionFactory.requestNextQuestion()
              }
          )
          alertPresenter?.show(alertModel: alertModel)
      }
      
      private func makeResultMessage() -> String {
          guard let statisticService = statisticSetvice, let bestGame = statisticSetvice?.bestGame else{
              assertionFailure("Error")
              return ""
          }
          let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
          let totalPlaysCount = "Количество сыгранных квизов:\(statisticService.gamesCount)"
          let currentGameResult = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
          let bestGameInfo = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" +
          " (\(bestGame.date.dateTimeString))"
          let averageAccuracy = "Средняя точность: \(accuracy)%"
          let resultMessage = [
              currentGameResult, totalPlaysCount, bestGameInfo, averageAccuracy
          ].joined(separator: "\n")
          return resultMessage
      }


      func didReceiveNextQuestion(question: QuizQuestion?) {
          guard let question = question else {
              return
          }

          currentQuestion = question
          let viewModel = convert(model: question)
          DispatchQueue.main.async { [weak self] in
              self?.show(quiz: viewModel)
          }
      }
    
    // MARK: - Lifecycle
    
    override final func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
        alertPresenter = AlertPresenterImpl(viewController:self)
        statisticSetvice = StatisticServiceImplementation()
        customizationUI()

    }
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBAction private func yesButtonPressed(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonPressed(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
}
    

    

