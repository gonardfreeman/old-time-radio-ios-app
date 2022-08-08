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
        ContentView()
    }
}
