//
//  AddBookTableViewController.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/19/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

class AddBookTableViewController: UITableViewController {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    
    let booksRequester = BooksRequester()
    
    
    @IBAction func doneAction(sender: UIBarButtonItem) {
        if titleTextField.text == "" || authorTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Title or Author", message: "Please fill in the required fields", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            let book = Book(author: authorTextField.text!,
                            category: categoryTextField.text!,
                            id: nil,
                            title: titleTextField.text!,
                            publisher: publisherTextField.text,
                            url: nil,
                            lastCheckedOut: nil,
                            lastCheckedOutBy: nil)
            booksRequester.post(book, completion: { (response) in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AddBookTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if titleTextField.text == "" || authorTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Title or Author", message: "Please fill in the required fields", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            let book = Book(author: authorTextField.text!,
                            category: categoryTextField.text!,
                            id: nil,
                            title: titleTextField.text!,
                            publisher: publisherTextField.text,
                            url: nil,
                            lastCheckedOut: nil,
                            lastCheckedOutBy: nil)
            booksRequester.post(book, completion: { (response) in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
        textField.resignFirstResponder()
        return true
    }
}