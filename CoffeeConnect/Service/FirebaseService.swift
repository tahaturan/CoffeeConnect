//
//  FirebaseService.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import FirebaseAuth

class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private init() {}
    
    // Kullanıcı Kaydı
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(AppError.custom(error.localizedDescription)))
                return
            }
            
            guard let user = authResult?.user else {
                completion(.failure(AppError.authenticationFailed))
                return
            }
            
            completion(.success(user))
        }
    }
    
    // Kullanıcı Girişi
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(AppError.custom(error.localizedDescription)))
                return
            }
            
            guard let user = authResult?.user else {
                completion(.failure(AppError.authenticationFailed))
                return
            }
            
            completion(.success(user))
        }
    }
    
    // Kullanıcı Çıkışı
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print("Sign out error: \(error.localizedDescription)")
            return false
        }
    }
    
    // Şu anki kullanıcıyı al
    var currentUser: User? {
        return Auth.auth().currentUser
    }
}

