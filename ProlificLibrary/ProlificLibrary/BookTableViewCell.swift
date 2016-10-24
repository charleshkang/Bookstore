//
//  BookTableViewCell.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet private weak var bookTitleLabel: UILabel!
    @IBOutlet private weak var bookAuthorLabel: UILabel!
    @IBOutlet private weak var bookTagsLabel: UILabel!
    
    // MARK: Actions
    func configure(with book: Book) {
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = book.author
        bookTagsLabel.text = book.tags.map { "Tags: \($0)" } ?? "No tags 🤔📘"
    }
    
}