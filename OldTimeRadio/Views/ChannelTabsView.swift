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
                        .padding(.top, 60)
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
    private static let htmlString = """
    Space Patrol debuted on March 9, 1950 as a fifteen minute show on KECA-TV in Los Angeles, a little over 6 months before the Tom Corbett series began. The first half hour Saturday show began on December 30, 1950 and lasted until February 26, 1955. The fifteen minute shows were kinescoped for broadcast outside of the Los Angles area within a week or two of the California broadcast. In June of 1952 the Saturday shows were broadcast live from coast to coast and the daily 15 minute shows continued to be broadcast on the West Coast for at least three years after the coast to coast syndication had ended.

    The shows creator, Mike Moser, was a Navy veteran of World War II who had trained hurricane-hunter squadrons. In a 1952 Time article, Mr. Moser said the show was inspired while he was flying over the Pacific and thinking about the universe. He wanted kids to grow up with the same sense of wonder for the future he had experienced during his childhood with Flash Gordon and Buck Rogers.

    The show was also broadcast twice a week on the radio during the run of the TV show, resulting in a hectic schedule for its crew. A week of Space Patrol involved 5 local 15-minute TV shows, 2 radio shows, and the half hour Saturday network show. An estimated total of 210 Saturday half-hour shows, 200 radio programs and at least 900 fifteen minute TV shows were broadcast during the run of the show. The shows ran consecutively from March 9, 1950 till July 2, 1954.

    In addition to the TV &amp;amp; Radio shows, Space Patrol appeared in a short two issue comic book run by Ziff Davis (Summer 1952 &amp;amp; November 1952). The stories were scripted by Phil Evans with both covers drawn by Norman Saunders with some of the interior artwork done by Bernie Krigstein. Norman Saunders artwork for Ziff Davis had a great sense of wonder reminiscent of the great pulp SF covers of the 30's,40's and 50's.

    Now join us for a "High Adventure in the wild reaches of space.... missions of daring in the name of interplanetary justice. Travel into the future with Buzz Corry... Commander-in-Chief of ... the

    S-P-A-C-E ...... P-A-T-R-O-L...
    """
    private static func parseHTML(html: String) -> NSAttributedString? {
        let data = Data(html.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString
        }
        return nil
    }
    
    @Namespace static var namespace
    static var previews: some View {
        let channel = Channel(id: "future", name: "future", userChannel: false)
        let channel1 = Channel(id: "western", name: "western", userChannel: false)
        let channel2 = Channel(id: "horror", name: "horror", userChannel: false)
        ChannelViewModel.shared.currentChannel = channel
        ChannelViewModel.shared.showMetadata = Metadata(
            identifier: "123",
            title: "Space Patrol",
            mediatype: "audio",
            collection: "oldtimeradio",
            description: parseHTML(html: htmlString),
            subject: "",
            licenseurl: "",
            publicdate: Date(),
            addeddate: Date(),
            uploader: "",
            updater: "",
            updatedate: Date(),
            boxid: "",
            backup_location: "",
            creator: "",
            notes: ""
        )
        return ChannelTabsView(
            channels: [channel, channel1, channel2]
        )
    }
}
