//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/4/24.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailToLoadData(with errorMessage: String)
    func didFailToLoadImage(with error: Error)
}
