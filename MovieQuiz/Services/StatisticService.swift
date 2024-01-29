import Foundation

class StatisticService: StatisticServiceProtocol {
    private let userDefaults = UserDefaults.standard
    
    private enum KeysToStore: String {
        case correct, total, bestGame, gamesCount
    }
    
    private var total: Int {
        get {
            userDefaults.integer(forKey: KeysToStore.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: KeysToStore.total.rawValue)
        }
    }
    
    private var correct: Int {
        get {
            userDefaults.integer(forKey: KeysToStore.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: KeysToStore.correct.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: KeysToStore.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: KeysToStore.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard
                let data = userDefaults.data(forKey: KeysToStore.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            else {
                return GameRecord(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            userDefaults.set(data, forKey: KeysToStore.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            return Double(correct) / Double(total) * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        if (currentGame.isBetterThan(anotherGame: bestGame)) {
            bestGame = currentGame
        }
        gamesCount += 1
        total = total + amount
        correct = correct + count
    }
}
