//
//  ArchiveHelper.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 13.08.2022.
//

import Foundation


struct ArchiveURLHelper {
    var mp3URL: URL?
    var sourceURI: String
    
    init(mp3: String) {
        sourceURI = mp3
        mp3URL = URL(string: sourceURI)
    }
    
    var encodedURI: String? {
        get {
            guard let safeEncodedURI = sourceURI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("cant encode: \(sourceURI))")
                return nil
            }
            return safeEncodedURI
        }
    }
    
    func getMetaURI() -> String? {
        guard let safeURL = mp3URL else {
            return nil
        }
        let uri = safeURL.absoluteString
        let showURL = uri.replacingOccurrences(of: "/\(safeURL.lastPathComponent)", with: "")
        guard let safeShowURL = URL(string: showURL) else {
            return nil
        }
        let showName = safeShowURL.lastPathComponent
        return "\(safeShowURL.absoluteString)/\(showName)_meta.xml"
    }
    
    func getShowName() -> String? {
        guard let safeURL = mp3URL else {
            return nil
        }
        let uri = safeURL.absoluteString
        let showURL = uri.replacingOccurrences(of: "/\(safeURL.lastPathComponent)", with: "")
        guard let safeShowURL = URL(string: showURL) else {
            return nil
        }
        let showName = safeShowURL.lastPathComponent
        return showName
    }
}
