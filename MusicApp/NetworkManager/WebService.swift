//
//  ApiService.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 26/09/23.
//

import UIKit
import Combine

class WebService: NSObject {
    private override init() {}
    
    static let shared = WebService()
    
    private var cancellables = Set<AnyCancellable>()
    
    func request<T: Decodable>(endpoint: Endpoint, id: Int? = nil, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = endpoint.url else {
                return promise(.failure(NetworkError.invalidURL))
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = endpoint.method
            URLSession.shared.dataTaskPublisher(for: urlRequest)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: {  data in
                    print(data)
                    promise(.success(data)
                    ) })
                .store(in: &self.cancellables)
        }
    }
}
