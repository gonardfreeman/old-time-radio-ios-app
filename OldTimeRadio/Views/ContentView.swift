//
//  ContentView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 31.07.2022.
//

import SwiftUI

struct ContentView: View {
    init(
        channelsViewModel: ChannelViewModel = .shared,
        playerViewModel: PlayerViewModel = .shared
    ) {
        _channelsViewModel = StateObject(wrappedValue: channelsViewModel)
        _playerViewModel = StateObject(wrappedValue: playerViewModel)
    }
    
    @State var isShowingSheet = false
    @StateObject var channelsViewModel: ChannelViewModel
    @StateObject var playerViewModel: PlayerViewModel
    
    
    var body: some View {
        ZStack {
            if channelsViewModel.channels.isEmpty {
                Text("Loading")
            } else {
                VStack {
                    ChannelTabsView(
                        channels: channelsViewModel.channels
                    )
                    Spacer()
                    if playerViewModel.showPlayer {
                        PlayerView()
                            .cornerRadius(10)
                            .padding([.leading, .trailing], 20)
                            .sheet(isPresented: $isShowingSheet) {
                                PlaylistView()
                            }
                            .onTapGesture {
                                isShowingSheet.toggle()
                            }
                        Spacer()
                    }
                }
            }
        }
        .onAppear(perform: channelsViewModel.getChannels)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let channelViewModel = ChannelViewModel.shared
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
        PlayerViewModel.shared.showPlayer = true
        return ContentView(
            channelsViewModel: channelViewModel,
            playerViewModel: PlayerViewModel.shared
        )
    }
}
