//
//  BooksRequester.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public func main(function: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), function)
}

public func background(function: () -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), function)
}

public class BooksRequester {
    //    private let booksParser = BooksDataParser()
    
    func getBooks(`for` completion: ([Book]) -> [Book]) {
        background {
            Alamofire.request(.GET, Constants.baseURL).responseJSON { (response) in
                if let _ = response.result.value {
                    let json = JSON(data: response.data!)
                    //                    let books = self.booksParser.parseBookJSON(json)
                    var allBooks = [Book]()
                    
                    for (_, value) in json {
                        allBooks.append(Book(author: value["author"].stringValue,
                            categories: value["categories"].stringValue,
                            id: value["id"].intValue,
                            title: value["title"].stringValue,
                            publisher: value["publisher"].stringValue,
                            url: value["url"].stringValue,
                            lastCheckedOut: value["lastCheckedOut"].string,
                            lastCheckedOutBy: value["lastCheckedOutBy"].string))
                    }
                    main { completion(allBooks) }
                }
            }
        }
    }
}