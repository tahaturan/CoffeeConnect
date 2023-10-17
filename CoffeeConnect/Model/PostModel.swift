//
//  PostModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct PostModel: Codable {
    let postID: String
    let userID: String          // Gönderiyi paylaşan kullanıcının ID'si
    var imageURL: String
    var creationDate: Date      // Gönderinin oluşturulma tarihi
    var commentIDs: [String]    // Bu gönderiye yapılan yorumların ID'leri
    
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
