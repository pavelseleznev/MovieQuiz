//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/5/24.
//

import UIKit

/// Alert struct for displaying alert at the end of the quiz
struct AlertModel {
    /// Headline of alert
    var title: String
    /// Text of alert's message
    var message: String
    /// Text of alert's button
    var buttonText: String
    /// Closure without parameters for action button alert
    let completion: ((UIAlertAction) -> Void)?
}
