//
//  DiscoverTableViewCell.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 21.10.2023.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {
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
    private var postImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 20
        return imageview
    }()

    private var postDescriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private var userNameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let userInfoView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 25
        view.backgroundColor = AppColors.ambassadorBlue.color
        return view
    }()
    private var postAddedDateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private let userProfileImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(post: PostModel, user: UserModel) {
        DispatchQueue.main.async {
            ImageLoader.shared.loadImage(into: self.postImageView, from: post.imageURL)
            ImageLoader.shared.loadImage(into: self.userProfileImage, from: user.profileImageURL)
            self.userNameLabel.text = user.name
            self.postDescriptionLabel.text = post.desctiption
            self.postAddedDateLabel.text = post.creationDate.timeAgoDisplay()
        }
        
    }
    func setupUI()  {
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(postImageView)
        backgroundContainerView.addSubview(userInfoView)
        userInfoView.addSubview(userProfileImage)
        userInfoView.addSubview(userNameLabel)
        userInfoView.addSubview(postDescriptionLabel)
        userInfoView.addSubview(postAddedDateLabel)
        
        backgroundContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        postImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        userProfileImage.snp.makeConstraints { make in
            make.left.equalTo(userInfoView.snp.left).offset(20)
            make.centerY.equalTo(userInfoView.snp.centerY)
            make.height.width.equalTo(40)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.top).offset(5)
            make.leading.equalTo(userProfileImage.snp.trailing).offset(10)
        }
        postDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(userNameLabel)
        }
        postAddedDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImage)
            make.trailing.equalToSuperview().inset(10)
        }
    }

}
