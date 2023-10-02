//
//  ImageAsset.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 01/10/23.
//

import SwiftUI

enum ImageAsset: String {
    case pauseIcon
    case playIcon
    case prevIcon
    case nextIcon
    var set: Image {
        return Image(self.rawValue)
    }
}
