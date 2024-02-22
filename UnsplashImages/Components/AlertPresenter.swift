//
//  AlertPresenter.swift
//  UnsplashImages
//
//  Created by Dmitry Dmitry on 2.2.2024.
//

import UIKit

struct AlertModel {
    var title: String
    var message: String
}

final class AlertPresenter {
    static func showAlert(from viewController: UIViewController, with model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
