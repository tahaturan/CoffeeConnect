//
//  WishlistItemModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct WishlistItemModel: Codable, Equatable {
    let coffeeID: String
    var addedDate: Date
    
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw AppError.dataEncodingFailed
        }
        return dictionary
    }
    
    static func fromDictionary(jsonData: Data) throws -> WishlistItemModel {
         do {
             return try JSONDecoder().decode(WishlistItemModel.self, from: jsonData)
         } catch {
             throw AppError.dataDecodingFailed
         }
     }
}
