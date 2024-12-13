//
//  MovieQuizViewControllerMock.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 12/12/24.
//

import Foundation

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {}
    func showGameResultAlert(quiz result: MovieQuiz.QuizResultsViewModel) {}
    
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    
    func showNetworkError(message: String) {}
    func showImageError(message: String) {}
    
    func changeStateButton(isEnabled: Bool) {}
}
