//
//  MiniPlayerView.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 01/10/23.
//

import SwiftUI

struct PlayerView: View {
    
    
    @Namespace var animation
    @ObservedObject var viewModel: MainViewModel
    @State var bgColor: Color = .black
    
    var url: String {
        return "https://cms.samespace.com/assets/\(viewModel.selectedSong?.cover ?? "")"
    }
    
    var body: some View {
        ZStack {
            if viewModel.isExpand { // show full size player view
                MusicPlaybackView(animation: animation, viewModel: viewModel)
            } else {
                miniPlayerView // show mini player view
            }
        }
        .padding(.horizontal, viewModel.isExpand ? 0 : 18)
        .frame(maxHeight: viewModel.isExpand ? .infinity : 64)
        .background {
            blurBackgroundWithAverageColor // background of the whole view
        }
        .ignoresSafeArea()
        .opacity(viewModel.isSongPlayed ? 1 : 0)
        .onChange(of: viewModel.selectedSongId) { _ in // observe song id and call set up audio if value changes
            viewModel.setUpAudio()
        }
        .onChange(of: url) { newValue in // observe url of thumbnail and set bg color if value chamge
            self.bgColor = Color(uiColor: ImageLoader(url: newValue).image?.averageColor ?? .black)
        }
        
    }
    
    private var thumbnail: some View {
        RemoteImage(url: url)
            .frame(width: 48, height: 48)
            .cornerRadius(24)
    }
    
    
    private var miniPlayerView: some View {
        HStack(spacing: 0) {
            thumbnail
            
            Text(viewModel.selectedSong?.name ?? "")
                .font(.system(size: 17))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.leading, 16)
                .matchedGeometryEffect(id: "songTitle", in: animation)
            Spacer()
            
            Button {
                viewModel.isPlaying ? viewModel.stopAudio() : viewModel.playAudio()
            } label: {
                if viewModel.isPlaying {
                    ImageAsset.pauseIcon.set
                        .resizable()
                        .frame(width: 32, height: 32)
                        .aspectRatio(contentMode: .fit)
                } else {
                    ImageAsset.playIcon.set
                        .resizable()
                        .frame(width: 32, height: 32)
                        .aspectRatio(contentMode: .fit)
                }
            }
            .matchedGeometryEffect(id: "playPuaseButton", in: animation)
        }
    }
    
    private var blurBackgroundWithAverageColor: some View {
        ZStack {
            LinearGradient(colors: [bgColor, .black.opacity(0.5), .black], startPoint: .topTrailing, endPoint: .bottomLeading)
            BlurView()
                .onTapGesture {
                    withAnimation(.spring()) {
                        viewModel.isExpand.toggle()
                    }
                }
        }
    }
}

struct MiniPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(viewModel: MainViewModel())
    }
}
