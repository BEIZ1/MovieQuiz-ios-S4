import Foundation

protocol StatisticService{
    var totalAccuracy: Double { get }
    var gamesCount: Int {get}
    var bestGame: GameRecord? {get}
    
    func store(correct:Int, total: Int)
}


