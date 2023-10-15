//
//  FirebaseService.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class FirebaseService {
    // Singleton pattern ile sadece bir örnek oluşturulmasını sağlıyoruz.
    static let shared = FirebaseService()
    
    private init() {}
    
    // MARK: - User SignUp
    
    func signUp(email: String, password: String, name: String, username: String, profileImage: UIImage, completion: @escaping (Result<UserModel, Error>) -> Void) {
        // 1. Kullanıcıyı Firebase Authentication ile kaydediyoruz.
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(AppError.custom(error.localizedDescription)))
                return
            }
            
            guard let user = authResult?.user else {
                completion(.failure(AppError.authenticationFailed))
                return
            }
            
            // 2. Kullanıcının profil fotoğrafını Firebase Storage'a kaydediyoruz.
            self.uploadProfileImage(user: user, image: profileImage) { result in
                switch result {
                case .success(let profileImageUrl):
                    // 3. Kullanıcının bilgilerini Firestore'a kaydediyoruz.
                    let newUser = UserModel(userID: user.uid, name: name, username: username, email: email, balance: 0.0, profileImageURL: profileImageUrl, postIDs: [], shoppingCart: ShoppingCartModel(userID: user.uid, items: []), wishlist: [])
                    self.saveUserToFirestore(user: newUser, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    // Profil fotoğrafını yüklemek için
    private func uploadProfileImage(user: User, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child(FirebaseConstants.profileImagesFolder).child("\(user.uid).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.75) {
            storageRef.putData(uploadData, metadata: nil) { _, error in
                if let error = error {
                    completion(.failure(AppError.custom(error.localizedDescription)))
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(AppError.custom(error.localizedDescription)))
                        return
                    }
                    
                    guard let profileImageUrl = url?.absoluteString else {
                        completion(.failure(AppError.profileImageURLNotFound))
                        return
                    }
                    
                    completion(.success(profileImageUrl))
                }
            }
        }
    }
    
    // Kullanıcı bilgilerini Firestore'a kaydetmek için
    private func saveUserToFirestore(user: UserModel, completion: @escaping (Result<UserModel, Error>) -> Void) {
      
        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(user.userID)
        do {
            let userData = try user.toDictionary()
            dbRef.setData(userData) { error in
                if let error = error {
                    completion(.failure(AppError.custom(error.localizedDescription)))
                } else {
                    completion(.success(user))
                }
            }
        } catch {
            completion(.failure(AppError.dataEncodingFailed))
        }
    }
    
    // MARK: - User SignIn
    
    func signIn(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(AppError.custom(error.localizedDescription)))
                return
            }
            
            guard let user = authResult?.user else {
                completion(.failure(AppError.authenticationFailed))
                return
            }
            
            // Kullanıcı Bilgilerini Firestore'dan alıyoruz
            self.fetchUserFromFirestore(user: user, completion: completion)
        }
    }
    
    // Kullanıcı bilgilerini Firestore'dan almak için
     func fetchUserFromFirestore(user: User, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let dbRef = Firestore.firestore().collection(FirebaseConstants.usersCollection).document(user.uid)
        dbRef.getDocument { document, error in
            if let error = error {
                completion(.failure(AppError.custom(error.localizedDescription)))
                return
            }
            
            if let userDocument = document, userDocument.exists {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: userDocument.data()!)
                    let loggedInUser = try JSONDecoder().decode(UserModel.self, from: jsonData)
                    UserManager.shared.updateUser(loggedInUser)
                    completion(.success(loggedInUser))
                } catch {
                    completion(.failure(AppError.dataDecodingFailed))
                }
            } else {
                completion(.failure(AppError.userDocumentNotFound))
            }
        }
    }
    
    // MARK: - User SignOut
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            UserManager.shared.clearUser()
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - CurrentUser

    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    func fetchAllCategoriesWithCoffees(completion: @escaping (Result<[(CoffeeCategoryModel, [CoffeeModel])], Error>) -> Void) {
        var cetegoriesWithCoffees: [(CoffeeCategoryModel, [CoffeeModel])] = []
        
        //Firestore dan tum kategorileri cekme
        let dbRef = Firestore.firestore().collection("coffee_categories")
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
                        Firestore.firestore().collection("coffees").document(coffeeID).getDocument { coffeeDocument, error in
                            guard let coffeeData = coffeeDocument?.data() else {
                                group.leave()
                                return
                            }
                            do {
                                let coffeeJsonData = try JSONSerialization.data(withJSONObject: coffeeData)
                                let coffee = try CoffeeModel.fromDictionary(jsonData: coffeeJsonData)
                                coffees.append(coffee)
                            } catch  {
                                print("Error decoding coffe data: \(error)")
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        cetegoriesWithCoffees.append((category, coffees))
                    }
                } catch  {
                    print("Error decoding category data: \(error)")
                }
            }
            group.notify(queue: .main) {
                completion(.success(cetegoriesWithCoffees))
            }
        }
    }
}

