//
//  AppData.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 15.10.2023.
//

import Foundation
class AppData {
    static let shared = AppData()
    private init() {}
    
    var categoriesWithCoffee: [(CoffeeCategoryModel, [CoffeeModel])]?
}
