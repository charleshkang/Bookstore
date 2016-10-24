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

func main(function: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), function)
}
func background(function: () -> Void) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), function)
}

class BooksRequester {
    
    func getBooks(`for` completion: ((Result<[Book]>) -> Void)?) {
        var allBooks = [Book]()
        background {
            Alamofire.request(.GET, Constant.allBooksPath).responseJSON { (response) in
                if let json = response.data {
                    for (_, value) in JSON(data: json) {
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
                    guard let statusCode = response.response?.statusCode  else {
                        main { completion?(.Failure(.UnexpectedError)) }
                        return
                    }
                    guard statusCode == SuccessStatusCode.OK.rawValue else {
                        print(statusCode)
                        main { completion?(.Failure(RequestError(code: statusCode))) }
                        return
                    }
                    
                    main { completion?(.Success(allBooks)) }
                }
            }
        }
    }
    func post(book: Book, completion: (Response<AnyObject, NSError>) -> Void) {
        let newBookParams: [String: AnyObject] = [
            "author": book.author,
            "title": book.title,
            "categories": book.tags ?? "",
            "publisher": book.publisher ?? ""
        ]
        Alamofire.request(.POST, Constant.allBooksPath,
            parameters: newBookParams,
            encoding: .JSON).responseJSON(completionHandler: completion)
    }
    func update(with book: Book) {
        let parameters: [String: AnyObject] = [
            "lastCheckedOutBy": book.lastCheckedOutBy,
            "lastCheckedOut": book.lastCheckedOut
        ]
        if let id = book.id {
            Alamofire.request(.PUT, "\(Constant.allBooksPath)\(id)", parameters: parameters).responseJSON { (response) in
                if let error = response.result.error {
                    Alert.error("\(error)", title: "Error")
                }
            }
        }
    }
    func delete(book: Book) {
        if let id = book.id {
            Alamofire.request(.DELETE, "\(Constant.allBooksPath)\(id)").responseJSON { (response) in
                if let error = response.result.error {
                    Alert.error("\(error)", title: "Error")
                }
            }
        }
    }
    func deleteAll(books: [Book], completion: (Response<AnyObject, NSError>) -> Void) {
        Alamofire.request(.DELETE, Constant.clearBooksPath).responseJSON { _ in
            // Originally had error handling here as well, but it was causing some issues on Alamofire's end. I think it is due to me not updating the tableview immediately after sending a delete request. 
        }
    }
    
}