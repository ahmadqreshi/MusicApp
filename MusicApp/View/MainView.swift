//
//  ContentView.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 26/09/23.
//

import SwiftUI


struct MainView: View {
    
    @StateObject private var viewModel: MainViewModel = MainViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ZStack {
                switch viewModel.selectedTab {
                case .forYou:
                    SongsListView(songsList: $viewModel.songsList, selectedSongId: $viewModel.selectedSongId, isExpand: $viewModel.isExpand)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .leading))
                        
                case .topTracks:
                    SongsListView(songsList: $viewModel.topTracksList, selectedSongId: $viewModel.selectedSongId, isExpand: $viewModel.isExpand)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .trailing))
                }
                
            }
            .padding(.bottom, viewModel.isSongPlayed ? 124 : 60)
            .animation(.linear, value: viewModel.selectedTab)
            .gesture(DragGesture()
                .onEnded{ val in
                    if val.translation.width > 150 {
                        viewModel.selectedTab = .forYou
                    } else if val.translation.width < -150 {
                        viewModel.selectedTab = .topTracks
                    }
                }
            )
        }
        .overlay(alignment: .bottom) {
            ZStack {
                VStack(spacing: 0) {
                    PlayerView(viewModel: viewModel)
                    if !viewModel.isExpand {
                        bottomTabView
                    }
                }
                .animation(.spring(), value: viewModel.isExpand)
            }
        }
        .overlay {
            if viewModel.showLoader {
                LoaderView()
            }
        }
        
    }
    
    private var bottomTabView: some View {
        HStack {
            Spacer()
            forYouButton
            Spacer()
            topTracksButton
            Spacer()
        }
        .padding(.top, 30)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(LinearGradient(colors: [.black.opacity(viewModel.isSongPlayed ? 1 : 0.1), .black, .black, .black], startPoint: .top, endPoint: .bottom))
        }
    }
    
    
    private var forYouButton: some View {
        Button {
            viewModel.selectedTab = .forYou
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            VStack {
                Text("For You")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(viewModel.selectedTab == .forYou ? .white : .white.opacity(0.5))
                
                Circle()
                    .foregroundColor(viewModel.selectedTab == .forYou ? .white : .clear)
                    .frame(width: 6, height: 6)
            }
            .frame(maxWidth: .infinity)
        }

    }
    
    private var topTracksButton: some View {
        Button {
            viewModel.selectedTab = .topTracks
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            VStack {
                Text("Top Tracks")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(viewModel.selectedTab == .topTracks ? .white : .white.opacity(0.5))
                
                Circle()
                    .foregroundColor(viewModel.selectedTab == .topTracks ? .white : .clear)
                    .frame(width: 6, height: 6)
            }
            .frame(maxWidth: .infinity)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
