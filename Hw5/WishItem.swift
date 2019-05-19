//
//  WishItem.swift
//  Hw5
//
//  Created by 朱正楠 on 4/10/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import Foundation
import SwiftyJSON

//class WishItem {
//    static var ct = 1
//    static var wishList:[Item] = []
//    static var wishJson:[JSON] = []
//    static func add(newItem: Item, newJson: JSON) {
//        wishList.append(newItem)
//        wishJson.append(newJson)
//    }
//    static func remove(index: Int) {
//        wishList.remove(at: index)
//        wishJson.remove(at: index)
//    }
//    static func remove(item: Item) {
//        for i in 0..<wishList.count {
//            if wishList[i].itemId == item.itemId {
//                wishList.remove(at: i)
//                wishJson.remove(at: i)
//                break
//            }
//        }
//    }
//    static func search(itemid: String) -> Bool {
//        for it in wishList {
//            if it.itemId == itemid {
//                return true
//            }
//        }
//        return false
//    }
//}

class WishItem {
    static var ct = 0
    static func add(newItem: Item, newJson: JSON) {
        var arr = UserDefaults.standard.stringArray(forKey: "saved")
        if arr == nil {
            UserDefaults.standard.set([newJson.rawString()!], forKey: "saved")
        } else {
            arr?.append(newJson.rawString()!)
            UserDefaults.standard.set(arr, forKey: "saved")
        }
    }
    static func remove(index: Int) {
        var arr = UserDefaults.standard.stringArray(forKey: "saved")
        if arr == nil {
            return
        }
        arr?.remove(at: index)
        UserDefaults.standard.set(arr, forKey: "saved")
    }
    static func remove(item: Item) {
        var arr = UserDefaults.standard.stringArray(forKey: "saved")
        if arr == nil {
            return
        }
        for i in 0..<arr!.count {
            let j = JSON(parseJSON: arr![i])
            if j["itemId"][0].stringValue == item.itemId {
                arr?.remove(at: i)
                break
            }
        }
        UserDefaults.standard.set(arr, forKey: "saved")
    }
    static func search(itemid: String) -> Bool {
        var arr = UserDefaults.standard.stringArray(forKey: "saved")
        if arr == nil {
            return false
        }
        for i in 0..<arr!.count {
            let j = JSON(parseJSON: arr![i])
            if j["itemId"][0].stringValue == itemid {
                return true
            }
        }
        return false
    }
    static func get() -> [JSON] {
        var arr = UserDefaults.standard.stringArray(forKey: "saved")
        if arr == nil {
            return []
        }
        var returnArr: [JSON] = []
        for i in 0..<arr!.count {
            let j = JSON(parseJSON: arr![i])
            returnArr.append(j)
        }
        return returnArr
    }
    static func get(index: Int) -> JSON {
        var arr = UserDefaults.standard.stringArray(forKey: "saved")
        let j = JSON(parseJSON: arr![index])
        return j
    }
}
