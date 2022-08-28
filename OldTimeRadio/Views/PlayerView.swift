//
//  PlayerView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 02.08.2022.
//

import SwiftUI

struct PlayerView: View {
    init(
        playerViewModel: PlayerViewModel = .shared
    ) {
        _playerViewModel = StateObject(wrappedValue: playerViewModel)
    }
    
    
    @StateObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                if playerViewModel.hasItemsToPlay() {
                    playerViewModel.toggleAudio()
                }
            }) {
                Image(systemName: playerViewModel.isPlaying ? "pause" : "play.circle")
                    .font(.largeTitle)
            }
            .frame(width: 40, height: 40)
            if let currentTitle = playerViewModel.currentTitle {
                Text(currentTitle)
                    .truncationMode(.tail)
            } else {
                Text("Please select channel")
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(Color("BackgroundGray"))
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let playerViewModel = PlayerViewModel()
        return PlayerView(
            playerViewModel: playerViewModel
        )
    }
}
