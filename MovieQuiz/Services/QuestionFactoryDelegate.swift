import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didFailNextQuestion(with error: Error)
    func didLoadData()
    func didFailData(with error: Error)
}
