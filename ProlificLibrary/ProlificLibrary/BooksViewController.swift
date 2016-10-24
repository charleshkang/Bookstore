//
//  BooksViewController.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UITableViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Private Properties
    private let bookRequester = BooksRequester()
    private var allBooks = [Book]()
    private let refreshControl = UIRefreshControl()
    
    // MARK:  View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Pulling new books!")
        refreshControl.addTarget(self, action: #selector(BooksViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    override func viewDidAppear(animated: Bool) {
        refreshBooks()
    }
    
    // MARK: Actions
    func refresh(sender: AnyObject) {
        bookRequester.getBooks { books in
            switch books {
            case.Success(let books):
                main {
                    self.allBooks = books
                    self.tableView.reloadData()
                }
            case.Failure(let error):
                let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        if refreshControl.refreshing {
            refreshControl.endRefreshing()
        }
    }
    private func refreshBooks() {
        bookRequester.getBooks { books in
            switch books {
            case.Success(let books):
                main {
                    self.allBooks = books
                    self.tableView.reloadData()
                }
            case.Failure(let error):
                let alertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    @IBAction private func clearAllBooks(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Clear all?", message: "Are you sure you want to clear all books?", preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { _ in
                self.bookRequester.deleteAll(self.allBooks) { _ in
                }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(BookDetailViewController) {
            if let detailVC = segue.destinationViewController as? BookDetailViewController {
                detailVC.allBooks = allBooks
                let indexPath: NSIndexPath = tableView.indexPathForSelectedRow!
                detailVC.book = allBooks[indexPath.row]
            }
        }
    }
    
}

//MARK: UITableViewDataSource Functions
extension BooksViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBooks.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constant.bookCellIdentifier, forIndexPath: indexPath) as! BookTableViewCell
        let book = allBooks[indexPath.row]
        cell.configure(with: book)
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            bookRequester.delete(allBooks[indexPath.row])
            allBooks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }
    }
    
}