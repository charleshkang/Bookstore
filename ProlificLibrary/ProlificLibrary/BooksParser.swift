//
//  BooksParser.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/25/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation
import SwiftyJSON

class BooksParser {
    
    func parseBookJSON(json: JSON) -> [Book] {
        let allBooks = json
        
        return allBooks.flatMap { (_, result)  in
            let url = result["url"].string
            let lastCheckedOut = result["lastCheckedOut"].stringValue
            let lastCheckedOutBy = result["lastCheckedOutBy"].stringValue
            let id = result["id"].int
            let publisher = result["publisher"].string
            let categories = result["categories"].string
            guard
                let title = result["title"].string,
                author = result["author"].string
                else { return nil }
            
            return Book(author: author, tags: categories, id: id, title: title, publisher: publisher, url: url, lastCheckedOut: lastCheckedOut, lastCheckedOutBy: lastCheckedOutBy)
        }
    }
}