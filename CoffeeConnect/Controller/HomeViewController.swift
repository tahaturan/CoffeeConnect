//
//  HomeViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties

    private lazy var favoriteButton = createButton(with: AppStyleConstants.Icons.heart, action: #selector(didTapFavorite))
    private lazy var basketButton = createButton(with: AppStyleConstants.Icons.cart, action: #selector(didTapBasket))
    private let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 24))
    private lazy var navbarFavoriteButton = UIBarButtonItem(customView: favoriteButton)
    private lazy var navbarBasketButton = UIBarButtonItem(customView: basketButton)
    private lazy var spacerBarButtonItem = UIBarButtonItem(customView: spacer)

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
        setupLayout()
    }
}

// MARK: - Helper

extension HomeViewController {
    private func setupUI() {
    }

    private func setupLayout() {
    }

    private func setupNavigationBar() {
        navigationItem.title = StringConstants.General.appName
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
        navigationItem.rightBarButtonItems = [navbarFavoriteButton, spacerBarButtonItem, navbarBasketButton]
    }
}

// MARK: - Selector

extension HomeViewController {
    @objc private func didTapFavorite() {
        // Favori butonuna tıklandığında yapılacak işlemler
        
    }

    @objc private func didTapBasket() {
        // Sepet butonuna tıklandığında yapılacak işlemler
    }
}

// MARK: - Factory Methods

extension HomeViewController {
    private  func createButton(with iconName: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
