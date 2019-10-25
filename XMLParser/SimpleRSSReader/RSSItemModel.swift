//
//  RSSItemModel.swift
//  SimpleRSSReader
//
//  Created by sy on 2019/10/25.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

class RSSItemModel: CustomDebugStringConvertible {
    var title: String?
    var pubDate: String?
    var description: String?
    var debugDescription: String {
        return "{title = \(self.title ?? "nil"), pubDate = \(self.pubDate ?? "nil"), description = \(self.description ?? "nil")}"
    }
}
