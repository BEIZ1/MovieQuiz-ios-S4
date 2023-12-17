import Foundation
struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
struct GameRecord: Codable{
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable{
    private var accuracy:Double{
        guard total != 0 else {
            return 0
        }
        return Double(correct / total)
    }
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
}
