import Foundation
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showAnswer(isCorrect: Bool) {
        print("showAnswer")
    }
    
    func showQuestion(quiz step: MovieQuiz.QuizStepViewModel) {
        print("showQuestion")
    }
    
    func showNextQuestion(_ viewModel: MovieQuiz.QuizStepViewModel) {
        print("showNextQuestion")
    }
    
    func showLoadingIndicator() {
        print("showLoadingIndicator")
    }
    
    func hideLoadingIndicator() {
        print("hideLoadingIndicator")
    }
    
    func showLaunchScreen() {
        print("showLaunchScreen")
    }
    
    func hideLaunchScreen() {
        print("hideLaunchScreen")
    }
    
    func showAlert(_ alertData: MovieQuiz.AlertModel) {
        print("showAlert")
    }
}
