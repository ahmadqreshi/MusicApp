//
//  NetworkError.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 26/09/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}
