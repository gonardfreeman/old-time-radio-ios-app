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
    @Published var currentChannel: Channel?
    @Published var showMetadata: Metadata?
    
    @Published var showData = false
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
        showData = false
        if channels.indices.contains(channelIndex) {
            dataService.getPlayChannelList(chanelName: channels[channelIndex].name) { resp in
                self.channelPlaylist = resp
                self.showData = self.channelPlaylist.list.isEmpty == false
                self.currentChannel = self.channels[channelIndex]
                self.getCurrentShowInfo()
                self.isLoading = false
            }
        } else {
            isLoading = false
            return
        }
    }
    
    func getCurrentChannelPlaylist(completion: @escaping (Bool) -> Void) {
        isLoading = true
        showData = false
        guard let safeChannel = currentChannel else {
            print("no channel??")
            completion(false)
            isLoading = false
            return
        }
        dataService.getPlayChannelList(chanelName: safeChannel.name) { resp in
            self.channelPlaylist = resp
            self.showData = self.channelPlaylist.list.isEmpty == false
            completion(true)
            self.isLoading = false
        }
    }
    
    func getCurrentShowInfo() {
        if let safeURL = channelPlaylist.list.first?.url {
            let helper = ArchiveURLHelper(mp3: safeURL)
            guard let safeMetaURL = helper.getMetaURI() else {
                return
            }
            dataService.getShowMetadata(showURL: safeMetaURL) { resp in
                self.showMetadata = resp
            }
        }
    }
}
