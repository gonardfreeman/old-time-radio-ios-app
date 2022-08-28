//
//  PlaylistModel.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 31.07.2022.
//

import Foundation

struct PlayListItem: Decodable,  Identifiable {
    var id: UUID
    var url: String
    var archivalUrl: String
    var name: String
    var length: Double
    var commercial: Bool?
    
    init(from decoder: Decoder) throws {
        print("here")
        self.id = UUID()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decode(String.self, forKey: .url)
        self.archivalUrl = try values.decode(String.self, forKey: .archivalUrl)
        self.name = try values.decode(String.self, forKey: .name)
        self.length = try values.decode(Double.self, forKey: .length)
        self.commercial = try? values.decode(Bool.self, forKey: .commercial)
    }
    
    init(url: String, archivalUrl: String, name: String, length: Double) {
        self.id = UUID()
        self.url = url
        self.archivalUrl = archivalUrl
        self.name = name
        self.length = length
    }
    
    init(url: String, archivalUrl: String, name: String, length: Double, commercial: Bool) {
        self.id = UUID()
        self.url = url
        self.archivalUrl = archivalUrl
        self.name = name
        self.length = length
        self.commercial = commercial
    }
    
    private enum CodingKeys : String, CodingKey { case url, archivalUrl, name, length, commercial }
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
