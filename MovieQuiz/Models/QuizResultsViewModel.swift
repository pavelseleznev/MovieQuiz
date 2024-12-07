//
//  QuizResultsViewModel.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/1/24.
//

import Foundation

/// View model for state "Game Result"
struct QuizResultsViewModel {
    /// Line with alert's headline
    let title: String
    /// Line with text showing number of correct answers
    let text: String
    /// Text for alert button
    let buttonText: String
}
