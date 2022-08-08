//
//  ChannelModel.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 31.07.2022.
//

import Foundation


struct Channel: Identifiable, Decodable {
    var id: String
    var name: String
    var userChannel: Bool
}
