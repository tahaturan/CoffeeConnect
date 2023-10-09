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
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = AppStyle.defaultCornerRadius
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftViewMode = .always
    }

    private func configureForType() {
        let iconSize: CGFloat = AppStyle.iconSize
        let padding: CGFloat = AppStyle.defaultPadding
        let iconImageView = UIImageView(frame: CGRect(x: padding, y: (frame.height - iconSize) / 2, width: iconSize, height: iconSize))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .darkGray

        let viewWidth = iconSize + 2 * padding
        let leftIconView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: frame.height))
        leftIconView.addSubview(iconImageView)
        

        switch fieldType {
        case .email:
            iconImageView.image = UIImage(systemName: AppStyle.AppImages.emailIcon)
            keyboardType = .emailAddress
            isSecureTextEntry = false
            placeholder = StringConstants.Login.emailPlaceholder
        case .password:
            iconImageView.image = UIImage(systemName: AppStyle.AppImages.lockIcon)
            keyboardType = .default
            isSecureTextEntry = true
            placeholder = StringConstants.Login.passwordPlaceholder
            setupVisibilityButton()

        case .generic:
            keyboardType = .default
            isSecureTextEntry = false
            placeholder = StringConstants.AppString.enterText
        }

        leftView = leftIconView
        leftViewMode = .always
    }

    func setupVisibilityButton() {
        let imageName = isSecureTextEntry ? AppStyle.AppImages.eyeSlash : AppStyle.AppImages.eyeIcon
        let image = UIImage(systemName: imageName)
        visibilityToggleButton.setImage(image, for: .normal)
        visibilityToggleButton.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)
        visibilityToggleButton.tintColor = AppColors.curiousChipmunk.color
        
        rightView = visibilityToggleButton
        rightViewMode = .always
    }
}

// MARK: - Selector

extension CustomTextField {
    @objc private func toggleVisibility() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? AppStyle.AppImages.eyeIcon : AppStyle.AppImages.eyeSlash
        let image = UIImage(systemName: imageName)
        visibilityToggleButton.setImage(image, for: .normal)
    }
}
