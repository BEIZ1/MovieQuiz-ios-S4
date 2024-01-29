import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol
    
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        loadMovies()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let questionModel = convert(model: question)
        viewController?.showNextQuestion(questionModel)
    }
    
    func didLoadData() {
        loadQuestion()
    }
    
    func didFailNextQuestion(with error: Error) {
        showNetworkErrorModal(message: error.localizedDescription, handler: loadQuestion)
    }
    
    func didFailData(with error: Error) {
        showNetworkErrorModal(message: error.localizedDescription, handler: loadMovies)
    }
    
    func answerButtonClicked(_ isYesClicked: Bool) {
        let isCorrect = currentQuestion?.correctAnswer == isYesClicked
        viewController?.showAnswer(isCorrect: isCorrect)
        correctAnswers = correctAnswers + (isCorrect ? 1 : 0)
        showNextQuestionOrResults()
    }
    
    private func showNextQuestionOrResults() {
        if isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            showFinishGameModal()
        } else {
            switchToNextQuestion()
            loadQuestion()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        loadQuestion()
    }
    
    private func loadMovies() {
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    private func loadQuestion() -> Void {
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    private func showNetworkErrorModal(message: String, handler: @escaping (() -> Void)) {
        let alertData = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: handler
        )
        viewController?.showAlert(alertData)
    }
    
    private func showFinishGameModal() {
        viewController?.showLaunchScreen()
        let alertData = AlertModel(
            title: "Этот раунд окончен!",
            message: generateFinisMessage(),
            buttonText: "Сыграть ещё раз",
            completion: resetGame
        )
        viewController?.showAlert(alertData)
    }
    
    private func generateFinisMessage() -> String {
        let bestGame = statisticService.bestGame
        let message =
        """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        "Количество сыгранных квизов: \(statisticService.gamesCount)
        "Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString)
        "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        return message
    }
}
