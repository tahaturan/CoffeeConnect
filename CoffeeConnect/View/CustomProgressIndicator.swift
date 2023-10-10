//
//  CustomProgressIndicator.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import UIKit
import SnapKit

class CustomProgressIndicator: UIView {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.ambassadorBlue.color.withAlphaComponent(0.7)
        view.layer.cornerRadius = AppStyle.defaultCornerRadius
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(backgroundView)
        addSubview(activityIndicator)
        
        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func show(on view: UIView) {
        self.frame = view.bounds
        view.addSubview(self)
        activityIndicator.startAnimating()
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        self.removeFromSuperview()
    }
}
