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
    let categories: String
    let id: Int
    let title: String
    let publisher: String?
    let url: String
    let lastCheckedOut: String?
    let lastCheckedOutBy: String?
    
    // MARK: Lifecycle
    init(author: String,
         categories: String,
         id: Int,
         title: String,
         publisher: String?,
         url: String,
         lastCheckedOut: String?,
         lastCheckedOutBy: String?) {
        
        self.author = author
        self.categories = categories
        self.id = id
        self.title = title
        self.publisher = publisher
        self.url = url
        self.lastCheckedOut = lastCheckedOut
        self.lastCheckedOutBy = lastCheckedOutBy
    }
}