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
    static var shared: PlayerViewModel = PlayerViewModel()
    
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
        print(safeURL)
        if playerQueue.currentItem == nil {
            playerQueue.insert(AVPlayerItem(url: safeURL), after: nil)
        } else {
            playerQueue.insert(AVPlayerItem(url: safeURL), after: playerQueue.currentItem)
        }
    }
    
    func setSeek(offsetValue: Double) {
        playerQueue.currentItem?.seek(to: CMTime(seconds: offsetValue, preferredTimescale: 60000)) { compl in
            print("seek done: \(compl)")
        }
    }
    
    func toggleAudio() {
        if playerQueue.isPlaying {
            playerQueue.pause()
        } else {
            playerQueue.play()
        }
        isPlaying.toggle()
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
