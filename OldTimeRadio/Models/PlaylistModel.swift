//
//  PlaylistModel.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 31.07.2022.
//

import Foundation

struct PlayListItem: Decodable {
    var url: String
    var archivalUrl: String
    var name: String
    var length: Double
    var commercial: Bool?
}

struct ChanelPlaylist: Decodable  {
    init() {
        initialOffset = 0.0
        list = [PlayListItem]()
    }
    
    var initialOffset: Double
    var list: [PlayListItem]
    var chanel: Channel?
}
