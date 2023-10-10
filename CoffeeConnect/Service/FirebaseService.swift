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

    // MARK: - Kullanıcı Kaydı

    func signUp(email: String, password: String, name: String, username: String, profileImage: UIImage, completion: @escaping (Result<User, Error>) -> Void) {
        // 1. Kullanıcıyı Firebase Authentication ile kaydediyoruz.
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            

            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred."])))
                return
            }

            // 2. Kullanıcının profil fotoğrafını Firebase Storage'a kaydediyoruz.
            let storageRef = Storage.storage().reference().child("profile_images").child("\(user.uid).jpg")
            if let uploadData = profileImage.jpegData(compressionQuality: 0.75) {
                storageRef.putData(uploadData, metadata: nil) { _, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    storageRef.downloadURL { url, error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }

                        guard let profileImageUrl = url?.absoluteString else {
                            completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get profile image URL."])))
                            return
                        }

                        // 3. Kullanıcının bilgilerini Firestore'a kaydediyoruz.
                        let dbRef = Firestore.firestore().collection("users").document(user.uid)
                        let userData: [String: Any] = [
                            "name": name,
                            "username": username,
                            "email": email,
                            "balance": 0.0,
                            "profileImageURL": profileImageUrl,
                            "posts": [],
                            "shoppingCart": ["userID": user.uid, "items": []],
                            "wishlist": [],
                        ]

                        dbRef.setData(userData) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(user))
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Kullanıcı Girişi

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }

    // MARK: - Kullanıcı Çıkışı

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print("Sign out error: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Şu anki kullanıcıyı al

    var currentUser: User? {
        return Auth.auth().currentUser
    }
}
