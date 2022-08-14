//
//  PlayerViewModel.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 13.08.2022.
//

import SwiftUI
import Foundation
import AVFoundation

final class PlayerViewModel: ObservableObject {
    static let shared = PlayerViewModel()
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("error setting audio session")
        }
    }
    
    @Published var isPlaying = false
    @Published var currentlyPlaing = 0
    
    var playerQueue = AVQueuePlayer()
    
    func clearPlayerQueue() {
        playerQueue.removeAllItems()
    }
    
    func addItemToQueue(url source: String) {
        let urlHelper = ArchiveURLHelper(mp3: source)
        guard let safeURI = urlHelper.encodedURI else {
            return
        }
        guard let safeURL = URL(string: safeURI) else {
            return
        }
        playerQueue.insert(AVPlayerItem(url: safeURL), after: nil)
    }
    
    func toggleAudio() -> Bool {
        if playerQueue.isPlaying {
            playerQueue.pause()
            return false
        }
        playerQueue.play()
        return true
    }
    
    @objc private func playerDidFinishPlaying() {
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
