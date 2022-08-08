//
//  ChannelViewModel.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 04.08.2022.
//

import Foundation

final class ChannelViewModel: ObservableObject {
    static var shared = ChannelViewModel()
    
    @Published var channels: [Channel] = []
    @Published var shows:[Show] = []
    @Published var channelPlaylist = ChanelPlaylist()
    
    @Published var isLoading = false
    
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = DataManager()) {
        self.dataService = dataService
        Task.init {
            getChannels()
        }
    }
    
    func getChannels() {
        isLoading = true
        dataService.getChannels { resp in
            self.channels = resp
            self.isLoading = false
        }
    }
    
    func getShows() {
        isLoading = true
        dataService.getShows { resp in
            self.shows = resp
            self.isLoading = false
        }
    }
    
    func getPlayChannelList(channelIndex: Int) {
        isLoading = true
        if channels.indices.contains(channelIndex) {
            dataService.getPlayChannelList(chanelName: channels[channelIndex].name) { resp in
                self.channelPlaylist = resp
                self.isLoading = false
            }
        } else {
            isLoading = false
            return
        }
    }
}
