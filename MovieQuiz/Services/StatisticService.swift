//
//  StaticSetvice.swift
//  MovieQuiz
//
//  Created by Юрченко Артем on 11.10.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double {get}
    var gamesCount: Int {get set}
    var bestGame: GameRecord {get set}
    func store(correct count: Int, total amount: Int)
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: String
    
  public func compareRecord(current: GameRecord, previous: GameRecord) -> GameRecord {
        let currentRecord = GameRecord(correct: current.correct, total: current.total, date: current.date)
        let previousRecord = GameRecord(correct: previous.correct, total: previous.total, date: previous.date)
        if currentRecord.correct > previousRecord.correct {
            return currentRecord
        } else {
            return previousRecord
        }
    }
}

final class StatisticServiceImplementation: StatisticService {
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
          return (Double(bestGame.correct) / Double(bestGame.total)) * 100
        }
    }
    
    
    var gamesCount: Int {
        get {
           return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                      return .init(correct: 0, total: 0, date: Date().dateTimeString)
                  }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let gameRecord = GameRecord(correct: count, total: amount, date: Date().dateTimeString)
        
        if bestGame.correct >= gameRecord.correct {
            userDefaults.set(bestGame.correct, forKey: Keys.bestGame.rawValue)
            userDefaults.set(bestGame.total, forKey: Keys.bestGame.rawValue)
            userDefaults.set(bestGame.date, forKey: bestGame.date)
        } else  {
            print("Невозможно сохранить результат")
        }
    }
    

    
    
}



