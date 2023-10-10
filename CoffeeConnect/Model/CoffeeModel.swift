//
//  CoffeeModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct CoffeeModel: Codable {
    let coffeeID: String
    var name: String
    var description: String
    var price: Double
    var imageURL: String
    var categoryID: String      // Kahvenin kategorisinin ID'si
}
