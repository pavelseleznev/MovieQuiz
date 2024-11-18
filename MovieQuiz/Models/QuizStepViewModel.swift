//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/1/24.
//

import UIKit

/// View model for state "Question displayed"
struct QuizStepViewModel {
    /// Image with movie poster of type UIImage
    let image: UIImage
    /// Rating movie question
    let question: String
    /// Line with ordinal question number (ex. "1/10")
    let questionNumber: String
}
