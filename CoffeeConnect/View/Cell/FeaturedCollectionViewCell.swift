//
//  FeaturedCollectionViewCell.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 16.10.2023.
//

import Foundation
import UIKit
import SnapKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    private let customBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    private let coffeeImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    private let stackView: UIStackView = UIStackView()
    private lazy var favoriteButton: UIButton = createButton(with: AppStyleConstants.Icons.heart, color: .lightGray, action: #selector(favoriteButtonTapped))
    private lazy var basketButton: UIButton = createButton(with: AppStyleConstants.Icons.cart, color: .darkGray, action: #selector(basketButtonTapped))
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    private func setupUI() {
        addSubview(customBackgroundView)
        customBackgroundView.addSubview(coffeeImageView)
        customBackgroundView.addSubview(priceLabel)
        stackView.addArrangedSubview(favoriteButton)
        stackView.addArrangedSubview(basketButton)
        stackView.axis = .horizontal
        stackView.spacing = 5
        customBackgroundView.addSubview(stackView)
        
        customBackgroundView.snp.makeConstraints { make in
            make.top.right.left.bottom.equalToSuperview()
            
        }
        
        coffeeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(100)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(coffeeImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            
        }
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with coffee: CoffeeModel) {
        
            ImageLoader.shared.loadImage(into: self.coffeeImageView, from: coffee.imageURL)
            self.priceLabel.text = "\(coffee.price)₺"
        
       
    }
}

//MARK: - Selector
extension FeaturedCollectionViewCell {
    @objc private func favoriteButtonTapped () {
        if favoriteButton.tintColor == .lightGray {
            favoriteButton.tintColor = .red
        }else {
            favoriteButton.tintColor = .lightGray
        }
    }
    @objc private func basketButtonTapped () {
        
    }
}

//MARK: - Factory Methods
extension FeaturedCollectionViewCell {
    private func createButton(with iconName: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.tintColor = color
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
