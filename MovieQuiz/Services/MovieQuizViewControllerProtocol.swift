//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 12/5/24.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showGameResultAlert(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    func showImageError(message: String)
    
    func changeStateButton(isEnabled: Bool)
}
