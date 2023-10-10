//
//  UserModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct UserModel: Codable {
    let userID: String
    var name: String
    var username: String
    var email: String
    var balance: Double
    var profileImageURL: String
    var postIDs: [String]       // Kullanıcının paylaştığı gönderi ID'leri
    var shoppingCart: ShoppingCartModel
    var wishlist: [WishlistItemModel]
}
