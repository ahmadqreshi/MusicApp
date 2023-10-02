//
//  SongListViewModel.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 26/09/23.
//
import Combine
import Foundation
import AVFoundation


enum TabOption {
    case forYou
    case topTracks
}

//MARK: - Contains the operations to fetch data from API
class MainViewModel:  MusicPlayerViewModel {
    
    @Published var songsList: [SongDataModel] = [] //All Songs
    @Published var topTracksList: [SongDataModel] = [] //Filter Songs based on top track variable
    @Published var showLoader: Bool = false // used to show custom loader on main screen
    @Published var selectedTab: TabOption = .forYou // used to differentiate between different tabs
    @Published var selectedSongId: Int = Int() // used to store the song id of the current song
    @Published var isExpand: Bool = false // used to show and expand mini player view or Music playback View
    
    
    
    var isSongPlayed: Bool { // used to indicate if song is Ever played
        !(selectedSongId == Int())
    }

    var selectedSong: SongDataModel? { // find selected song from selected ID
        songsList.first(where: { $0.id == selectedSongId})
    }
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    override init() {
        super.init()
        getSongsData()
    }
    
    
    //MARK: - API Call
    private func getSongsData() {
        showLoader = true
        WebService.shared.request(endpoint: .getSongsData, type: DataResponseModel.self)
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] (response) in
                guard let strongSelf = self else { return }
                strongSelf.songsList = response.data
                strongSelf.topTracksList = response.data.filter( { $0.topTrack })
                strongSelf.showLoader = false
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Set up Audio with selected song
    func setUpAudio() {
        setupAudio(song: selectedSong)
        
    }
}
