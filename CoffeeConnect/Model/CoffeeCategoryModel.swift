//
//  CoffeeCategoryModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct CoffeeCategoryModel: Codable {
    let categoryID: String
    var coffeeIDs: [String]     // Kategorideki kahvelerin ID'leri
}
