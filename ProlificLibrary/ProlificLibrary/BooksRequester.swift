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
            Alamofire.request(.GET, "\(Constants.baseURL)\(Constants.allBooksPath)").responseJSON { (response) in
                if let _ = response.result.value {
                    let json = JSON(data: response.data!)
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
                    main { completion?(.Success(allBooks)) }
                }
            }
        }
    }
    
    public func delete(book: Book) {
        Alamofire.request(.DELETE, "\(Constants.baseURL)\(book.id)").responseJSON { (response) in
            if let error = response.result.error {
                let alert = Alert()
                alert.error("Something went wrong", title: "\(error)")
            }
        }
    }
    
    public func deleteAll(books: [Book], `for` completion: (Response<AnyObject, NSError>) -> Void) {
        Alamofire.request(.DELETE, "\(Constants.baseURL)\(Constants.clearBooksPath)").responseJSON { response in
            if let error = response.result.error {
                let alert = Alert()
                alert.error("Something went wrong", title: "\(error)")
            }
        }
    }
    
    public func post(book: Book, `for` completion: (Response<AnyObject, NSError>) -> Void) {
        
    }
    
    public func update(book: Book) {
        
    }
    
    
}