//
//  NameValueCell.swift
//  Hw5
//
//  Created by 朱正楠 on 4/9/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit

class NameValueCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    func setNameValue(n:nameValue) {
        name.text = n.title
        value.text = n.detail
        name.numberOfLines = 0
        value.numberOfLines = 0
        name.sizeToFit()
        name.lineBreakMode = NSLineBreakMode.byWordWrapping
        value.sizeToFit()
        value.lineBreakMode = NSLineBreakMode.byWordWrapping
        
    }
}
