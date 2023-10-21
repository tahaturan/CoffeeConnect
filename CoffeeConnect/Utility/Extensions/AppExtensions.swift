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
    func showAlert(title: String, message: String, buttonTitle: String = StringConstants.General.ok, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = AppColors.ambassadorBlue.color
        alertController.view.layer.cornerRadius = AppStyleConstants.cornerRadius
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfMonth], from: self, to: now)

        if let day = components.day, day >= 2 {
            return "\(day)\(StringConstants.DateFormat.dayAgo)"
        }
        if let day = components.day, day >= 1 {
            return "1\(StringConstants.DateFormat.dayAgo)"
        }
        if let hour = components.hour, hour >= 1 {
            return "\(hour)\(StringConstants.DateFormat.hourAgo)"
        }
        if let minute = components.minute, minute >= 1 {
            return "\(minute)\(StringConstants.DateFormat.minuteAgo)"
        }
        if let second = components.second, second >= 3 {
            return "\(second)\(StringConstants.DateFormat.secontAgo)"
        }
        return StringConstants.DateFormat.now
    }
}

