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
        fetchCoffeeData()
        animationView.play { (finished) in
            if Auth.auth().currentUser != nil {
                let mainVC = MainTabBarController()
                self.navigationController?.setViewControllers([mainVC], animated: true)
            } else {
                let onBoardVC = OnBoardViewController()
                self.navigationController?.setViewControllers([onBoardVC], animated: true)
            }
        }
    }
    
   private func fetchCurrentUser() {
        guard let user = Auth.auth().currentUser else { return }
        AuthenticationService.shared.fetchUserFromFirestore(user: user) { result in
            switch result {
            case .success(let fetchedUser):
                UserManager.shared.updateUser(fetchedUser)
            case .failure(let error):
                print("Error fetching user: \(error.localizedDescription)")
            }
        }
    }
    private func fetchCoffeeData() {
        DataService.shared.fetchAllCategoriesWithCoffees { result in
            switch result {
            case .success(let data):
                AppData.shared.categoriesWithCoffee = data
            case .failure(let error):
                print("Fetch Data Error: \(error)")
            }
        }
    }
}
