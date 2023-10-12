//
//  LaunchScreenViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 13.10.2023.
//

import UIKit
import Lottie
import FirebaseAuth
import SnapKit

class SplashViewController: UIViewController {
    
    let animationView = LottieAnimationView(name: "LaunchScreen")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(animationView)
        animationView.loopMode = .playOnce
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(700)
        }
        fetchCurrentUser()
        animationView.play { (finished) in
            print("Animasyon tamamlandı mı?: \(finished)")
            if Auth.auth().currentUser != nil {
                let mainVC = HomeViewController()
                self.navigationController?.setViewControllers([mainVC], animated: true)
            } else {
                let loginVC = LoginViewController()
                self.navigationController?.setViewControllers([loginVC], animated: true)
            }
        }
    }
    
   private func fetchCurrentUser() {
        guard let user = Auth.auth().currentUser else { return }
        FirebaseService.shared.fetchUserFromFirestore(user: user) { result in
            switch result {
            case .success(let fetchedUser):
                UserManager.shared.updateUser(fetchedUser)
            case .failure(let error):
                print("Error fetching user: \(error.localizedDescription)")
            }
        }
    }
}
