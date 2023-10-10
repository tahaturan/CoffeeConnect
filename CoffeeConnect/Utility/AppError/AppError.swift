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

    var localizedDescription: String {
        switch self {
        case .unknown:
            return StringConstants.ErrorMessageString.unknownString
        case .authenticationFailed:
            return StringConstants.ErrorMessageString.authenticationFailed
        case .profileImageUploadFailed:
            return StringConstants.ErrorMessageString.profileImageUploadFailedString
        case .profileImageURLNotFound:
            return StringConstants.ErrorMessageString.profileImageURLNotFound
        case .userDocumentNotFound:
            return StringConstants.ErrorMessageString.userDocumentNotFound
        case .dataEncodingFailed:
            return StringConstants.ErrorMessageString.dataEncodingFailed
        case .dataDecodingFailed:
            return StringConstants.ErrorMessageString.dataDecodingFailed
        case .custom(let message):
            return message
        }
    }
}
