import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {

    func showAnswer(isCorrect: Bool)
    
    func showQuestion(quiz step: QuizStepViewModel)
    
    func showNextQuestion(_ viewModel: QuizStepViewModel)
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func showLaunchScreen()
    
    func hideLaunchScreen()
    
    func showAlert(_ alertData: AlertModel)
}
