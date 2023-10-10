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
}
