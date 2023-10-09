//
//  CustomTextField.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 8.10.2023.
//

import UIKit

class CustomTextField: UITextField {

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
        super.init(frame: .zero) // Frame'i .zero olarak ayarladık
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = AppStyle.defaultCornerRadius
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
    }

    private func configureForType() {
        let iconSize: CGFloat = AppStyle.iconSize
        let padding: CGFloat = AppStyle.defaultPadding
        let iconImageView = UIImageView(frame: CGRect(x: padding, y: (self.frame.height - iconSize) / 2, width: iconSize, height: iconSize))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .darkGray
        
        let viewWidth = iconSize + 2 * padding
        let leftIconView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: self.frame.height))
        leftIconView.addSubview(iconImageView)
        
        switch fieldType {
        case .email:
            iconImageView.image = UIImage(systemName: "envelope")
            self.keyboardType = .emailAddress
            self.isSecureTextEntry = false
            self.placeholder = StringConstants.Login.emailPlaceholder
        case .password:
            iconImageView.image = UIImage(systemName: "lock")
            self.keyboardType = .default
            self.isSecureTextEntry = true
            self.placeholder = StringConstants.Login.passwordPlaceholder
        case .generic:
            self.keyboardType = .default
            self.isSecureTextEntry = false
            self.placeholder = StringConstants.AppString.enterText
        }
        
        self.leftView = leftIconView
        self.leftViewMode = .always
    }
}

