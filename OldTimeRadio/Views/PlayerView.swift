//
//  PlayerView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 02.08.2022.
//

import SwiftUI

struct PlayerView: View {
    init(
        playerViewModel: PlayerViewModel = .shared,
        channelViewModel: ChannelViewModel = .shared
    ) {
        _playerViewModel = StateObject(wrappedValue: playerViewModel)
        _channelViewModel = StateObject(wrappedValue: channelViewModel)
    }
    
    
    @StateObject var playerViewModel: PlayerViewModel
    @StateObject var channelViewModel: ChannelViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                if playerViewModel.hasItemsToPlay() {
                    playerViewModel.toggleAudio()
                } else {
                    
                }
            }) {
                Image(systemName: playerViewModel.isPlaying ? "pause" : "play.circle")
                    .font(.largeTitle)
            }
            .frame(width: 40, height: 40)
            if let firstShow = channelViewModel.channelPlaylist.list.first {
                Text(firstShow.name)
                    .truncationMode(.tail)
            } else {
                Text("Loading...")
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(Color("BackgroundGray"))
        .onAppear {
            channelViewModel.channelPlaylist.list.forEach { show in
                playerViewModel.addItemToQueue(url: show.url)
            }
            playerViewModel.setSeek(
                offsetValue: channelViewModel.channelPlaylist.initialOffset
            )
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let playerViewModel = PlayerViewModel()
        let channelViewModel = ChannelViewModel()
        var channelPlaylist = ChanelPlaylist()
        channelPlaylist.list = [
            PlayListItem(
                url: "https://ia902208.us.archive.org/19/items/OTRR_Dimension_X_Singles/Dimension_X_1951-08-23__45_UntitledStory.mp3",
                archivalUrl: "https://ia802208.us.archive.org/19/items/OTRR_Dimension_X_Singles/Dimension_X_1951-08-23__45_UntitledStory.mp3",
                name: "Dimension X 45 - Untitled Story [1951-08-23]",
                length: 1804.82
            )
        ]
        channelPlaylist.initialOffset = 1.5
        channelViewModel.channelPlaylist = channelPlaylist
        return PlayerView(
            playerViewModel: playerViewModel,
            channelViewModel: channelViewModel
        )
    }
}
