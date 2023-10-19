//
//  AppStyle.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 9.10.2023.
//

import Foundation
import UIKit
import UIKit

enum AppStyleConstants {
    // Genel Uygulama Stil Sabitleri
    static let iconSize: CGFloat = 24
    static let padding: CGFloat = 10
    static let cornerRadius: CGFloat = 15
    static let profileImageSize: CGFloat = 110
    static let categoryButtonHeight: CGFloat = 50
    static let homeUserImageSize: CGFloat = 50
    
    // Uygulamada Kullanılan İkon Adları
    enum Icons {
        static let loginLogo = "loginLogo"
        static let email = "envelope"
        static let lock = "lock"
        static let eye = "eye"
        static let eyeSlash = "eye.slash"
        static let user = "person"
        static let defaultAvatar = "defaultProfileImage"
        static let userCard = "person.text.rectangle"
        static let cart = "cart.fill"
        static let heart = "heart.fill"
        static let home = "house"
        static let search = "magnifyingglass"
        static let discover = "dot.radiowaves.left.and.right"
        static let trash = "trash.fill"
        static let plus = "plus.app.fill"
        static let minus = "minus.square.fill"
    }
}

