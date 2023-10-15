//
//  AppError.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import Foundation

enum AppError: Error {
    case unknown
    case authenticationFailed
    case profileImageUploadFailed
    case profileImageURLNotFound
    case userDocumentNotFound
    case dataEncodingFailed
    case dataDecodingFailed
    case custom(String)
    case dataFetchingFailed

    var localizedDescription: String {
        switch self {
        case .unknown:
            return StringConstants.Errors.unknown
        case .authenticationFailed:
            return StringConstants.Errors.authenticationFailed
        case .profileImageUploadFailed:
            return StringConstants.Errors.imageUploadFailed
        case .profileImageURLNotFound:
            return StringConstants.Errors.imageURLNotFound
        case .userDocumentNotFound:
            return StringConstants.Errors.userDocumentNotFound
        case .dataEncodingFailed:
            return StringConstants.Errors.dataEncodingFailed
        case .dataDecodingFailed:
            return StringConstants.Errors.dataDecodingFailed
        case .custom(let message):
            return message
        case .dataFetchingFailed:
            return StringConstants.Errors.dataFetchingFailed
        }
    }
}
