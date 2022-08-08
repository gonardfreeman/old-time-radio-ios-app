//
//  PlayerView.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 02.08.2022.
//

import SwiftUI

struct PlayerView: View {
    var show: PlayListItem
    var offset: Double
    
    @State var channelIndex = 0
    @State var isPlaying = false

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        isPlaying = AudioManager.shared.toggleAudio(channelIndex: channelIndex)
                    }) {
                        if isPlaying == true {
                            Image(systemName: "pause")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                        } else {
                            Image(systemName: "play.circle")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 40, height: 40)
                    Text(show.name)
                        .foregroundColor(.white)
                        .truncationMode(.tail)
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            AudioManager.shared.setCurrentTrack(url: show.url)
            AudioManager.shared.setSeek(offsetValue: offset)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(
            show: PlayListItem(
                url: "https://ia800205.us.archive.org/20/items/SpaceCadet2/52-03-25_Mission_of_Mercy_001.MP3",
                archivalUrl: "https://ia800205.us.archive.org/20/items/SpaceCadet2/52-03-25_Mission_of_Mercy_001.MP3",
                name: "Very long name test Very long name test Very long name test Very long name test Very long name test Very long name test Very long name test ",
                length: 5.5
            ),
            offset: 0.0
        )
    }
}
