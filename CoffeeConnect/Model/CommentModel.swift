//
//  CommentModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct CommentModel: Codable {
    let commentID: String
    let userID: String          // Yorumu yapan kullanıcının ID'si
    var text: String
    var creationDate: Date      // Yorumun oluşturulma tarihi
}
