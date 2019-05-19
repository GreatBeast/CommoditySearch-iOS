//
//  Item.swift
//  Hw5
//
//  Created by 朱正楠 on 4/8/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import Foundation
import UIKit

class Item: NSObject {
    var image: UIImage
    var title: String
    var price: String
    var ship: String
    var zip: String
    var cond: String
    var itemId: String
    init(image: UIImage, title: String, price: String, ship: String, zip: String, cond: String, itemId: String) {
        self.image = image
        self.title = title
        self.price = price
        self.ship = ship
        self.zip = zip
        self.cond = cond
        self.itemId = itemId
    }
}

class SimilarItem {
    var index: Int
    var image: UIImage
    var title: String
    var ship: Float
    var price: Float
    var day: Int
    var url: String
    init(index: Int, image: UIImage, title: String, ship: Float, price: Float, day: Int, url: String) {
        self.index = index
        self.image = image
        self.title = title
        self.price = price
        self.ship = ship
        self.day = day
        self.url = url
    }
}
