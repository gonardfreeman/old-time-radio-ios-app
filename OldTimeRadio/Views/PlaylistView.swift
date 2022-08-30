//
//  PlaylistView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 28.08.2022.
//

import SwiftUI

struct PlaylistView: View {
    init(
        channelsViewModel: ChannelViewModel = .shared,
        playerViewModel: PlayerViewModel = .shared
    ) {
        _channelsViewModel = StateObject(wrappedValue: channelsViewModel)
        _playerViewModel = StateObject(wrappedValue: playerViewModel)
    }
    
    @StateObject var channelsViewModel: ChannelViewModel
    @StateObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        VStack {
            if let safeTitle = playerViewModel.currentTitle {
                Text(safeTitle)
                    .font(.largeTitle)
                    .padding()
                List(channelsViewModel.channelPlaylist.list) { item in
                    Text(item.name)
                }
            }
        }
        .padding(5)
        
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        let channelViewModel = ChannelViewModel.shared
        var channelPlaylist = ChanelPlaylist()
        channelPlaylist.initialOffset = 5.5
        channelPlaylist.list = [
            PlayListItem(
                url: "https://ia601306.us.archive.org/32/items/OTRR_Space_Patrol_Singles/Space_Patrol_53-08-08_045_Trouble_Aboard_the_Super_Nova.mp3",
                archivalUrl: "https://archive.org/download/OTRR_Space_Patrol_Singles/Space_Patrol_53-08-08_045_Trouble_Aboard_the_Super_Nova.mp3",
                name: "Space Patrol",
                length: 1761.67
            ),
            PlayListItem(
                url: "https://ia601306.us.archive.org/32/items/OTRR_Space_Patrol_Singles/Space_Patrol_53-08-08_045_Trouble_Aboard_the_Super_Nova.mp3",
                archivalUrl: "https://archive.org/download/OTRR_Space_Patrol_Singles/Space_Patrol_53-08-08_045_Trouble_Aboard_the_Super_Nova.mp3",
                name: "Commercial",
                length: 1761.67
            )
        ]
        channelViewModel.channelPlaylist = channelPlaylist
        PlayerViewModel.shared.currentTitle = "Space Patrol"
        return PlaylistView(
            channelsViewModel: channelViewModel,
            playerViewModel: PlayerViewModel.shared
        )
    }
}
