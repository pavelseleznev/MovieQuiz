//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/14/24.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get set }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}

/// Struct model game result
struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    /// Method of comparing the number of correct answers
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
