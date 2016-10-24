//
//  BookDetailViewController.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import Social
import UIKit

class BookDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var lastCheckedOutLabel: UILabel!
    @IBOutlet private weak var tagsLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var checkoutButton: UIButton!
    
    // MARK: Internal Properties
    internal var allBooks = [Book]()
    internal var book: Book?
    
    // MARK: Private Properties
    private var selectedIndex = 0
    private var dateStamp = ""
    private var booksRequester = BooksRequester()
    private var alertController: UIAlertController?
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        dateStamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)
    }
    
    // MARK: Actions
    private func setLabels() {
        if let book = book {
            titleLabel.text = book.title
            authorLabel.text = book.author
            publisherLabel.text = book.publisher.map { "Publisher: \($0)" } ?? "Publisher not available"
            tagsLabel.text = book.tags.map { "Tags: \($0)" } ?? "No tags 🤔📘"
            if book.lastCheckedOutBy.isEmpty && book.lastCheckedOut.isEmpty {
                lastCheckedOutLabel.textColor = UIColor.greenColor()
                lastCheckedOutLabel.text = "Available for checkout"
            } else {
                lastCheckedOutLabel.textColor = UIColor.redColor()
                lastCheckedOutLabel.text = "Checked out by: \(book.lastCheckedOutBy) on \(book.lastCheckedOut)"
            }
        }
        checkoutButton.layer.cornerRadius = 5
    }
    @IBAction private func shareBookAction(sender: UIBarButtonItem) {
        if let bookTitle = book?.title {
            let actionSheet = UIAlertController(title: "", message: "Share \(bookTitle)", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                    let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    twitterComposeVC.setInitialText("I just checked out this cool book from the Prolific Library:\(self.titleLabel.text)")
                    self.presentViewController(twitterComposeVC, animated: true, completion: nil)
                }
                else {
                    self.showAlertMessage("Please connect to your Twitter account.")
                }
            }
            let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { _ in
                
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                    let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    facebookComposeVC.setInitialText("I just checked out this cool book from the Prolific Library: \(self.titleLabel.text)")
                    self.presentViewController(facebookComposeVC, animated: true, completion: nil)
                }
                else {
                    self.showAlertMessage("Please connect to your Facebook account.")
                }
            }
            let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { _ in
            }
            actionSheet.addAction(tweetAction)
            actionSheet.addAction(facebookPostAction)
            actionSheet.addAction(dismissAction)
            presentViewController(actionSheet, animated: true, completion: nil)
        }
    }
    @IBAction private func checkoutBookAction(sender: AnyObject) {
        if let bookTitle = book?.title {
        alertController = UIAlertController(title: "Checkout: \(bookTitle)", message: "Your Name", preferredStyle: .Alert)
        }
        let checkoutAction = UIAlertAction(title: "Checkout", style: .Default) { _ in
            if let textField = self.alertController?.textFields?.first?.text {
                self.saveBorrowersName(textField)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default , handler: nil)
        
        if let alertController = alertController {
            alertController.addAction(cancelAction)
            alertController.addAction(checkoutAction)
            alertController.addTextFieldWithConfigurationHandler(nil)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    private func saveBorrowersName(name: String) {
        book?.lastCheckedOutBy = name
        book?.lastCheckedOut = dateStamp
        if let borrowedBook = book {
            booksRequester.update(with: borrowedBook)
        }
        navigationController?.popToRootViewControllerAnimated(true)
    }
    private func showAlertMessage(message: String) {
        let alertController = UIAlertController(title: "Prolific Library", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}