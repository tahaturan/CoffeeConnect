//
//  UserModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 9.10.2023.
//

import Foundation


struct UserModel {
    let userID: String
    var name: String
    var username: String
    var email: String
    var balance: Double
    var profileImageURL: String
    var coverImageURL: String
    var posts: [String]
    var shoppingCartID: String
    var wishlist: [String]
    
    init(data: [String: Any]) {
        self.userID = data["userID"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.balance = data["balance"] as? Double ?? 0.0
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        self.coverImageURL = data["coverImageURL"] as? String ?? ""
        self.posts = data["posts"] as? [String] ?? []
        self.shoppingCartID = data["shoppingCartID"] as? String ?? ""
        self.wishlist = data["wishlist"] as? [String] ?? []
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "userID": userID,
            "name": name,
            "username": username,
            "email": email,
            "balance": balance,
            "profileImageURL": profileImageURL,
            "coverImageURL": coverImageURL,
            "posts": posts,
            "shoppingCartID": shoppingCartID,
            "wishlist": wishlist
        ]
    }
}
