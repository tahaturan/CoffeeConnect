//
//  ProfileViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    //MARK: - Properties
    private let coverImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.image = UIImage.cover
        return imageView
    }()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .gray
        return label
    }()
    private lazy var signOutButton: UIButton = {
       let button = UIButton()
        button.setTitle(StringConstants.General.signOut, for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.23
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowColor = AppColors.special.color.cgColor
        button.addTarget(self, action: #selector(handleSignOutButton), for: .touchUpInside)
        return button
    }()
    private let collectionLabel: UILabel = UILabel()
    private lazy var cofeeCollectionsView: UIView = createUserCollectionView(labelText: StringConstants.General.coffee, image: UIImage.cofee, profileImage: UIImage.user, score: 1.3)
    private lazy var cofeeCollectionsTwoView: UIView = createUserCollectionView(labelText: StringConstants.General.coffee, image: UIImage.coffees, profileImage: UIImage.taha, score: 1.4)
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
}
//MARK: - Helper
extension ProfileViewController {
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        configureUI()
        view.addSubview(coverImageView)
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(userNameLabel)
        view.addSubview(signOutButton)
        view.addSubview(collectionLabel)
        view.addSubview(cofeeCollectionsView)
        view.addSubview(cofeeCollectionsTwoView)
    }
    private func setupLayout() {
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(110)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(-40)
            make.centerX.equalTo(coverImageView.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.centerX.equalTo(profileImageView.snp.centerX)
            
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.equalTo(nameLabel.snp.centerX)
        }
        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
            make.left.right.equalTo(coverImageView)
            make.height.equalTo(40)
        }
        collectionLabel.snp.makeConstraints { make in
            make.top.equalTo(signOutButton.snp.bottom).offset(60)
            make.left.equalToSuperview().inset(20)
        }
        cofeeCollectionsView.snp.makeConstraints { make in
            make.top.equalTo(collectionLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(170)
            make.height.equalTo(210)
        }
        cofeeCollectionsTwoView.snp.makeConstraints { make in
            make.top.equalTo(collectionLabel.snp.bottom).offset(20)
            make.left.equalTo(cofeeCollectionsView.snp.right).inset(-20)
            make.width.equalTo(170)
            make.height.equalTo(210)
        }
    }
    private func setupNavigationBar() {
        navigationItem.title = StringConstants.General.appName
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
    }
    private func configureUI() {
        if let user = UserManager.shared.currentUser {
            DispatchQueue.main.async {
                ImageLoader.shared.loadImage(into: self.profileImageView, from: user.profileImageURL)
                self.nameLabel.text = user.name
                self.userNameLabel.text = "@\(user.username)"
                self.collectionLabel.text = StringConstants.General.coffeeCollections
                
            }
        }
    }
}
//MARK: - Selector
extension ProfileViewController {
    @objc private func handleSignOutButton() {
        AuthenticationService.shared.signOut()
        let loginVC = LoginViewController()
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = UINavigationController(rootViewController: loginVC)
        }
    }
}
//MARK: - Factory Methods
extension ProfileViewController {
    private func createUserCollectionView(labelText: String, image: UIImage, profileImage: UIImage, score: Double) -> UIView {
        let view = UIView()
         view.layer.cornerRadius = 20
         view.layer.shadowOpacity = 0.23
         view.layer.shadowRadius = 6
         view.layer.shadowOffset = CGSize(width: 0, height: 6)
         view.layer.shadowColor = AppColors.special.color.cgColor
         view.clipsToBounds = false
         view.backgroundColor = .white
         
         let coverImageView = UIImageView()
         coverImageView.image = image
         coverImageView.contentMode = .scaleAspectFill
         coverImageView.clipsToBounds = true
         coverImageView.layer.cornerRadius = 20
         
         let profileImageView = UIImageView()
         profileImageView.image = profileImage
         profileImageView.contentMode = .scaleAspectFill
         profileImageView.clipsToBounds = true
         profileImageView.layer.cornerRadius = 15
         
         let coffeeLabel = UILabel()
         coffeeLabel.text = labelText
         coffeeLabel.font = UIFont.boldSystemFont(ofSize: 15)
         
         let scoreLabel = UILabel()
         scoreLabel.text = "\(score)"
         
         view.addSubview(coverImageView)
         view.addSubview(profileImageView)
         view.addSubview(coffeeLabel)
         view.addSubview(scoreLabel)
         
         coverImageView.snp.makeConstraints { make in
             make.top.equalToSuperview()
             make.left.right.equalToSuperview()
             make.height.equalTo(150)
         }
         profileImageView.snp.makeConstraints { make in
             make.top.equalTo(coverImageView.snp.bottom).offset(-10)
             make.left.equalToSuperview().inset(10)
             make.height.width.equalTo(30)
         }
         coffeeLabel.snp.makeConstraints { make in
             make.top.equalTo(profileImageView.snp.bottom).offset(10)
             make.left.equalTo(profileImageView)
         }
         scoreLabel.snp.makeConstraints { make in
             make.top.equalTo(profileImageView.snp.bottom).offset(10)
             make.right.equalToSuperview().inset(10)
         }
         return view
    }
}
