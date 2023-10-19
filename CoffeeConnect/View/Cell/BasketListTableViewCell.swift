//
//  BasketListTableViewCell.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import UIKit

protocol BasketListTableViewCellDelegate: AnyObject {
    func didTapIncreaseButton(cell: BasketListTableViewCell)
    func didTapDecreaseButton(cell: BasketListTableViewCell)
    func didTapDeleteButton(cell: BasketListTableViewCell)
}

class BasketListTableViewCell: UITableViewCell {

    //MARK: - Properties
    var delegate: BasketListTableViewCellDelegate?
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
    private var deleteButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: AppStyleConstants.Icons.trash), for: .normal)
        button.tintColor = .gray
        return button
    }()
    private var priceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    private var addButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: AppStyleConstants.Icons.plus), for: .normal)
        button.tintColor = AppColors.ambassadorBlue.color
        return button
    }()
    private var removeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: AppStyleConstants.Icons.minus), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    private var quantityLabel: UILabel = {
       let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private var stackView = UIStackView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureCell(coffee: CoffeeModel, quantity: Int) {
        DispatchQueue.main.async {
            self.coffeeNameLabel.text = coffee.name
            ImageLoader.shared.loadImage(into: self.coffeeImageView, from: coffee.imageURL)
            self.priceLabel.text = "\(Double(quantity) * coffee.price)₺"
            self.quantityLabel.text = "\(quantity)"
            if quantity <= 1 {
                self.removeButton.isEnabled = false
                self.removeButton.tintColor = .gray
            }else {
                self.removeButton.isEnabled = true
                self.removeButton.tintColor = .darkGray
            }
        }
    }
    
    func setupUI()  {
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(coffeeImageView)
        backgroundContainerView.addSubview(coffeeNameLabel)
        backgroundContainerView.addSubview(deleteButton)
        backgroundContainerView.addSubview(priceLabel)
        stackView = UIStackView(arrangedSubviews: [removeButton,quantityLabel,addButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        backgroundContainerView.addSubview(stackView)
        addButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        backgroundContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        coffeeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.width.equalTo(80)
            make.height.equalTo(90)
        }
        coffeeNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(coffeeImageView.snp.trailing).offset(5)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-20)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom).offset(35)
            make.trailing.equalTo(deleteButton)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(coffeeNameLabel.snp.bottom).offset(20)
            make.leading.equalTo(coffeeImageView.snp.trailing).offset(40)
        }
    }
}
//MARK: - Selector
extension BasketListTableViewCell {
    @objc func increaseButtonTapped() {
         delegate?.didTapIncreaseButton(cell: self)
     }

     @objc func decreaseButtonTapped() {
         delegate?.didTapDecreaseButton(cell: self)
     }

     @objc func deleteButtonTapped() {
         delegate?.didTapDeleteButton(cell: self)
     }
}
