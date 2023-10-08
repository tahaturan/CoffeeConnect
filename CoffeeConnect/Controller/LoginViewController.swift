//
//  ViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 8.10.2023.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    //MARK: - Properties
    private let emailTextField: CustomTextField = CustomTextField(placeholder: "E-mail")
    private let passwordTextField: CustomTextField = CustomTextField(placeholder: "Password", isSecure: true)
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
      
    }
    
}

//MARK: - Helpers
extension LoginViewController {
    func setupUI() {
        view.addSubview(emailTextField)
    }
}


