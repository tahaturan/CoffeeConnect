//
//  ShoppingCartModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct ShoppingCartModel: Codable {
    let userID: String
    var items: [ShoppingCartItemModel]
}
