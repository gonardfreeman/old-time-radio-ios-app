//
//  ContentView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 31.07.2022.
//

import SwiftUI

struct ContentView: View {
    init(channelsViewModel: ChannelViewModel = .shared) {
        _channelsViewModel = StateObject(wrappedValue: channelsViewModel)
    }
    
    @State var currentTabIndex = 0
    @StateObject var channelsViewModel: ChannelViewModel
    
    var body: some View {
        ZStack {
            if channelsViewModel.channels.isEmpty {
                Text("Loading")
            } else {
                ChannelTabsView(
                    currentTabIndex: $currentTabIndex,
                    channels: channelsViewModel.channels
                )
                .onChange(of: currentTabIndex) { value in
                    channelsViewModel.getPlayChannelList(channelIndex: value)
                }
            }
        }
        .onAppear(perform: channelsViewModel.getChannels)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let channelViewModel = ChannelViewModel()
        let channels = [
            Channel(id: "future", name: "future", userChannel: false),
            Channel(id: "western", name: "western", userChannel: false)
        ]
        var channelPlaylist = ChanelPlaylist()
        channelPlaylist.initialOffset = 5.5
        channelPlaylist.list = [
            PlayListItem(
                url: "https://ia601306.us.archive.org/32/items/OTRR_Space_Patrol_Singles/Space_Patrol_53-08-08_045_Trouble_Aboard_the_Super_Nova.mp3",
                archivalUrl: "https://archive.org/download/OTRR_Space_Patrol_Singles/Space_Patrol_53-08-08_045_Trouble_Aboard_the_Super_Nova.mp3",
                name: "Space Patrol - Trouble Aboard the Super Nova", length: 1761.67
            )
        ]
        channelViewModel.channelPlaylist = channelPlaylist
        channelViewModel.channels = channels
        return ContentView(channelsViewModel: channelViewModel)
    }
}
