//
//  WishListTableViewCell.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import UIKit

class WishListTableViewCell: UITableViewCell {
    //MARK: - Properties
    private var backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.shadowOpacity = 0.23
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowColor = AppColors.special.color.cgColor
        return view
    }()
    private var coffeeImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 20
        return imageview
    }()
    private var coffeeNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    private var coffeeDescriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    private var priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell(coffee: CoffeeModel) {
        coffeeNameLabel.text = coffee.name
        ImageLoader.shared.loadImage(into: self.coffeeImageView, from: coffee.imageURL)
        coffeeDescriptionLabel.text = coffee.description
        priceLabel.text = "\(coffee.price)₺"
    }
    
    func setupUI()  {
        self.accessoryType = .disclosureIndicator
        
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(coffeeImageView)
        backgroundContainerView.addSubview(coffeeNameLabel)
        backgroundContainerView.addSubview(coffeeDescriptionLabel)
        backgroundContainerView.addSubview(priceLabel)
        
        backgroundContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(105)
        }
        coffeeImageView.snp.makeConstraints { make in
            make.top.equalTo(backgroundContainerView.snp.top).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(100)
            make.height.equalTo(95)
        }
        coffeeNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(coffeeImageView.snp.trailing).offset(5)
        }
        coffeeDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(coffeeNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(coffeeImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(coffeeDescriptionLabel.snp.bottom).offset(5)
            make.leading.equalTo(coffeeImageView.snp.trailing).offset(5)
        }

    }
}
