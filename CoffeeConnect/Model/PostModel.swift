//
//  PostModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct PostModel: Codable {
    let postID: String
    let userID: String          
    var imageURL: String
    var desctiption: String
    var creationDate: Date
    var commentIDs: [String]
    
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw AppError.dataEncodingFailed
        }
        return dictionary
    }
    
    static func fromDictionary(jsonData: Data) throws -> PostModel {
         do {
             return try JSONDecoder().decode(PostModel.self, from: jsonData)
         } catch {
             throw AppError.dataDecodingFailed
         }
     }
}
