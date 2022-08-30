//
//  ChannelView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 31.07.2022.
//

import SwiftUI

struct ChannelView: View {
    init(
        playerViewModel: PlayerViewModel = .shared,
        channelsViewModel: ChannelViewModel = .shared,
        channelIndex: Int = 0
        
    ) {
        _playerViewModel = StateObject(wrappedValue: playerViewModel)
        _channelsViewModel = StateObject(wrappedValue: channelsViewModel)
        self.channelIndex = channelIndex
    }
    
    @StateObject var playerViewModel: PlayerViewModel
    @StateObject var channelsViewModel: ChannelViewModel

    var channelIndex = 0
    
    var body: some View {
        VStack {
            if channelsViewModel.isLoading == true {
                Text("Loading...")
            } else {
                if let currentChannel = channelsViewModel.currentChannel {
                    Button {
                        playerViewModel.clearPlayerQueue()
                        playerViewModel.setUpNext(items: channelsViewModel.channelPlaylist.list)
                        channelsViewModel.channelPlaylist.list.forEach { show in
                            playerViewModel.addItemToQueue(url: show.url)
                        }
                        playerViewModel.setSeek(
                            offsetValue: channelsViewModel.channelPlaylist.initialOffset
                        )
                        playerViewModel.playAudio()
                        
                    } label: {
                        HStack {
                            Text("Tune in to: \(currentChannel.name.capitalized)")
                                .font(.largeTitle)
                            Image(systemName: "radio")
                                .font(.largeTitle)
                        }
                    }
                } else {
                    Text("Channel not loaded")
                }
            }
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        let playerViewModel = PlayerViewModel()
        let channelViewModel = ChannelViewModel()
        var channelPlaylist = ChanelPlaylist()
        channelPlaylist.initialOffset = 0.0
        channelPlaylist.chanel = Channel(
            id: "future",
            name: "future",
            userChannel: false
        )
        channelPlaylist.list = [
            PlayListItem(
                url: "https://ia902208.us.archive.org/19/items/OTRR_Dimension_X_Singles/Dimension_X_1951-08-23__45_UntitledStory.mp3",
                archivalUrl: "https://ia802208.us.archive.org/19/items/OTRR_Dimension_X_Singles/Dimension_X_1951-08-23__45_UntitledStory.mp3",
                name: "Dimension X 45 - Untitled Story [1951-08-23]",
                length: 1804.82
            )
        ]
        channelViewModel.channelPlaylist = channelPlaylist
        channelViewModel.channels = [
            Channel(id: "future", name: "future", userChannel: false)
        ]
        channelViewModel.isLoading = false
        return ChannelView(
            playerViewModel: playerViewModel,
            channelsViewModel: channelViewModel
        )
    }
}
