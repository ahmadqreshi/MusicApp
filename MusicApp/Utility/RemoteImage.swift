//
//  RemoteImage.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 02/10/23.
//

import SwiftUI
struct RemoteImage: View {
    @ObservedObject var imageLoader: ImageLoader

    init(url: String) {
        imageLoader = ImageLoader(url: url)
    }

    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            ProgressView()
                .tint(.white)
        }
    }
     
    func getAverageColor() -> Color {
        Color(uiColor: imageLoader.color ?? .blue)
    }
}
