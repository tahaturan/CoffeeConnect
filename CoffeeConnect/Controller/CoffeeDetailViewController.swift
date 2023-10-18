//
//  CoffeeDetailViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import UIKit

class CoffeeDetailViewController: UIViewController {
    //MARK: - Properties
    var coffee: CoffeeModel? = nil
    private let coffeeImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let coffeeDescriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    private let addToBasketButton: CustomButton = CustomButton(title: "Add To Basket")
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
}
//MARK: - Helper
extension CoffeeDetailViewController {
    private func setupUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        setupNavigationBar()
        configureProperties()
        view.addSubview(coffeeImageView)
        view.addSubview(coffeeDescriptionLabel)
        view.addSubview(addToBasketButton)
        view.addSubview(priceLabel)
    }
    private func setupLayout() {
        coffeeImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
        coffeeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(coffeeImageView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(coffeeDescriptionLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
        }
        addToBasketButton.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(60)
            make.leading.equalTo(view.snp.leading).offset(40)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
            make.height.equalTo(50)
        }
    }
    private func configureProperties() {
        addToBasketButton.addTarget(self, action: #selector(handleBasketButton), for: .touchUpInside)
        if let coffee = coffee {
            coffeeDescriptionLabel.text = coffee.description
            priceLabel.text = "\(coffee.price)₺"
            DispatchQueue.main.async {
                ImageLoader.shared.loadImage(into: self.coffeeImageView, from: coffee.imageURL)
            }
        }
    }
    private func setupNavigationBar() {
        navigationItem.title = coffee?.name ?? ""
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
    }
}
//MARK: - Selector
extension CoffeeDetailViewController {
    @objc private func handleBasketButton() {
        if let coffee = coffee {
            DispatchQueue.global(qos: .background).async {
                UserManager.shared.addCoffeeToBasket(coffee: coffee) { result in
                    DispatchQueue.main.async {
                        if result {
                            self.showAlert(title: StringConstants.General.success, message: StringConstants.HomeView.productAddedToCart)
                        }else {
                            self.showAlert(title: StringConstants.General.error, message: StringConstants.Errors.unknown)
                        }
                    }
                }
            }
        }
    }
}
