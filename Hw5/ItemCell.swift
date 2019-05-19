//
//  ItemCell.swift
//  Hw5
//
//  Created by 朱正楠 on 4/8/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemShipping: UILabel!
    @IBOutlet weak var itemZip: UILabel!
    @IBOutlet weak var itemCond: UILabel!
    @IBOutlet weak var btnWish: UIButton!
    
    func setItem(item: Item) {
        itemImage.contentMode = .scaleToFill
        itemImage.image = item.image
        itemTitle.text = item.title
        itemPrice.text = "$\(item.price)"
        itemShipping.text = item.ship
        itemZip.text = item.zip
        itemCond.text = item.cond
        btnWish.setImage(UIImage(named: "wishListFilled"), for: .selected)
        if WishItem.search(itemid: item.itemId) {
            btnWish.isSelected = true
        } else {
            btnWish.isSelected = false
        }
    }
}
