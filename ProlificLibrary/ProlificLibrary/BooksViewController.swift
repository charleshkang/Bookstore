//
//  BooksViewController.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let bookRequester = BooksRequester()
    var allBooks = [Book]()
    let alert = Alert()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    // MARK: - Actions
    func refresh() {
        activityIndicator.startAnimating()
        bookRequester.getBooks { books in
            switch books {
            case.Success(let books):
                main {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.allBooks += books
                    self.tableView.reloadData()
                }
            case.Failure(let error):
                self.activityIndicator.stopAnimating()
                self.alert.error("\(error)", title: "Error")
            }
        }
    }
    
    @IBAction func clearAllBooks(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Clear all?", message: "Are you sure you want to clear all books?", preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action: UIAlertAction) -> Void in
            
            self.bookRequester.deleteAll(self.allBooks) { (_) in
                self.refresh()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension BooksViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBooks.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.bookCellIdentifier, forIndexPath: indexPath) as! BookTableViewCell
        let book = allBooks[indexPath.row]
        cell.bookAuthorLabel.text = book.author
        cell.bookTitleLabel.text = book.title
        cell.configure(with: book)
        return cell
    }
}