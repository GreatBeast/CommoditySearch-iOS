//
//  WishCell.swift
//  Hw5
//
//  Created by 朱正楠 on 4/10/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit

class WishCell: UITableViewCell {

    @IBOutlet weak var wishImage: UIImageView!
    @IBOutlet weak var wishTitle: UILabel!
    @IBOutlet weak var wishPrice: UILabel!
    @IBOutlet weak var wishShip: UILabel!
    @IBOutlet weak var wishZip: UILabel!
    @IBOutlet weak var wishCond: UILabel!
    @IBOutlet weak var wishHidden: UILabel!
    func setItem(item: Item) {
        wishImage.contentMode = .scaleToFill
        wishImage.image = item.image
        wishTitle.text = item.title
        wishPrice.text = "$\(item.price)"
        wishShip.text = item.ship
        wishZip.text = item.zip
        wishCond.text = item.cond
        wishHidden.text = item.itemId
        wishHidden.isHidden = true
    }

}
