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
    
    // CoffeeModel objesini Dictionary'e dönüştürme
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw AppError.dataEncodingFailed
        }
        return dictionary
    }
    
    // JSON Data'dan CoffeeModel objesine dönüştürme
    static func fromDictionary(jsonData: Data) throws -> CoffeeModel {
        do {
            return try JSONDecoder().decode(CoffeeModel.self, from: jsonData)
        } catch {
            throw AppError.dataDecodingFailed
        }
    }
}
