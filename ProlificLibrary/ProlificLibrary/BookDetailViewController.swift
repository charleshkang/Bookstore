//
//  BookDetailViewController.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit
import Social

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var lastCheckedOutLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    internal var allBooks = [Book]()
    internal var selectedIndex = 0
    internal var book: Book!
    internal var booksRequester = BooksRequester()
    internal var alertController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        checkoutButton.layer.cornerRadius = 5
    }
    
    private func setLabels() {
        titleLabel.text = book.title
        authorLabel.text = book.author
        
        publisherLabel.text = book.publisher.map { "Publisher: \($0)" } ?? "Publisher not available"
        tagsLabel.text = book.tags.map { "Tags: \($0)" } ?? "Tags not available"
        
        lastCheckedOutLabel.text = "\(book.lastCheckedOutBy) on \(book.lastCheckedOut)"
    }
    @IBAction func shareBookAction(sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "", message: "Share \(book.title)", preferredStyle: UIAlertControllerStyle.ActionSheet)
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
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                facebookComposeVC.setInitialText("I just checked out this cool book from the Prolific Library: \(self.titleLabel.text)")
                
                self.presentViewController(facebookComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("Please connect to your Facebook account.")
            }
        }
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(dismissAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func checkoutBookAction(sender: AnyObject) {
        alertController = UIAlertController(title: "Checkout \(book.title)", message: "Who's checking this out?", preferredStyle: .Alert)
        let checkoutAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
            let textField = self.alertController.textFields!.first
            textField?.placeholder = "Name"
            self.saveCheckOutName(textField!.text!)
        }
        
        let cancelAction = UIAlertAction(title: "Checkout", style: .Default, handler: nil)
        alertController.addAction(checkoutAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextFieldWithConfigurationHandler({ (textfield: UITextField) -> Void in
            
        })
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveCheckOutName(name: String) {
        book.lastCheckedOutBy = name
        booksRequester.update(book)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    private func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "Prolific Library", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}