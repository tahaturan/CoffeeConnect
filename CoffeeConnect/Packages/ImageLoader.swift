//
//  ImageLoader.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 12.10.2023.
//

import UIKit
import SDWebImage
import Lottie

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init() {}
    
    func loadImage(into imageView: UIImageView, from url: String, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        
        DispatchQueue.main.async {
            let animationView = LottieAnimationView(name: "Loading")
            animationView.frame = imageView.frame
            animationView.contentMode = .scaleAspectFill
            animationView.loopMode = .loop
            animationView.play()
            
            imageView.addSubview(animationView)
            imageView.sd_setImage(with: URL(string: url), placeholderImage: placeholder, options: .continueInBackground) { (image, error, cacheType, imageURL) in
                animationView.stop()
                animationView.removeFromSuperview()
                if let error = error {
                    print("Resim yüklenirken hata: \(error.localizedDescription)")
                }
                completion?(image)
            }
        }
    }
}

