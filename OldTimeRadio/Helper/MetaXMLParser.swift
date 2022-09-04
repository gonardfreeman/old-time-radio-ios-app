//
//  MetaXMLParser.swift
//  OldTimeRadio
//
//  Created by Dima Bondarenko on 04.09.2022.
//

import Foundation

final class MetaXMLParser: XMLParser {
    var showMetadata: Metadata?
    
    private var textBuffer: String = ""
    
    override init(data: Data) {
        super.init(data: data)
        self.delegate = self
    }
    
    lazy var dateFormater: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.timeZone = .current
        df.locale = .current
        return df
    }()
    
    private func parseHTML(html: String) -> NSAttributedString? {
        let data = Data(html.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString
        }
        return nil
    }
    
}


extension MetaXMLParser: XMLParserDelegate {
    // when start tag is found
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "metadata":
            showMetadata = Metadata()
        case "identifier":
            textBuffer = ""
        case "uploader":
            textBuffer = ""
        case "addeddate":
            textBuffer = ""
        case "mediatype":
            textBuffer = ""
        case "title":
            textBuffer = ""
        case "description":
            textBuffer = ""
        case "subject":
            textBuffer = ""
        case "creator":
            textBuffer = ""
        case "licenseurl":
            textBuffer = ""
        case "publicdate":
            textBuffer = ""
        case "notes":
            textBuffer = ""
        case "backup_location":
            textBuffer = ""
        case "collection":
            textBuffer = ""
        case "external_metadata_update":
            textBuffer = ""
        default:
            print("Undefined element: ",elementName)
        }
    }
    
    // Called when closing tag (`</elementName>`) is found
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "identifier":
            showMetadata?.identifier = textBuffer
        case "uploader":
            showMetadata?.uploader = textBuffer
        case "addeddate":
            if let safeDate = dateFormater.date(from: textBuffer) {
                showMetadata?.addeddate = safeDate
            }
        case "mediatype":
            showMetadata?.uploader = textBuffer
        case "title":
            showMetadata?.title = textBuffer
        case "description":
            if let safeHTML = parseHTML(html: textBuffer) {
                showMetadata?.description = safeHTML
            }
        case "subject":
            showMetadata?.subject = textBuffer
        case "creator":
            showMetadata?.creator = textBuffer
        case "licenseurl":
            showMetadata?.licenseurl = textBuffer
        case "publicdate":
            if let safeDate = dateFormater.date(from: textBuffer) {
                showMetadata?.publicdate = safeDate
            }
        case "notes":
            showMetadata?.notes = textBuffer
        case "backup_location":
            showMetadata?.backup_location = textBuffer
        case "collection":
            showMetadata?.collection = textBuffer
        default:
            print("Undefined element: ",elementName)
        }
    }
    
    // Called when a character sequence is found
    // This may be called multiple times in a single element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        textBuffer += string
    }
    
    // Called when a CDATA block is found
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard let string = String(data: CDATABlock, encoding: .utf8) else {
            print("CDATA contains non-textual data, ignored")
            return
        }
        textBuffer += string
    }
    
    // For debugging
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        print("on:", parser.lineNumber, "at:", parser.columnNumber)
    }
}
