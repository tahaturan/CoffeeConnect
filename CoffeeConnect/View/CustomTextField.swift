//
//  CustomTextField.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 8.10.2023.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    init(placeholder: String, isSecure: Bool? = false) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.layer.borderWidth = 1
        self.layer.borderColor = AppColors.chinaCup.color.cgColor
        self.layer.cornerRadius = 5
        self.textAlignment = .left
        self.font = UIFont.systemFont(ofSize: 16)
        self.isSecureTextEntry = isSecure ?? false
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
