//
//  BooksViewController.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let bookCellIdentifier = "bookCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Book1"
        cell.detailTextLabel?.text = "Charles"
        return cell
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return 1
    }

}
