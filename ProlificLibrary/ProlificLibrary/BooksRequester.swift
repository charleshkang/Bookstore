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
    public func getBooks(`for` completion: ((Result<[Book]>) -> Void)?) {
        background {
            Alamofire.request(.GET, Constants.allBooksPath).responseJSON { (response) in
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
    
    public func delete(book: Book) {
        Alamofire.request(.DELETE, "\(Constants.allBooksPath)\(book.id!)").responseJSON { (response) in
            if let error = response.result.error {
                let alert = Alert()
                print("\(Constants.baseURLPath)\(book.id!)")
                alert.error("Something went wrong", title: "\(error)")
            }
        }
    }
    
    public func deleteAll(books: [Book], completion: (Response<AnyObject, NSError>) -> Void) {
        Alamofire.request(.DELETE, Constants.clearBooksPath).responseJSON { Void in
        }
    }
    
    public func post(book: Book, completion: (Response<AnyObject, NSError>) -> Void) {
        let newBookParams: [String: AnyObject] = [
            "author": book.author,
            "title": book.title,
            "categories": book.tags!,
            "publisher": book.publisher!
        ]
        Alamofire.request(.POST, Constants.allBooksPath,
            parameters: newBookParams,
            encoding: .JSON).responseJSON(completionHandler: completion)
    }
    
    public func update(book: Book) {
        let parameters: [String: AnyObject] = [
            "lastCheckedOutBy": book.lastCheckedOutBy,
            "lastCheckedOut" : book.lastCheckedOut
        ]
        
        Alamofire.request(.PUT, "\(Constants.allBooksPath)\(book.id!)", parameters: parameters).responseJSON { response in
            if let error = response.result.error {
                print("\(Constants.allBooksPath)\(book.id!)")
                print("error trying to update on /post/\(book.id!)")
            }
        }
        
    }
}