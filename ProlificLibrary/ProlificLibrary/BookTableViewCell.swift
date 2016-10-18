//
//  BookTableViewCell.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/18/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    //MARK: Public
    func configure(with book: Book) {
        bookTitleLabel.text = book.title
        bookAuthorLabel.text = book.author
    }

}
