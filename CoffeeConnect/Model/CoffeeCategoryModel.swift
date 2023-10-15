//
//  CoffeeCategoryModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

    struct CoffeeCategoryModel: Codable {
        let categoryID: String
        let categoryName: String
        var coffeeIDs: [String]     // Kategorideki kahvelerin ID'leri
        
        // CoffeeCategoryModel objesini Dictionary'e dönüştürme
        func toDictionary() throws -> [String: Any] {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw AppError.dataEncodingFailed
            }
            return dictionary
        }
        
        // JSON Data'dan CoffeeCategoryModel objesine dönüştürme
        static func fromDictionary(jsonData: Data) throws -> CoffeeCategoryModel {
            do {
                return try JSONDecoder().decode(CoffeeCategoryModel.self, from: jsonData)
            } catch {
                throw AppError.dataDecodingFailed
            }
        }
    }

