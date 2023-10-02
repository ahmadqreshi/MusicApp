//
//  MusicPlayerViewModel.swift
//  MusicApp
//
//  Created by Ahmad Qureshi on 02/10/23.
//
import Combine
import AVFoundation

//MARK: - Music player Operations
class MusicPlayerViewModel: ObservableObject {
    
    @Published var player: AVPlayer? // used to play audio fethced from url
    @Published var isPlaying = false // used to indicate if song is playing or not
    @Published var totalTime: TimeInterval = 0.0 // Indicate total time of the song
    @Published var currentTime: TimeInterval = 0.0 // Indicate the current tiem of the song
    @Published var isSongLoading = false // used to show Loader until song starts playing from url
    @Published var urlError: Bool = false // used to show any error related to url of songs
    private var timeObserverToken: Any? // used to reuse time oberver set on song
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - Set up Audio
    func setupAudio(song: SongDataModel?){
        isSongLoading = true
        guard let song = song, let url = URL(string: song.url)
        else{
            
            self.stopAudio()
            self.urlError = true
            return
        }
        if player == nil {
            player = AVPlayer(url: url)
            addTimeObserver()
        } else {
            player?.replaceCurrentItem(with: AVPlayerItem(url: url))
            addTimeObserver()
        }
        
        playAudio()
        
        player?.currentItem?.publisher(for: \.status)
            .sink { [weak self] status in
                guard let self = self else { return }
                
                if status == .readyToPlay {
                    self.isSongLoading = false
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Play AUdio
    func playAudio(){
        player?.play()
        isPlaying = true
    }
    
    //MARK: - Pause/Stop Audio
    func stopAudio() {
        player?.pause()
        isPlaying = false
    }
    
    //MARK: - Add observer on current time and total time
    private func addTimeObserver() {
        guard let player = player else { return }
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        let timeInterval = CMTime(seconds: 1.0, preferredTimescale: 1)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: timeInterval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
            if let playerItem = player.currentItem {
                self.totalTime = playerItem.duration.seconds.isNaN ? 0.0 : playerItem.duration.seconds
            }
        }
    }
    
    //MARK: - convert time to required format from interval
    func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
}
