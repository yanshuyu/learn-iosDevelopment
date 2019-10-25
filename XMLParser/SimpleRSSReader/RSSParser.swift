//
//  RSSParser.swift
//  SimpleRSSReader
//
//  Created by sy on 2019/10/25.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

class RSSParse: NSObject {
    enum RSSTag: String {
        case itemTag = "item"
        case titleTag = "title"
        case pubDateTag = "pubDate"
        case descTag = "description"
    }
    
    private var shulodBeginRSSItem = false
    private var currentElementName = ""
    private var currentTitle = ""
    private var currentPubDate = ""
    private var currentDesc = ""
    private var parsedReslut = [RSSItemModel]()
    private var parseError: Error?
    private var completionHandler: (([RSSItemModel], Error?) -> Void)?
    
    func parse(data: Data, completionHandler: (([RSSItemModel], Error?) -> Void)? ) {
        self.completionHandler = completionHandler
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    private func reset() {
        self.shulodBeginRSSItem = false
        self.currentElementName = ""
        self.currentTitle = ""
        self.currentPubDate = ""
        self.currentDesc = ""
        self.parseError = nil
        self.parsedReslut = []
        self.completionHandler = nil
    }
}


extension RSSParse: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentElementName = elementName
        if elementName == RSSTag.itemTag.rawValue {
            self.shulodBeginRSSItem = true
            self.currentTitle = ""
            self.currentPubDate = ""
            self.currentDesc = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !self.shulodBeginRSSItem {
            return
        }
        
        switch currentElementName {
        case RSSTag.titleTag.rawValue:
            self.currentTitle += string
            break
        case RSSTag.pubDateTag.rawValue:
            self.currentPubDate += string
            break
        case RSSTag.descTag.rawValue:
            self.currentDesc += string
            break
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == RSSTag.itemTag.rawValue {
            let newItem = RSSItemModel()
            newItem.title = self.currentTitle
            newItem.pubDate = self.currentPubDate
            newItem.description = self.currentDesc
            self.parsedReslut.append(newItem)
            self.shulodBeginRSSItem = false
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.completionHandler?(self.parsedReslut, nil)
        reset()
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        reset()
        self.completionHandler?([], parseError)
    }
}
