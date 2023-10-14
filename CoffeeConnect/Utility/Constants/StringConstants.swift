//
//  StringConstants.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 8.10.2023.
//

import Foundation

struct StringConstants {
    // Giriş Ekranı Metinleri
    enum Login {
        static let emailPlaceholder = NSLocalizedString("Enter your email", comment: "")
        static let passwordPlaceholder = NSLocalizedString("Enter your password", comment: "")
        static let loginButton = NSLocalizedString("Login", comment: "")
        static let registerButton = NSLocalizedString("Register", comment: "")
        static let namePlaceholder = NSLocalizedString("Name", comment: "")
        static let usernamePlaceholder = NSLocalizedString("Username", comment: "")
    }

    // Genel Uygulama Metinleri
    enum General {
        static let enterText = NSLocalizedString("Enter text", comment: "")
        static let ok = NSLocalizedString("OK", comment: "")
        static let error = NSLocalizedString("Error", comment: "")
        static let fillFields = NSLocalizedString("Please fill in all fields", comment: "")
        static let success = NSLocalizedString("Success", comment: "")
        static let registerSuccess = NSLocalizedString("Register Success", comment: "")
        static let appName = "CoffeeConnect"
        static let categories = NSLocalizedString("Categories", comment: "")
    }
    enum HomeView{
        static let topCategories = ["Espresso", "Cappuccino", "Latte"]
        static let bottomCategories = ["Mocha", "Iced Coffee", NSLocalizedString("Filter Coffee", comment: "")]
        static let welcome = NSLocalizedString("Welcome", comment: "")
        static let secialOffer = NSLocalizedString("Special offer", comment: "")
        static let discoverOurExclusive = NSLocalizedString("Discover our exclusive coffee offers now", comment: "")
        static let seeMore = NSLocalizedString("See more ->", comment: "")
        static let specialPrice = NSLocalizedString("Special Prices For You", comment: "")
        static let featuredProduct = NSLocalizedString("Featured Products", comment: "")
        static let viewAll = NSLocalizedString("View all", comment: "")
    }

    // Hata Mesajları
    enum Errors {
        static let unknown = NSLocalizedString("An unknown error occurred.", comment: "")
        static let authenticationFailed = NSLocalizedString("Authentication failed.", comment: "")
        static let imageUploadFailed = NSLocalizedString("An error occurred while uploading the profile image.", comment: "")
        static let imageURLNotFound = NSLocalizedString("Profile image URL not found.", comment: "")
        static let userDocumentNotFound = NSLocalizedString("User document not found.", comment: "")
        static let dataEncodingFailed = NSLocalizedString("Data encoding failed.", comment: "")
        static let dataDecodingFailed = NSLocalizedString("Data decoding failed.", comment: "")
    }
}
