//
//  UserModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

struct UserModel: Codable {
    let userID: String
    var name: String
    var username: String
    var email: String
    var balance: Double
    var profileImageURL: String
    var postIDs: [String]       // Kullanıcının paylaştığı gönderi ID'leri
    var shoppingCart: ShoppingCartModel
    var wishlist: [WishlistItemModel]
    
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw AppError.dataEncodingFailed
        }
        return dictionary
    }
    
    static func fromDictionary(jsonData: Data) throws -> UserModel {
         do {
             return try JSONDecoder().decode(UserModel.self, from: jsonData)
         } catch {
             throw AppError.dataDecodingFailed
         }
     }
   
}

class UserManager {
    static let shared = UserManager() //Singleton instance(nesnesi)
    var currentUser: UserModel?
    
    private init() {}
    
    //Kullanici bilgilerini guncelleme
    func updateUser(_ user: UserModel)  {
        self.currentUser = user
    }
    //Kullanici Bilgilerini silme
    func clearUser() {
        self.currentUser = nil
    }
}
