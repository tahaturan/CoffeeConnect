//
//  CustomTextField.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 8.10.2023.
//

import UIKit

class CustomTextField: UITextField {
    private let visibilityToggleButton: UIButton = UIButton(type: .system)
    enum FieldType {
        case email
        case password
        case generic
        case name
        case userName
    }

    var fieldType: FieldType = .generic {
        didSet {
            configureForType()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        layer.borderWidth = 1
        layer.borderColor = AppColors.ambassadorBlue.color.withAlphaComponent(0.25).cgColor
        layer.cornerRadius = 15
        layer.shadowColor = AppColors.curiousChipmunk.color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
        backgroundColor = .white
        clipsToBounds = false
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftViewMode = .always
    }

    private func configureForType() {
        let iconSize: CGFloat = AppStyleConstants.iconSize
        let padding: CGFloat = AppStyleConstants.padding
        let iconImageView = UIImageView(frame: CGRect(x: padding, y: (frame.height - iconSize) / 2, width: iconSize, height: iconSize))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .darkGray.withAlphaComponent(0.5)

        let viewWidth = iconSize + 2 * padding
        let leftIconView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: frame.height))
        leftIconView.addSubview(iconImageView)
        

        switch fieldType {
        case .email:
            iconImageView.image = UIImage(systemName: AppStyleConstants.Icons.email)
            keyboardType = .emailAddress
            isSecureTextEntry = false
            placeholder = StringConstants.Login.emailPlaceholder
            autocapitalizationType = .none
        case .password:
            iconImageView.image = UIImage(systemName: AppStyleConstants.Icons.lock)
            keyboardType = .default
            isSecureTextEntry = true
            placeholder = StringConstants.Login.passwordPlaceholder
            autocapitalizationType = .none
            setupVisibilityButton()

        case .generic:
            keyboardType = .default
            isSecureTextEntry = false
            placeholder = StringConstants.General.enterText
        case .name:
            iconImageView.image = UIImage(systemName: AppStyleConstants.Icons.user)
            keyboardType = .default
            isSecureTextEntry = false
            placeholder = StringConstants.Login.namePlaceholder
            autocapitalizationType = .words
        case .userName:
            iconImageView.image = UIImage(systemName: AppStyleConstants.Icons.userCard)
            keyboardType = .default
            isSecureTextEntry = false
            placeholder = StringConstants.Login.usernamePlaceholder
            autocapitalizationType = .none
        }

        leftView = leftIconView
        leftViewMode = .always
    }

    func setupVisibilityButton() {
        let imageName = isSecureTextEntry ? AppStyleConstants.Icons.eyeSlash : AppStyleConstants.Icons.eye
        let image = UIImage(systemName: imageName)
        visibilityToggleButton.setImage(image, for: .normal)
        visibilityToggleButton.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)
        visibilityToggleButton.tintColor = AppColors.ambassadorBlue.color.withAlphaComponent(0.30)
        
        rightView = visibilityToggleButton
        rightViewMode = .always
    }
}

// MARK: - Selector

extension CustomTextField {
    @objc private func toggleVisibility() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? AppStyleConstants.Icons.eyeSlash : AppStyleConstants.Icons.eye
        let image = UIImage(systemName: imageName)
        visibilityToggleButton.setImage(image, for: .normal)
    }
}
