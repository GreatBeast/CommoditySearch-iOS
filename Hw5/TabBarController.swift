//
//  TabBarController.swift
//  Hw5
//
//  Created by 朱正楠 on 4/8/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Toast_Swift

class TabBarController: UITabBarController {

    var nowItem: JSON = []
    var usefulItem: Item!
    var itemDetail: JSON = []
    var fbButton: UIButton = UIButton(type: .custom)
    var wishButton: UIButton = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
    }

    func setupNav() {
//        fbButton = UIButton(type: .system)
        fbButton.setImage(UIImage(named: "facebook")?.withRenderingMode(.alwaysTemplate), for: .normal)
        fbButton.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
    
//        wishButton = UIButton(type: .system)
        wishButton.setImage(UIImage(named: "wishListEmpty")?.withRenderingMode(.alwaysTemplate), for: .normal)
        wishButton.setImage(UIImage(named: "wishListFilled")?.withRenderingMode(.alwaysTemplate), for: .selected)
//        wishButton.image(for: .selected)
        wishButton.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        wishButton.addTarget(self, action: #selector(touchWish(_:)), for: .touchUpInside)
        if WishItem.search(itemid: usefulItem.itemId) {
            wishButton.isSelected = true
        }
        
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: wishButton), UIBarButtonItem(customView: fbButton)]
        
    }
    
    @IBAction func touchWish(_ sender: UIButton) {
        if WishItem.search(itemid: usefulItem.itemId) {
            WishItem.remove(item: usefulItem)
            self.view.makeToast("\(usefulItem.title) was removed from wishList")
            sender.isSelected = false
        } else {
            WishItem.add(newItem: usefulItem, newJson: nowItem)
            self.view.makeToast("\(usefulItem.title) was added to the wishList")
            sender.isSelected = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
