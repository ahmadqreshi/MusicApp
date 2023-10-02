//
//  MusicPlaybackView.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 28/09/23.
//
import UIKit
import SwiftUI

struct MusicPlaybackView: View {
    
    var animation: Namespace.ID
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear.ignoresSafeArea()  // dismiss view on tap
                .onTapGesture {
                    withAnimation(.spring()) {
                        viewModel.isExpand.toggle()
                    }
                }
            VStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 40, height: 4)
                    .padding(.bottom, 64)
                    .padding(.top, 50)
                
                
                
                ScrollViewReader { scrollProxy in // used to scroll to disired image in the list
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 16) {
                            ForEach(viewModel.songsList) { song in
                                
                                RemoteImage(url: "https://cms.samespace.com/assets/\(song.cover)")
                                    .frame(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.width/1.2)
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(6)
                                    .id(song.id)
                                
                            }
                        }
                    }
                    
                    .onAppear {
                        scrollProxy.scrollTo(viewModel.selectedSongId, anchor: .center)
                    }
                    .onChange(of: viewModel.selectedSongId) { newValue in
                        scrollProxy.scrollTo(newValue, anchor: .center)
                    }
                    
                }
                .disabled(true)
                .gesture(DragGesture() // Swipe Gesture on the Corousel
                    .onEnded{ val in
                        if val.translation.width > 150 {
                            if let index = viewModel.songsList.firstIndex(where: { $0.id == viewModel.selectedSongId }) {
                                if index - 1 >= 0 {
                                    withAnimation(.linear) {
                                        viewModel.selectedSongId = viewModel.songsList[index - 1].id
                                    }
                                }
                            }
                        } else if val.translation.width < -150 {
                            if let index = viewModel.songsList.firstIndex(where: { $0.id == viewModel.selectedSongId }) {
                                if index + 1 < viewModel.songsList.count {
                                    withAnimation(.linear) {
                                        viewModel.selectedSongId = viewModel.songsList[index + 1].id
                                    }
                                }
                            }
                        }
                    }
                )
                
                VStack(spacing: 0) {
                    Text(viewModel.selectedSong?.name ?? "Song Name")
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .matchedGeometryEffect(id: "songTitle", in: animation)
                    
                    Text(viewModel.selectedSong?.artist ?? "Artist")
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.vertical, 40)
                
                VStack(spacing: 12) {
                    ProgressView(value: viewModel.currentTime, total: viewModel.totalTime)
                        .progressViewStyle(.linear)
                        .tint(.white)
                    
                    
                    HStack {
                        Text(viewModel.timeString(time: viewModel.currentTime))
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        Text(viewModel.timeString(time: viewModel.totalTime))
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            .foregroundColor(.white.opacity(0.5))
                        
                    }
                    
                }
                .padding(.horizontal, 20)
                
                HStack {
                    Spacer()
                    
                    prevButton
                    Spacer()
                    pausePlayButton
                        .matchedGeometryEffect(id: "playPuaseButton", in: animation)
                    Spacer()
                    nextButton
                    Spacer()
                }
                .padding(.top,10)
            }
            
            
        }
        .overlay {
            if viewModel.isSongLoading { // show loader view untill song starts playing
                LoaderView()
            }
        }
        .alert(isPresented: $viewModel.urlError) { // show alert if face any error
            Alert(title: Text("Playback unavailable"),
                  message: Text("URL Error!"),
                  dismissButton: .default(Text("Ok"), action: {
                viewModel.isSongLoading = false
            })
            )
        }
        .onChange(of: viewModel.currentTime) { newValue in  // change the song if it is completed
            if newValue == viewModel.totalTime {
                if let index = viewModel.songsList.firstIndex(where: { $0.id == viewModel.selectedSongId }) {
                    if index + 1 < viewModel.songsList.count {
                        withAnimation(.linear) {
                            viewModel.selectedSongId = viewModel.songsList[index + 1].id
                        }
                    }
                }
            }
        }
    }
    
    
    private var prevButton: some View {
        Button {
            if let index = viewModel.songsList.firstIndex(where: { $0.id == viewModel.selectedSongId }) {
                if index - 1 >= 0 {
                    withAnimation(.linear) {
                        viewModel.selectedSongId = viewModel.songsList[index - 1].id
                    }
                }
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            ImageAsset.prevIcon.set
        }
        
    }
    
    private var pausePlayButton: some View {
        Button {
            viewModel.isPlaying ? viewModel.stopAudio() : viewModel.playAudio()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            if viewModel.isPlaying {
                ImageAsset.pauseIcon.set
                    .resizable()
                    .frame(width: 64, height: 64)
                    .aspectRatio(contentMode: .fit)
            } else {
                ImageAsset.playIcon.set
                    .resizable()
                    .frame(width: 64, height: 64)
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    
    private var nextButton: some View {
        Button {
            if let index = viewModel.songsList.firstIndex(where: { $0.id == viewModel.selectedSongId }) {
                if index + 1 < viewModel.songsList.count {
                    withAnimation(.linear) {
                        viewModel.selectedSongId = viewModel.songsList[index + 1].id
                    }
                }
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            ImageAsset.nextIcon.set
        }
        
    }
}

struct MusicPlaybackView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPlaybackView(animation: Namespace().wrappedValue, viewModel: MainViewModel())
    }
}
