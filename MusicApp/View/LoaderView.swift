//
//  LoaderView.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 02/10/23.
//

import Foundation
import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .controlSize(.large)
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
    
}
