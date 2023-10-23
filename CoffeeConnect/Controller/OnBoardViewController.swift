//
//  OnBoardViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 23.10.2023.
//

import UIKit
import SnapKit

class OnBoardViewController: UIViewController {

    //MARK: - Properties
    private let onboardImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage.onboard
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let cofeeConnectTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.text = StringConstants.General.appName
        return label
    }()
    private let cofeeConnectDescriptionLabel: UILabel = {
       let label = UILabel()
        label.text = "Discover and connect with coffee lovers"
        label.font = UIFont.systemFont(ofSize: 30)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let startedButton: CustomButton = CustomButton(title: "Get Started")
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
}
//MARK: - Helper
extension OnBoardViewController{
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(onboardImageView)
        view.addSubview(cofeeConnectTitleLabel)
        view.addSubview(cofeeConnectDescriptionLabel)
        view.addSubview(startedButton)
        startedButton.addTarget(self, action: #selector(handleStartedButton), for: .touchUpInside)
    }
    private func setupLayout() {
        onboardImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
        cofeeConnectTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(onboardImageView.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
        }
        cofeeConnectDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(cofeeConnectTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(50)
        }
        startedButton.snp.makeConstraints { make in
            make.top.equalTo(cofeeConnectDescriptionLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}
//MARK: - Selector
extension OnBoardViewController {
    @objc private func handleStartedButton() {
        let loginVC = LoginViewController()
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
