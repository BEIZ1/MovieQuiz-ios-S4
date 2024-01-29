import Foundation

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {
        <#code#>
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        <#code#>
    }
    
    func showNetworkError(message: String) {
        <#code#>
    }
    
    func updateButtonStates(buttonsEnabled: Bool) {
        
    }
    
    func showFinalResults() {
        
    }
    
    func showActivityIndicator() {
    
    }
    
    func changeBetweenQuestions() {
        
    }
    
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func highLightTrueAnswer(isCorrect: Bool) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let mock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: mock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
         XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}