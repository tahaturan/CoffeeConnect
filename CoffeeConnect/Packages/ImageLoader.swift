//
//  ImageLoader.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 12.10.2023.
//

import UIKit
import SDWebImage

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init() {}
    
    func loadImage(into imageView: UIImageView, from url: String, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        imageView.sd_setImage(with: URL(string: url), placeholderImage: placeholder, options: .continueInBackground) { (image, error, cacheType, imageURL) in
            if let error = error {
                print("Resim yüklenirken hata: \(error.localizedDescription)")
            }
            completion?(image)
        }
    }
}

