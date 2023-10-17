//
//  ShoppingCartModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct ShoppingCartModel: Codable, Equatable {
    let userID: String
    var items: [ShoppingCartItemModel]
    
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw AppError.dataEncodingFailed
        }
        return dictionary
    }
    
    static func fromDictionary(jsonData: Data) throws -> ShoppingCartModel {
         do {
             return try JSONDecoder().decode(ShoppingCartModel.self, from: jsonData)
         } catch {
             throw AppError.dataDecodingFailed
         }
     }
}
