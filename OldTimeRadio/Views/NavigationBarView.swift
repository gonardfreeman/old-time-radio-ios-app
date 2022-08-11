//
//  NavigationBarView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 07.08.2022.
//

import SwiftUI

struct NavigationBarView: View {
    @Binding var currentTab: Int
    var channels: [Channel]
    var namespace: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(Array(zip(self.channels.indices, self.channels)), id: \.0) { index, channel in
                    NavBarItemView(
                        currentTab: $currentTab,
                        namespace: namespace,
                        index: index,
                        label: channel.name
                    )
                }
            }
            .padding(.horizontal)
        }
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("Border")),
            alignment: .bottom
        )
        .background(Color("BackgroundGray"))
        .frame(height: 50)
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var channels = [
        Channel(id: "future", name: "future", userChannel: false),
        Channel(id: "western", name: "western", userChannel: false),
        Channel(id: "horror", name: "horror", userChannel: false),
    ]
    
    @Namespace static var namespace
    
    static var previews: some View {
        NavigationBarView(
            currentTab: .constant(0),
            channels: channels,
            namespace: namespace
        )
    }
}
