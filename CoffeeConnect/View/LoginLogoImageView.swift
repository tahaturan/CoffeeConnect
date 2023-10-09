//
//  LoginLogoImageView.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 9.10.2023.
//

import UIKit

class LoginLogoImageView: UIImageView {
    init(imageName: String) {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        image = UIImage(named: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
