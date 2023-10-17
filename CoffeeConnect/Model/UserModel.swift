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
    func updateWishList(coffee: CoffeeModel, completion: @escaping (Bool) -> Void) {
        guard var user = UserManager.shared.currentUser else {
            completion(false)
            return
        }
        let wishlistItem = WishlistItemModel(coffeeID: coffee.coffeeID, addedDate: Date())
        if let index = user.wishlist.firstIndex(where: {$0.coffeeID == coffee.coffeeID}) {
            user.wishlist.remove(at: index)
        } else {
            user.wishlist.append(wishlistItem)
        }
        updateUser(user)
        
        FirebaseService.shared.toggleWishList(userID: user.userID, WishListItem: wishlistItem) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(let error):
                print("Error updating wishlist in Firestore: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

}
