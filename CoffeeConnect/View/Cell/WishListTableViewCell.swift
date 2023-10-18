//
//  WishListTableViewCell.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import UIKit

class WishListTableViewCell: UITableViewCell {
    //MARK: - Properties
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
        label.numberOfLines = 3
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
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = AppColors.special.color.cgColor
        
        contentView.addSubview(coffeeImageView)
        contentView.addSubview(coffeeNameLabel)
        contentView.addSubview(coffeeDescriptionLabel)
        contentView.addSubview(priceLabel)
        coffeeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(100)
            make.height.equalTo(100)
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
