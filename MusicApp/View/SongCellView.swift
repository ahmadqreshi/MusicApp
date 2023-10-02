//
//  SongCellView.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 26/09/23.
//
import UIKit
import SwiftUI

struct SongCellView: View {
    
    var song: SongDataModel
    
    var url: String {
        return "https://cms.samespace.com/assets/\(song.cover)"
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            thumbnail
            
            VStack(alignment: .leading) {
                Text(song.name.capitalized)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                
                Text(song.artist.capitalized)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
            
        }
        .padding(.vertical, 12)
        .background {
            Color.black
        }
    }
    
    
    private var thumbnail: some View {
        RemoteImage(url: url)
            .frame(width: 48, height: 48)
            .cornerRadius(24)
    }
}

struct SongCellView_Previews: PreviewProvider {
    static var previews: some View {
        SongCellView(song: SongDataModel(
            id: 0,
            status: "",
            sort: nil,
            userCreated: "",
            dateCreated: "",
            userUpdated: "",
            dateUpdated: "",
            name: "Say my name",
            artist: "ahmad qureshi",
            accent: "",
            cover: "",
            topTrack: true,
            url: "")
        )
    }
}
