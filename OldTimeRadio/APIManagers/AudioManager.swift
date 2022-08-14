//
//  AudioManager.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 02.08.2022.
//
import SwiftUI
import Foundation
import AVFoundation

final class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var playerItem: AVPlayerItem?
    var player: AVPlayer?

    private var currentAudioURL: String?
    private var currentChannelIndex = 0
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print("error setting audio session")
        }
    }
    
    func setCurrentTrack(url: String) {
        currentAudioURL = url
        preparePlayerItem()
    }
    
    func setSeek(offsetValue: Double) {
        playerItem?.seek(to: CMTime(seconds: offsetValue, preferredTimescale: 60000)) { compl in
            print("seek done: \(compl)")
        }
    }
    
    func toggleAudio(channelIndex: Int) -> Bool {
        if player?.currentItem != nil {
            player?.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        guard let safePlayer = player else {
            print("not safe player")
            return false
        }
        print("player is: \(safePlayer.isPlaying)")
        let isSamePlayer = channelIndex == self.currentChannelIndex
        print("channelIndex" ,channelIndex)
        print("self.currentChannelIndex", self.currentChannelIndex)
        self.currentChannelIndex = channelIndex
        if safePlayer.isPlaying || !isSamePlayer {
            safePlayer.pause()
            if !isSamePlayer {
                safePlayer.play()
                return true
            }
            return false
        }
        safePlayer.play()
        return true
    }
    
    func audioPlayerDidFinishPlaying(_ audio: AVAudioPlayer, successfully flag: Bool) {
        print("did finish playing")
    }
    
    private func preparePlayerItem() {
        guard let safeCurrentAudioURL = currentAudioURL else {
            print("no url provided")
            return
        }
        let encodedURI = safeCurrentAudioURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let safeEncodedURI = encodedURI else {
            print("cant encode: \(String(describing: encodedURI))")
            return
        }
        guard let safeURL = URL(string: safeEncodedURI) else {
            print(safeCurrentAudioURL)
            print("cant start url")
            return
        }
        playerItem = AVPlayerItem(url: safeURL)
    }
}
