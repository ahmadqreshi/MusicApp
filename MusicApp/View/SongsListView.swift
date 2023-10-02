//
//  SongsForYouView.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 26/09/23.
//

import SwiftUI

struct SongsListView: View {
    @Binding var songsList: [SongDataModel]
    @Binding var selectedSongId: Int
    @Binding var isExpand: Bool
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(songsList) { song in
                   SongCellView(song: song)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isExpand = true
                                selectedSongId = song.id
                            }
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct SongsListView_Previews: PreviewProvider {
    static var previews: some View {
        SongsListView(songsList: .constant([]), selectedSongId: .constant(0), isExpand: .constant(false))
    }
}
