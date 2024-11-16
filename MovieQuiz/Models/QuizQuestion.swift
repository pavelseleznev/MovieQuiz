//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/1/24.
//

import Foundation

struct QuizQuestion {
    /// Line containing movie title matching the name of the movie poster in Assets
    let image: String
    /// Line containing movie rating question
    let text: String
    /// Bool value (true, false) containing the correct answer
    let correctAnswer: Bool
}
