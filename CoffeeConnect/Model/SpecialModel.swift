//
//  SpecialModel.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 14.10.2023.
//

import Foundation

struct SpecialModel {
    let title: String
    let subtitle: String
    let buttonText: String
    static let dummyList = [
        SpecialModel(title: StringConstants.HomeView.secialOffer, subtitle: StringConstants.HomeView.discoverOurExclusive, buttonText: StringConstants.HomeView.seeMore),
        SpecialModel(title: StringConstants.HomeView.secialOffer, subtitle: StringConstants.HomeView.specialPrice, buttonText: StringConstants.HomeView.seeMore),
        SpecialModel(title: "Taha Turan", subtitle: "tahaaturann16@gmail.com", buttonText: "@tahaaturan")
    ]
}
