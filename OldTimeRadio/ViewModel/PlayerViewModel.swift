//
//  PlayerViewModel.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 13.08.2022.
//

import SwiftUI
import Foundation
import MediaPlayer
import AVFoundation

final class PlayerViewModel: ObservableObject {
    static var shared: PlayerViewModel = PlayerViewModel()
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("error setting audio session")
        }
    }
    
    @Published var showPlayer = false
    @Published var isPlaying = false
    @Published var currentlyPlaing = 0
    @Published var currentTitle: String?
    
    var playerQueue = AVQueuePlayer()
    
    func clearPlayerQueue() {
        playerQueue.removeAllItems()
    }
    
    func hasItemsToPlay() -> Bool {
        return playerQueue.currentItem != nil
    }
    
    func addItemToQueue(url source: String) {
        let urlHelper = ArchiveURLHelper(mp3: source)
        guard let safeURI = urlHelper.encodedURI else {
            return
        }
        guard let safeURL = URL(string: safeURI) else {
            return
        }
        if playerQueue.currentItem == nil {
            playerQueue.insert(AVPlayerItem(url: safeURL), after: nil)
        } else {
            playerQueue.insert(AVPlayerItem(url: safeURL), after: playerQueue.currentItem)
        }
    }
    
    func setSeek(offsetValue: Double) {
        playerQueue.currentItem?.seek(to: CMTime(seconds: offsetValue, preferredTimescale: 60000)) { _ in
            self.setupRemoteControls()
        }
    }
    
    func toggleAudio() {
        togglePlayerView()
        if playerQueue.isPlaying {
            playerQueue.pause()
            removeObserver()
        } else {
            playerQueue.play()
            setCurrentTitle()
            addObserver()
        }
        isPlaying.toggle()
    }
    
    func playAudio() {
        togglePlayerView()
        playerQueue.play()
        isPlaying = true
        setCurrentTitle()
        addObserver()
    }
    
    func pauseAudio() {
        playerQueue.pause()
        isPlaying = false
    }
    
    private func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = currentTitle

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func setupRemoteControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.playAudio()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            self.pauseAudio()
            return .success
        }
    }
    
    private func togglePlayerView() {
        if showPlayer == false {
            showPlayer = true
        }
    }
    
    private func setCurrentTitle() {
        guard let safeTitleName = ChannelViewModel.shared.channelPlaylist.list.first?.name else {
            return
        }
        currentTitle = safeTitleName
        setupNowPlaying()
    }
    
    @objc private func playerDidFinishPlaying() {
        if ChannelViewModel.shared.channelPlaylist.list.isEmpty {
            ChannelViewModel.shared.getCurrentChannelPlaylist { isDone in
                print("playerDidFinishPlaying and loaded: ", isDone)
                self.setCurrentTitle()
            }
            return
        }
        ChannelViewModel.shared.channelPlaylist.list.removeFirst()
        setCurrentTitle()
        print("done")
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerQueue.currentItem
        )
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}
