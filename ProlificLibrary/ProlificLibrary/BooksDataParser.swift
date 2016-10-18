//
//  BooksDataParser.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation
import SwiftyJSON

class BooksDataParser {
    func parseBookJSON(json: JSON) -> [Book] {
        let allBooks = json
        return allBooks.flatMap { (_, value) in
            guard
                let author = value["author"].string,
                categories = value["categories"].string,
                id = value["id"].int,
                title = value["title"].string,
                publisher = value["publisher"].string,
                url = value["url"].string,
                lastCheckedOut = value["lastCheckedOut"].string,
                lastCheckedOutBy = value["lastCheckedOutBy"].string
                else { return nil }
            
            return Book(author: author,
                categories: categories,
                id: id,
                title: title,
                publisher: publisher,
                url: url,
                lastCheckedOut: lastCheckedOut,
                lastCheckedOutBy: lastCheckedOutBy)
        }
    }
}