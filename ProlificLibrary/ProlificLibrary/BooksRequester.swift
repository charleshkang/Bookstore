//
//  BooksRequester.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

public func main(function: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), function)
}
public func background(function: () -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), function)
}
public final class BooksRequester {
    
    public func getBooks(`for` completion: ((Result<[Book]>) -> Void)?) {
        background {
            Alamofire.request(.GET, Constant.allBooksPath).responseJSON { (response) in
                if let _ = response.result.value {
                    let json = JSON(data: response.data!)
                    var allBooks = [Book]()
                    for (_, value) in json {
                        let rawPublisher = value["publisher"].string
                        let publisher = rawPublisher!.isEmpty ? nil : rawPublisher
                        let rawTags = value["categories"].string
                        let tags = rawTags!.isEmpty ? nil : rawTags
                        allBooks.append(Book(author: value["author"].stringValue,
                            tags: tags,
                            id: value["id"].intValue,
                            title: value["title"].stringValue,
                            publisher: publisher,
                            url: value["url"].stringValue,
                            lastCheckedOut: value["lastCheckedOut"].stringValue,
                            lastCheckedOutBy: value["lastCheckedOutBy"].stringValue))
                    }
                    main { completion?(.Success(allBooks)) }
                }
            }
        }
    }
    public func post(book: Book, completion: (Response<AnyObject, NSError>) -> Void) {
        let newBookParams: [String: AnyObject] = [
            "author": book.author,
            "title": book.title,
            "categories": book.tags!,
            "publisher": book.publisher!
        ]
        Alamofire.request(.POST, Constant.allBooksPath,
            parameters: newBookParams,
            encoding: .JSON).responseJSON(completionHandler: completion)
    }
    public func update(book: Book) {
        let parameters: [String: AnyObject] = [
            "lastCheckedOutBy": book.lastCheckedOutBy,
            "lastCheckedOut": book.lastCheckedOut
        ]
        Alamofire.request(.PUT, "\(Constant.allBooksPath)\(book.id!)", parameters: parameters).responseJSON { response in
            if let error = response.result.error {
                let alert = Alert()
                alert.error("\(error)", title: "Error")
            }
        }
    }
    public func delete(book: Book) {
        Alamofire.request(.DELETE, "\(Constant.allBooksPath)\(book.id!)").responseJSON { (response) in
            if let error = response.result.error {
                let alert = Alert()
                alert.error("\(error)", title: "Error")
            }
        }
    }
    public func deleteAll(books: [Book], completion: (Response<AnyObject, NSError>) -> Void) {
        Alamofire.request(.DELETE, Constant.clearBooksPath).responseJSON { Void in
        }
    }
    
}