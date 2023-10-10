//
//  AppExtensions.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation
import UIKit

//MARK: - AlertController
extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String = StringConstants.AppString.okString, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = AppColors.ambassadorBlue.color
        alertController.view.layer.cornerRadius = AppStyle.defaultCornerRadius
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

