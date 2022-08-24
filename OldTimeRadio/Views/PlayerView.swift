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
                playerViewModel.toggleAudio()
            }) {
                Image(systemName: playerViewModel.isPlaying ? "pause" : "play.circle")
                    .font(.largeTitle)
            }
            .frame(width: 40, height: 40)
            if let firstShow = channelViewModel.channelPlaylist.list.first {
                Text(firstShow.name)
                    .truncationMode(.tail)
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

        let shows = [
            PlayListItem(
                url: "https://ia800205.us.archive.org/20/items/SpaceCadet2/52-03-25_Mission_of_Mercy_001.MP3",
                archivalUrl: "https://ia800205.us.archive.org/20/items/SpaceCadet2/52-03-25_Mission_of_Mercy_001.MP3",
                name: "Space Cadet",
                length: 1200
            )
        ]
        var playlist = ChanelPlaylist()
        playlist.list = shows
        playlist.initialOffset = 1.5
        channelViewModel.channelPlaylist = playlist
        return PlayerView(
            playerViewModel: playerViewModel,
            channelViewModel: channelViewModel
        )
    }
}
