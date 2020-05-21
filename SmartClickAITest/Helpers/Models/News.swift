//
//  News.swift
//  SmartClickAITest
//
//  Created by Sos Avetyan on 5/21/20.
//  Copyright © 2020 Sos Avetyan. All rights reserved.
//

import Foundation

struct Item: Codable {
    var item : News
}


struct News: Codable {
    var title: String
    var link: String
    var updatedAt: String
    var pubDate: String
    var StoryImage: String
    var category: String
    var description: String
    var fullimage: String
    var source: String
    var localImageURL: String?
}
