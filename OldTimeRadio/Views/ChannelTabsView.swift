//
//  ChannelTabsView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 07.08.2022.
//

import SwiftUI

struct ChannelTabsView: View {
    init(
        channels: [Channel],
        channelsViewModel: ChannelViewModel = .shared
    ) {
        self.channels = channels
        _channelsViewModel = StateObject(wrappedValue: channelsViewModel)
    }
    
    @State var channels: [Channel]
    @StateObject var channelsViewModel: ChannelViewModel
    
    @State private var currentTabIndex = 0
    @Namespace private var namespace
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView(selection: $currentTabIndex) {
                ForEach(Array(channels.enumerated()), id: \.offset) { index, element in
                    ChannelView(channelIndex: index)
                }
            }
            .onChange(of: currentTabIndex) { curTabIndex in
                channelsViewModel.getPlayChannelList(channelIndex: curTabIndex)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            NavigationBarView(
                currentTab: $currentTabIndex,
                channels: channels,
                namespace: namespace
            )
        }
        .onAppear {
            channelsViewModel.getPlayChannelList(channelIndex: currentTabIndex)
        }
    }
}

struct ChannelTabsView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        let channel = Channel(id: "future", name: "future", userChannel: false)
        let channel1 = Channel(id: "western", name: "western", userChannel: false)
        let channel2 = Channel(id: "horror", name: "horror", userChannel: false)
        return ChannelTabsView(
            channels: [channel, channel1, channel2]
        )
    }
}
