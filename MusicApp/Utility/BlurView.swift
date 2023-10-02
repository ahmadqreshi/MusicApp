//
//  BlurView.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 01/10/23.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    
    }
}

