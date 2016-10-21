//
//  AddBookTableViewController.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/19/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

public class AddBookTableViewController: UITableViewController {
    
    // MARK: IBOutlets
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var publisherTextField: UITextField!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var authorTextField: UITextField!
    
    // MARK: Private Properties
    private let booksRequester = BooksRequester()
    
    // MARK: Actions
    @IBAction private func cancelAction(sender: UIBarButtonItem) {
        guard authorTextField.isNilOrEmpty &&
            titleTextField.isNilOrEmpty &&
            publisherTextField.isNilOrEmpty &&
            categoryTextField.isNilOrEmpty else {
                let alertController = UIAlertController(title: "Discard Book Info?", message: "Your changes will not be saved.", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Destructive , handler: { _ in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                alertController.addAction(OKAction)
                alertController.addAction(cancelAction)
                presentViewController(alertController, animated: true, completion: nil)
                return
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction private func doneAction(sender: UIBarButtonItem) {
        if titleTextField.text == "" || authorTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Title or Author", message: "Please fill in the required fields", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            addNewBook()
        }
    }
    private func addNewBook() {
        let book = Book(author: authorTextField.text!,
                        tags: categoryTextField.text!,
                        id: nil,
                        title: titleTextField.text!,
                        publisher: publisherTextField.text,
                        url: nil,
                        lastCheckedOut: "",
                        lastCheckedOutBy: "")
        booksRequester.post(book, completion: { (response) in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
}

extension AddBookTableViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if titleTextField.text == "" || authorTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Title or Author", message: "Please fill in the required fields.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            addNewBook()        }
        textField.resignFirstResponder()
        return true
    }
    
}