//
//  HomeViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import SnapKit
import UIKit
import FirebaseAuth
import SDWebImage

class HomeViewController: UIViewController {
    // MARK: - Properties
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = AppColors.vanillaMocha.color.cgColor
        imageView.layer.cornerRadius = AppStyleConstants.homeUserImageSize / 2
        return imageView
    }()
    // Favori ve Sepet butunlari
     lazy var favoriteButton: UIButton = createNavigationBarButton(with: AppStyleConstants.Icons.heart, action: #selector(didTapFavorite))
    private lazy var basketButton: UIButton = createNavigationBarButton(with: AppStyleConstants.Icons.cart, action: #selector(didTapBasket))

    private lazy var navbarFavoriteButton = UIBarButtonItem(customView: favoriteButton)
    private lazy var navbarBasketButton = UIBarButtonItem(customView: basketButton)
    private lazy var spacerBarButtonItem: UIBarButtonItem = {
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 24))
        return UIBarButtonItem(customView: spacer)
    }()

    // Ekran arkaplan gorunumu
    private let bacgroungView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.1)
        return view
    }()

    // Kategoriler basligi
    private let labelText: UILabel = {
        let label = UILabel()
        label.text = StringConstants.General.categories
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        //FirebaseService.shared.signOut()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        bacgroungView.layer.mask = shape
    }
}

// MARK: - Helper

extension HomeViewController {
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        view.addSubview(userProfileImageView)
        loadUserProfileImage()
        view.addSubview(bacgroungView)
        bacgroungView.addSubview(labelText)
        setupCategoryButtons()
    }
    //Ekran icin gorunumlerin konumlandirilmasi
    private func setupLayout() {
        userProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(view.snp.leading).offset(5)
            make.height.width.equalTo(AppStyleConstants.homeUserImageSize)
        }
        bacgroungView.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(10)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        labelText.snp.makeConstraints { make in
            make.top.equalTo(bacgroungView).offset(30)
            make.leading.equalTo(bacgroungView).offset(20)
        }
    }
    private func loadUserProfileImage() {
        let placeholderImage = UIImage(named: AppStyleConstants.Icons.defaultAvatar)
        if let user = UserManager.shared.currentUser {
            ImageLoader.shared.loadImage(into: userProfileImageView, from: user.profileImageURL)
        }
        
    }
    // NavBar ozellikleri
    private func setupNavigationBar() {
        navigationItem.title = StringConstants.General.appName
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
        navigationItem.rightBarButtonItems = [navbarFavoriteButton, spacerBarButtonItem, navbarBasketButton]
    }
    //Kategori Butonlarinin olsuturulmasi
    private func setupCategoryButtons() {
        setupCategoriesRow(categories: StringConstants.HomeView.topCategories, topOffset: 20) // üst sıra için
        setupCategoriesRow(categories: StringConstants.HomeView.bottomCategories, topOffset: 90) // alt sıra için, offset değerini ayarlayarak butonların arasındaki boşluğu ayarliyoruz
    }
    private func setupCategoriesRow(categories: [String], topOffset: CGFloat) {
        let buttonWidth = (view.frame.width - 60) / 3 // 20'lik padding ile 3'e bölüyoruz.
        var lastButton: UIButton?
        
        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.layer.cornerRadius = AppStyleConstants.categoryButtonHeight / 2
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.gray, for: .normal)
            button.addTarget(self, action: #selector(didTapCategoryButton(_:)), for: .touchUpInside)
            bacgroungView.addSubview(button)

            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(AppStyleConstants.categoryButtonHeight)
                make.top.equalTo(labelText.snp.bottom).offset(topOffset)

                if let lastBtn = lastButton {
                    make.leading.equalTo(lastBtn.snp.trailing).offset(10)
                } else {
                    make.leading.equalTo(bacgroungView).offset(25)
                }
            }
            lastButton = button
        }
    }
}

// MARK: - Selector

extension HomeViewController {
    // Favori butonuna tıklandığında yapılacak işlemler
    @objc private func didTapFavorite() {
    }

    // Sepet butonuna tıklandığında yapılacak işlemler
    @objc private func didTapBasket() {
    }

    // kategori butonlarina tıklandığında yapılacak işlemler
    @objc private func didTapCategoryButton(_ sender: UIButton) {
        if let categoryTitle = sender.titleLabel?.text {
            print(categoryTitle)
        }
    }
}

// MARK: - Factory Methods

extension HomeViewController {
    //NavBar Buttonlari olsuturmak icin bir fabrika(Factory Method) olusuturuyoruz
    private func createNavigationBarButton(with iconName: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
