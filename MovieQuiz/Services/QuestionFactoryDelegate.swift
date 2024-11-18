//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/4/24.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
