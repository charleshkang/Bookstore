//
//  UITextField+EmptyTextFields.swift
//  ProlificLibrary
//
//  Created by Charles Kang on 10/20/16.
//  Copyright © 2016 Charles Kang. All rights reserved.
//

import UIKit

extension UITextField {
    var isNilOrEmpty: Bool {
        return self.text?.isEmpty ?? true
    }
}