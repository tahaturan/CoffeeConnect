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
        static let addToBasket = NSLocalizedString("Add To Basket", comment: "")
        static let deletedProduct = NSLocalizedString("Deleted Product", comment: "")
        static let subTotal = NSLocalizedString("Subtotal", comment: "")
        static let delivery = NSLocalizedString("Delivery", comment: "")
        static let total = NSLocalizedString("Total", comment: "")
        static let order = NSLocalizedString("Order", comment: "")
        static let search = NSLocalizedString("Search", comment: "")
        static let newPost = NSLocalizedString("New Post", comment: "")
        static let sharingPost = NSLocalizedString("Post successfully shared!", comment: "")
        static let signOut = NSLocalizedString("SignOut", comment: "")
        static let coffeeCollections = NSLocalizedString("My cofee collections", comment: "")
        static let coffee = NSLocalizedString("Coffee", comment: "")
        static let discoverText = NSLocalizedString("Discover coffee lovers and share your favorite coffee", comment: "")
        static let getStarted = NSLocalizedString("Get Started", comment: "")
    }
    enum HomeView{
        static let topCategories = ["Espresso", "Cappuccino", "Latte"]
        static let bottomCategories = ["Mocha", "Soğuk Kahve", NSLocalizedString("Filtre Kahve", comment: "")]
        static let welcome = NSLocalizedString("Welcome", comment: "")
        static let secialOffer = NSLocalizedString("Special offer", comment: "")
        static let discoverOurExclusive = NSLocalizedString("Discover our exclusive coffee offers now", comment: "")
        static let seeMore = NSLocalizedString("See more ->", comment: "")
        static let specialPrice = NSLocalizedString("Special Prices For You", comment: "")
        static let featuredProduct = NSLocalizedString("Featured Products", comment: "")
        static let viewAll = NSLocalizedString("View all", comment: "")
        static let productAddedToCart = NSLocalizedString("Product Added To Cart", comment: "")
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
        static let dataFetchingFailed = NSLocalizedString("Data Fetching Failed", comment: "")
        static let imageOrDescMissing = NSLocalizedString("Image or description is missing!", comment: "")
        static let postSharingFailed = NSLocalizedString("Failed to share the post!", comment: "")
    }
    enum MainTabbar {
        static let home = NSLocalizedString("Home", comment: "")
        static let search = NSLocalizedString("Search", comment: "")
        static let discover = NSLocalizedString("Discover", comment: "")
        static let profile = NSLocalizedString("Profile", comment: "")
        static let post = NSLocalizedString("Post", comment: "")
    }
    enum WishlistViewController {
        static let wishList = NSLocalizedString("Wish List", comment: "")
    }
    enum BasketViewController {
        static let basket = NSLocalizedString("Basket", comment: "")
    }
    
    struct CellIDs {
        static let homeViewCollectionViewCellId = "featuredCollectionViewCellID"
        static let wishListCellID = "WishlistCellIdentifier"
        static let basketListCellID = "BasketCellIdentifier"
        static let discoverCellID = "DiscoverCellIdentifier"
    }
    enum DateFormat {
        static let dayAgo = NSLocalizedString("d ago", comment: "")
        static let hourAgo = NSLocalizedString("h ago", comment: "")
        static let minuteAgo = NSLocalizedString("min ago", comment: "")
        static let secontAgo = NSLocalizedString("s ago", comment: "")
        static let now = NSLocalizedString("now", comment: "")
    }
}
