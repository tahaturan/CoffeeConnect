//
//  ViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 8.10.2023.
//

import SnapKit
import UIKit

class LoginViewController: UIViewController {
    // MARK: - Properties

    private let logoImageView: LoginLogoImageView = LoginLogoImageView(imageName: AppStyle.AppImages.loginRegisterPageLogo)
    private let emailTextField: CustomTextField = CustomTextField()
    private let passwordTextField: CustomTextField = CustomTextField()
    private let loginButton: CustomButton = CustomButton(title: StringConstants.Login.loginButtonTitle)
    private let registerButton: CustomButton = CustomButton(title: StringConstants.Login.registerButtonTitle, color: AppColors.curiousChipmunk.color)

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        setupLayout()
    }
}

// MARK: - Helpers

extension LoginViewController {
    func setupUI() {
        emailTextField.fieldType = .email
        passwordTextField.fieldType = .password
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }

    func setupLayout() {
        // logoImageView Constraints
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.left.equalTo(view)
            make.height.equalTo(300)
        }
        // emailTextField Constraints
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(50)
        }
        // passwordTextField Constraints
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.height.equalTo(emailTextField)
        }
        // loginButton Constraints
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(50)
        }
        // registerButton Constraints
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.left.right.height.equalTo(loginButton)
        }
    }
}

// MARK: - Selector

extension LoginViewController {
    @objc private func registerButtonTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
