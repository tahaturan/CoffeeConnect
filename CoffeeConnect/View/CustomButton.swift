//
//  CustomButton.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 8.10.2023.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    init(title: String, color: UIColor? = AppColors.ambassadorBlue.color, titleColor: UIColor? = .white) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = color
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = AppStyleConstants.cornerRadius
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
