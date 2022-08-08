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
        ZStack {
            Image(
                channelsViewModel.channels[channelIndex].name
            )
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            VStack {
                if channelsViewModel.isLoading == false {
                    if let show = channelsViewModel.channelPlaylist.list.first {
                        PlayerView(
                            show: show,
                            offset: channelsViewModel.channelPlaylist.initialOffset,
                            channelIndex: channelIndex
                        )
                    }
                } else {
                    Text("Loading...")
                        .foregroundColor(.black)
                }
            }
            .padding()
        }
        .onAppear {
            channelsViewModel.getPlayChannelList(channelIndex: channelIndex)
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView()
    }
}
