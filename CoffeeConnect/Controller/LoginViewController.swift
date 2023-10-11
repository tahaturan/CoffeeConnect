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

    private let logoImageView: LoginLogoImageView = LoginLogoImageView(imageName: AppStyleConstants.Icons.loginLogo)
    private let emailTextField: CustomTextField = CustomTextField()
    private let passwordTextField: CustomTextField = CustomTextField()
    private let loginButton: CustomButton = CustomButton(title: StringConstants.Login.loginButton)
    private let registerButton: CustomButton = CustomButton(title: StringConstants.Login.registerButton, color: AppColors.curiousChipmunk.color)
    private let progressIndicator: CustomProgressIndicator = CustomProgressIndicator()

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
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }

    func setupLayout() {
        // logoImageView Constraints
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
    @objc private func handleLoginButton() {
        progressIndicator.show(on: self.view)
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else {
            showAlert(title: StringConstants.General.error, message: StringConstants.General.fillFields)
            return
        }
        if email.isEmpty || password.isEmpty {
            progressIndicator.hide()
            showAlert(title: StringConstants.General.error, message: StringConstants.General.fillFields)
        }else{
            FirebaseService.shared.signIn(email: email, password: password) { result in
                switch result {
                case .success(_):
                    let homeVC = HomeViewController()
                    if let navigationController = self.navigationController {
                        navigationController.viewControllers = [homeVC]
                    }
                case .failure(_):
                    self.showAlert(title: StringConstants.General.error, message: StringConstants.Errors.authenticationFailed)
                }
                self.progressIndicator.hide()
            }
            
        }
    }
}
