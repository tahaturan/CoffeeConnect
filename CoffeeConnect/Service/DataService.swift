//
//  DataService.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class DataService {
    // Singleton pattern ile sadece bir örnek oluşturulmasını sağlıyoruz.
    static let shared = DataService()
    private init() {}

    func fetchAllCategoriesWithCoffees(completion: @escaping (Result<[(CoffeeCategoryModel, [CoffeeModel])], Error>) -> Void) {
        var cetegoriesWithCoffees: [(CoffeeCategoryModel, [CoffeeModel])] = []

        // Firestore dan tum kategorileri cekme
        let dbRef = Firestore.firestore().collection(FirebaseConstants.coffeeCategories)
        dbRef.getDocuments { categoryQuerySnapshot, error in
            guard let categoryDocuments = categoryQuerySnapshot?.documents else {
                completion(.failure(AppError.dataFetchingFailed))
                return
            }

            let group = DispatchGroup()

            for categoryDocument in categoryDocuments {
                let categoryData = categoryDocument.data()

                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: categoryData)
                    let category = try CoffeeCategoryModel.fromDictionary(jsonData: jsonData)

                    var coffees: [CoffeeModel] = []

                    for coffeeID in category.coffeeIDs {
                        group.enter()
                        Firestore.firestore().collection(FirebaseConstants.coffees).document(coffeeID).getDocument { coffeeDocument, error in
                            guard let coffeeData = coffeeDocument?.data() else {
                                group.leave()
                                return
                            }
                            do {
                                let coffeeJsonData = try JSONSerialization.data(withJSONObject: coffeeData)
                                let coffee = try CoffeeModel.fromDictionary(jsonData: coffeeJsonData)
                                coffees.append(coffee)
                            } catch {
                                print("Error decoding coffe data: \(error)")
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        cetegoriesWithCoffees.append((category, coffees))
                    }
                } catch {
                    print("Error decoding category data: \(error)")
                }
            }
            group.notify(queue: .main) {
                completion(.success(cetegoriesWithCoffees))
            }
        }
    }

    func updateWishList(userID: String, WishListItem: WishlistItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(userID)

        // Önce kullanıcının mevcut istek listesi
        dbRef.getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                var wishlist = data[FirebaseConstants.wishList] as? [[String: Any]] ?? []

                // Eğer bu kahve zaten listeye eklenmişse
                if let index = wishlist.firstIndex(where: { ($0["coffeeID"] as? String) == WishListItem.coffeeID }) {
                    wishlist.remove(at: index)
                } else {
                    // Eğer kahve listeye eklenmemişse
                    do {
                        let wishListItemDict = try WishListItem.toDictionary()
                        wishlist.append(wishListItemDict)
                    } catch {
                        completion(.failure(AppError.dataEncodingFailed))
                        return
                    }
                }
                // Güncellenmiş listeyi geri yükle
                dbRef.updateData([FirebaseConstants.wishList: wishlist]) { error in
                    if let error = error {
                        completion(.failure(AppError.custom(error.localizedDescription)))
                    } else {
                        completion(.success(()))
                    }
                }
            } else {
                completion(.failure(AppError.custom(error?.localizedDescription ?? "Unknown error.")))
            }
        }
    }

    func addToBasket(coffeeID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(AppError.unknown))
            return
        }

        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(userID)

        dbRef.getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                if let shoppingCartData = data[FirebaseConstants.shoppingCart] as? [String: Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: shoppingCartData, options: [])
                        var shoppingCart = try ShoppingCartModel.fromDictionary(jsonData: jsonData)

                        if let index = shoppingCart.items.firstIndex(where: { $0.coffeeID == coffeeID }) {
                            shoppingCart.items[index].quantity += 1
                        } else {
                            let newItem = ShoppingCartItemModel(coffeeID: coffeeID, quantity: 1)
                            shoppingCart.items.append(newItem)
                        }

                        let updatedCartDict = try shoppingCart.toDictionary()
                        dbRef.updateData([FirebaseConstants.shoppingCart: updatedCartDict]) { error in
                            if let error = error {
                                completion(.failure(AppError.custom(error.localizedDescription)))
                            } else {
                                completion(.success(()))
                            }
                        }
                    } catch {
                        print("Error decoding shopping cart: \(error)")
                        completion(.failure(AppError.dataEncodingFailed))
                    }
                } else {
                    completion(.failure(AppError.custom("Shopping cart data is not available.")))
                }
            } else {
                completion(.failure(AppError.custom(error?.localizedDescription ?? "Unknown error.")))
            }
        }
    }

    func listenToUserWishlist(userID: String, completion: @escaping (Result<[WishlistItemModel], Error>) -> Void) {
        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(userID)

        dbRef.addSnapshotListener { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let document = document, document.exists, let data = document.data() {
                do {
                    if let wishlistData = data[FirebaseConstants.wishList] as? [[String: Any]] {
                        let wishlistItems = try wishlistData.map { itemData -> WishlistItemModel in
                            let jsonData = try JSONSerialization.data(withJSONObject: itemData, options: [])
                            return try JSONDecoder().decode(WishlistItemModel.self, from: jsonData)
                        }
                        completion(.success(wishlistItems))
                    } else {
                        completion(.failure(AppError.custom("Wishlist data is not available.")))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    func listenToUserShoppingCart(userID: String, completion: @escaping (Result<ShoppingCartModel, Error>) -> Void) {
        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(userID)

        dbRef.addSnapshotListener { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let document = document, document.exists, let data = document.data() {
                do {
                    if let shoppingCartData = data[FirebaseConstants.shoppingCart] as? [String: Any] {
                        let jsonData = try JSONSerialization.data(withJSONObject: shoppingCartData, options: [])
                        let shoppingCart = try JSONDecoder().decode(ShoppingCartModel.self, from: jsonData)
                        completion(.success(shoppingCart))
                    } else {
                        completion(.failure(AppError.custom("Shopping cart data is not available.")))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    func increaseCoffeeQuantityInBasket(userID: String, coffeeID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(userID)

        dbRef.getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                if let shoppingCartData = data[FirebaseConstants.shoppingCart] as? [String: Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: shoppingCartData, options: [])
                        var shoppingCart = try ShoppingCartModel.fromDictionary(jsonData: jsonData)

                        if let index = shoppingCart.items.firstIndex(where: { $0.coffeeID == coffeeID }) {
                            shoppingCart.items[index].quantity += 1
                        } else {
                            let newItem = ShoppingCartItemModel(coffeeID: coffeeID, quantity: 1)
                            shoppingCart.items.append(newItem)
                        }

                        let updatedCartDict = try shoppingCart.toDictionary()
                        dbRef.updateData([FirebaseConstants.shoppingCart: updatedCartDict]) { error in
                            if let error = error {
                                completion(.failure(AppError.custom(error.localizedDescription)))
                            } else {
                                completion(.success(()))
                            }
                        }
                    } catch {
                        print("Error decoding shopping cart: \(error)")
                        completion(.failure(AppError.dataEncodingFailed))
                    }
                } else {
                    completion(.failure(AppError.custom("Shopping cart data is not available.")))
                }
            } else {
                completion(.failure(AppError.custom(error?.localizedDescription ?? "Unknown error.")))
            }
        }
    }

    func decreaseCoffeeQuantityInBasket(userID: String, coffeeID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(userID)

        dbRef.getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                if let shoppingCartData = data[FirebaseConstants.shoppingCart] as? [String: Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: shoppingCartData, options: [])
                        var shoppingCart = try ShoppingCartModel.fromDictionary(jsonData: jsonData)

                        if let index = shoppingCart.items.firstIndex(where: { $0.coffeeID == coffeeID }) {
                            shoppingCart.items[index].quantity = max(shoppingCart.items[index].quantity - 1, 0)
                        }

                        let updatedCartDict = try shoppingCart.toDictionary()
                        dbRef.updateData([FirebaseConstants.shoppingCart: updatedCartDict]) { error in
                            if let error = error {
                                completion(.failure(AppError.custom(error.localizedDescription)))
                            } else {
                                completion(.success(()))
                            }
                        }
                    } catch {
                        print("Error decoding shopping cart: \(error)")
                        completion(.failure(AppError.dataEncodingFailed))
                    }
                } else {
                    completion(.failure(AppError.custom("Shopping cart data is not available.")))
                }
            } else {
                completion(.failure(AppError.custom(error?.localizedDescription ?? "Unknown error.")))
            }
        }
    }

    func removeCoffeeFromBasket(userID: String, coffeeID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(userID)

        dbRef.getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                if let shoppingCartData = data[FirebaseConstants.shoppingCart] as? [String: Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: shoppingCartData, options: [])
                        var shoppingCart = try ShoppingCartModel.fromDictionary(jsonData: jsonData)

                        if let index = shoppingCart.items.firstIndex(where: { $0.coffeeID == coffeeID }) {
                            shoppingCart.items.remove(at: index)
                        }

                        let updatedCartDict = try shoppingCart.toDictionary()
                        dbRef.updateData([FirebaseConstants.shoppingCart: updatedCartDict]) { error in
                            if let error = error {
                                completion(.failure(AppError.custom(error.localizedDescription)))
                            } else {
                                completion(.success(()))
                            }
                        }
                    } catch {
                        print("Error decoding shopping cart: \(error)")
                        completion(.failure(AppError.dataEncodingFailed))
                    }
                } else {
                    completion(.failure(AppError.custom("Shopping cart data is not available.")))
                }
            } else {
                completion(.failure(AppError.custom(error?.localizedDescription ?? "Unknown error.")))
            }
        }
    }

    func listenToUserPosts(userID: String, completion: @escaping (Result<[PostModel], Error>) -> Void) {
        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(userID)

        dbRef.addSnapshotListener { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let document = document, document.exists, let data = document.data(), let postIDs = data[FirebaseConstants.postIDs] as? [String] {
                let group = DispatchGroup()
                var userPosts: [PostModel] = []

                for postID in postIDs {
                    group.enter()
                    Firestore.firestore().collection(FirebaseConstants.posts).document(postID).getDocument { postDocument, error in
                        if let postDocument = postDocument, postDocument.exists, let postData = postDocument.data() {
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
                                let post = try JSONDecoder().decode(PostModel.self, from: jsonData)
                                userPosts.append(post)
                            } catch {
                                print("Error decoding post data: \(error)")
                            }
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(.success(userPosts))
                }
            }
        }
    }
    
    func uploadImageToFirebaseStorage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child("post_images/\(UUID().uuidString).jpg")
        
        if let uploadData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(uploadData, metadata: nil) { metadata, error in
                if error != nil {
                    print("Failed to upload image: \(error!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let imageUrl = url?.absoluteString {
                        completion(imageUrl)
                    } else {
                        print("Failed to fetch download URL: \(error?.localizedDescription ?? "No error description.")")
                        completion(nil)
                    }
                }
            }
        }
    }
    func saveNewPostToFirestore(userID: String, image: UIImage, description: String, completion: @escaping (Bool) -> Void) {
        // resmi Firebase Storage'a yükleme
        uploadImageToFirebaseStorage(image) { imageUrl in
            guard let imageUrl = imageUrl else {
                print("Failed to upload image to storage.")
                completion(false)
                return
            }
            
            // Resmin URL'siyle bir post oluşturma
            let postID = UUID().uuidString
            let newPost = PostModel(postID: postID, userID: userID, imageURL: imageUrl, desctiption: description, creationDate: Date(), commentIDs: [])
            
            // Yeni postu Firestore'a ekleme
            let dbRef = Firestore.firestore().collection(FirebaseConstants.posts).document(postID)
            do {
                let postData = try newPost.toDictionary()
                dbRef.setData(postData) { error in
                    if let error = error {
                        print("Failed to save post: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    let userRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(userID)
                    userRef.updateData([
                        FirebaseConstants.postIDs: FieldValue.arrayUnion([postID])
                    ]) { error in
                        if let error = error {
                            print("Failed to update user's postIDs: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                }
            } catch {
                print("Failed to encode post: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    func listenToAllUsersWithPosts(completion: @escaping (Result<[(user: UserModel, posts: [PostModel])], Error>) -> Void) {
        let db = Firestore.firestore()

        db.collection(FirebaseConstants.usersCollection).getDocuments { (usersSnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let usersDocuments = usersSnapshot?.documents else {
                completion(.failure(NSError(domain: "No users found", code: -1, userInfo: nil)))
                return
            }

            var allUsersWithPosts: [(user: UserModel, posts: [PostModel])] = []
            let semaphore = DispatchSemaphore(value: 1) // Semaphore başlangıç değeri

            let dispatchQueue = DispatchQueue.global()

            dispatchQueue.async {
                for userDocument in usersDocuments {
                    semaphore.wait() // Semaphore değerini 1 azaltır. Eğer 0 ise beklemeye başlar.
                    let userData = userDocument.data()

                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
                        let user = try JSONDecoder().decode(UserModel.self, from: jsonData)

                        self.listenToUserPosts(userID: userDocument.documentID) { result in
                            switch result {
                            case .success(let posts):
                                allUsersWithPosts.append((user: user, posts: posts))
                            case .failure(let error):
                                print("Error fetching posts for user \(userDocument.documentID): \(error)")
                            }
                            semaphore.signal() // Semaphore değerini 1 artırır. Bekleyen varsa devam eder.
                        }
                    } catch {
                        print("Error decoding user data for user \(userDocument.documentID): \(error)")
                        semaphore.signal()
                    }
                }

                semaphore.wait() // Son işlem tamamlanana kadar bekler.
                DispatchQueue.main.async {
                    completion(.success(allUsersWithPosts))
                }
                semaphore.signal() // Semaphore'yi serbest bırakır.
            }
        }
    }



}
