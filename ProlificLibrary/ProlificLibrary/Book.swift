//
//  Book.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation

public struct Book {
    let author: String
    let category: String
    let id: Int?
    let title: String
    let publisher: String?
    let url: String?
    var lastCheckedOut: String?
    var lastCheckedOutBy: String?
    
    // MARK: Lifecycle
    init(author: String,
         category: String,
         id: Int?,
         title: String,
         publisher: String?,
         url: String?,
         lastCheckedOut: String?,
         lastCheckedOutBy: String?) {
        
        self.author = author
        self.category = category
        self.id = id
        self.title = title
        self.publisher = publisher
        self.url = url
        self.lastCheckedOut = lastCheckedOut
        self.lastCheckedOutBy = lastCheckedOutBy
    }
}