//
//  ImageLoader.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 12.10.2023.
//

import UIKit
import Kingfisher

class ImageLoader {

    static let shared = ImageLoader()

    private init() {}

    func loadImage(into imageView: UIImageView, from url: String, placeholder: UIImage? = nil, cornerRadius: CGFloat? = nil) {
        guard let url = URL(string: url) else {
            imageView.image = placeholder
            return
        }

        var options: [KingfisherOptionsInfoItem] = []

        if let radius = cornerRadius {
            let processor = DownsamplingImageProcessor(size: imageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: radius)
            options.append(.processor(processor))
        }

        options.append(.scaleFactor(UIScreen.main.scale))
        options.append(.transition(.fade(1)))
        options.append(.cacheOriginalImage)

        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options
        )
    }
}

