//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/1/24.
//

import Foundation

/// Question struct for displaying questions during the quiz
struct QuizQuestion {
    /// Data containing the movie poster loaded from IMDB database
    let image: Data
    /// Line containing movie rating question
    let text: String
    /// Bool value (true, false) containing the correct answer
    let correctAnswer: Bool
}
