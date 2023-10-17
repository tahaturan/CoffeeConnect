//
//  ShoppingCartItemModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct ShoppingCartItemModel: Codable, Equatable {
    let coffeeID: String
    var quantity: Int
    
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw AppError.dataEncodingFailed
        }
        return dictionary
    }
    
    static func fromDictionary(jsonData: Data) throws -> ShoppingCartItemModel {
         do {
             return try JSONDecoder().decode(ShoppingCartItemModel.self, from: jsonData)
         } catch {
             throw AppError.dataDecodingFailed
         }
     }
}
