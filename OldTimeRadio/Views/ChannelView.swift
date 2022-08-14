//
//  ChannelView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 31.07.2022.
//

import SwiftUI

struct ChannelView: View {
    init(channelsViewModel: ChannelViewModel = .shared, channelIndex: Int = 0) {
        _channelsViewModel = StateObject(wrappedValue: channelsViewModel)
        self.channelIndex = channelIndex
    }
    @StateObject var channelsViewModel: ChannelViewModel

    var channelIndex = 0
    
    var body: some View {
        VStack {
            Spacer()
            if channelsViewModel.isLoading == false {
                if let show = channelsViewModel.channelPlaylist.list.first {
                    PlayerView(
                        show: show,
                        offset: channelsViewModel.channelPlaylist.initialOffset,
                        channelIndex: channelIndex
                    )
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("Border")),
                        alignment: .top
                    )
                }
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            channelsViewModel.getPlayChannelList(channelIndex: channelIndex)
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
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
        return ChannelView(channelsViewModel:channelViewModel)
    }
}
