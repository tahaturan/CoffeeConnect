//
//  PageContentViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 14.10.2023.
//

import UIKit

protocol PagingViewDelegate: AnyObject {
    func didTapButton(at index: Int)
}

class PageContentViewController: UIViewController {
    var model: SpecialModel!
    var pageIndex: Int!
    var delegate: PagingViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 30
        view.backgroundColor = AppColors.special.color
        let titleLabel = UILabel()
        titleLabel.text = model.title
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }

        let subtitleLabel = UILabel()
        subtitleLabel.text = model.subtitle
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = .white
        view.addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(20)
        }

        let button = UIButton(type: .system)
        button.setTitle(model.buttonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
        buttonTapped(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        print("okey")
        delegate?.didTapButton(at: pageIndex)
    }
}
