//
//  MetadataModel.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 04.09.2022.
//

import Foundation

enum MediaType {
    case texts
    case etree
    case audio
    case movies
    case software
    case image
    case data
    case web
    case collection
    case account
}

struct Metadata {
    var identifier: String = ""
    var title: String?
    var mediatype: String = "texts"
    var collection: String?
    var description: NSAttributedString?
    var subject: String?
    var licenseurl: String?
    var publicdate: Date = Date()
    var addeddate: Date = Date()
    var uploader: String = ""
    var updater: String?
    var updatedate: Date?
    var boxid: String?
    var backup_location: String?
    var creator: String?
    var notes: String?
}
