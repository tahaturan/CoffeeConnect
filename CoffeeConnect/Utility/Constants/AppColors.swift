//
//  AppColors.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 8.10.2023.
//

import Foundation
import UIKit

enum AppColors {
    case chinaCup
    case vanillaMocha
    case curiousChipmunk
    case ambassadorBlue
    
    var color: UIColor {
        switch self {
        
        case .chinaCup:
            return UIColor(red: 0.97, green: 0.94, blue: 0.90, alpha: 1.00)
        case .vanillaMocha:
            return UIColor(red: 0.92, green: 0.86, blue: 0.78, alpha: 1.00)
        case .curiousChipmunk:
            return UIColor(red: 0.85, green: 0.75, blue: 0.64, alpha: 1.00)
        case .ambassadorBlue:
            return UIColor(red: 0.06, green: 0.17, blue: 0.34, alpha: 1.00)
        }
    }
}