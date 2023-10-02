//
//  Endpoints.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 26/09/23.
//

import Foundation

enum Endpoint {
    case getSongsData
}

extension Endpoint {
    var url: URL? {
        let urlString = "https://cms.samespace.com/\(intermediate)/\(urlEndpoint)"
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    var method: String {
        switch self {
        case .getSongsData:
            return "GET"
        }
    }
    
    var urlEndpoint: String {
        switch self {
        case .getSongsData:
            return "songs"
        }
    }
    
    var intermediate: String {
        switch self {
        case .getSongsData:
            return "items"
        }
    }
}
