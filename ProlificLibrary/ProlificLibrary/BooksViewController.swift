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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        refresh()
    }
    
    func refresh() {
        bookRequester.getBooks { books -> Void in
            self.allBooks = books
            self.tableView.reloadData()
            
        }
        
        // MARK: - Actions
        //        private func fetchBooks() {
        //            activityIndicator.startAnimating()
        //            bookRequester.getBooks { void in
        //                self.activityIndicator.stopAnimating()
        //                self.activityIndicator.hidden = true
        //                self.tableView.reloadData()
        
        //            main {
        //                self.activityIndicator.stopAnimating()
        //                self.activityIndicator.hidden = true
        //                self.tableView.reloadData()
        //            }
        //            case.Failure(let error):
        //                self.activityIndicator.stopAnimating()
        //
        //                let errorAlert = UIAlertController(title: "Error",
        //                    message: "\(error)",
        //                    preferredStyle: UIAlertControllerStyle.Alert)
        //                errorAlert.addAction(UIAlertAction(title: "OK",
        //                    style: UIAlertActionStyle.Default,
        //                    handler: nil))
        //                self.presentViewController(errorAlert, animated: true, completion: nil)
        //            }
        //        }
        //            }
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