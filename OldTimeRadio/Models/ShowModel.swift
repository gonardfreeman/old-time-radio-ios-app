//
//  ShowModel.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 31.07.2022.
//

import Foundation


struct Show: Identifiable, Decodable {
    var id = UUID()
    var channels: [String]
    var index: Int
    var isCommercial: Bool
    var name: String
    var shortName: String
    var descriptiveId: String
    var channelCode: String
}
