//
//  PlayerExtensions.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 04.08.2022.
//

import AVKit

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

