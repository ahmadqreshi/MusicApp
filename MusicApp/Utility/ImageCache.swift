//
//  ImageCache.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 02/10/23.
//

import SwiftUI
import Foundation

class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var color: UIColor?
    private var url: String
    private var task: URLSessionDataTask?

    init(url: String) {
        self.url = url
        loadImage()
    }

    private func loadImage() {
        if let cachedImage = ImageCache.shared.get(forKey: url) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: url) else { return }

        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.image = image
                    self.color = image.averageColor
                    ImageCache.shared.set(image, forKey: self.url)
                }
            }
        }
        task?.resume()
    }
}
