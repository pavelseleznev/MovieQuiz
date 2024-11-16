//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/5/24.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    /// Variable delegate adds support for present() method in showAlert method
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    /// Private method which shows round quiz results. Accepts AlertModel and returns nil
    func showAlert(quiz alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: alertModel.completion
        )
        
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
