//
//  StringConstants.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 8.10.2023.
//

import Foundation

struct StringConstants {
    struct Login {
        static let emailPlaceholder = NSLocalizedString("Enter your email", comment: "")
        static let passwordPlaceholder = NSLocalizedString("Enter your password", comment: "")
        static let loginButtonTitle = NSLocalizedString("Login", comment: "")
        static let registerButtonTitle = NSLocalizedString("Register", comment: "")
        static let nameTextfieldPlaceHolder = NSLocalizedString("Name", comment: "")
        static let userNameTextfieldPlaceHolder = NSLocalizedString("Username", comment: "")
    }
    struct AppString {
        static let enterText = NSLocalizedString("Enter text", comment: "")
        static let okString = NSLocalizedString("OK", comment: "")
        static let errorString = NSLocalizedString("Error", comment: "")
        static let errorEmptyField = NSLocalizedString("Please fill in all fields", comment: "")
        static let successString = NSLocalizedString("Success", comment: "")
        static let registerSuccessString = NSLocalizedString("Register Success", comment: "")
    }
}
