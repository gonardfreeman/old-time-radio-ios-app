//
//  ChannelTabsView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 07.08.2022.
//

import SwiftUI

struct ChannelTabsView: View {
    @Namespace var namespace
    @Binding var currentTabIndex: Int
    @State var channels: [Channel]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTabIndex) {
                ForEach(Array(channels.enumerated()), id: \.offset) { index, element in
                    ChannelView(channelIndex: index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            NavigationBarView(
                currentTab: $currentTabIndex,
                channels: channels,
                namespace: namespace
            )
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
            namespace: _namespace,
            currentTabIndex: .constant(0),
            channels: [channel, channel1, channel2]
        )
    }
}
