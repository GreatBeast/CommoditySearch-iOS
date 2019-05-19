//
//  WishListController.swift
//  Hw5
//
//  Created by 朱正楠 on 4/10/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift

class WishListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var wishTable: UITableView!
    var myIndex = 0
    var itemArr: [Item] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemArr = createItems(data: WishItem.get())
        self.wishTable.reloadData()
        createLabel()
        self.wishTable.delegate = self
        self.wishTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.itemArr = createItems(data: WishItem.get())
        self.wishTable.reloadData()
        createLabel()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction:UITableViewRowAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: {action,indexPath in
            self.view.makeToast("\(self.itemArr[indexPath.row].title) was removed from wishList")
            WishItem.remove(index: indexPath.row)
            self.itemArr = self.createItems(data: WishItem.get())
            tableView.reloadData()
            self.createLabel()
        })
        let actions = [deleteRowAction]
        return actions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.itemArr[indexPath.row]
        let cell = wishTable.dequeueReusableCell(withIdentifier: "wishCell") as! WishCell
        cell.setItem(item: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myIndex = indexPath.row
        let parent = self.parent as! ViewController
        parent.usefulItemWish = self.itemArr[self.myIndex]
        parent.nowItemWish = WishItem.get(index: self.myIndex)
        parent.performSegue(withIdentifier: "wishDetail", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "wishDetail" {
//            print("NB")
//            let vc = segue.destination as! TabBarController
//            vc.usefulItem = WishItem.wishList[self.myIndex]
//        }
//    }
    
    func createLabel() {
        if self.itemArr.count == 0 {
            errorLabel.isHidden = false
            countLabel.isHidden = true
            priceLabel.isHidden = true
            wishTable.isHidden = true
        } else {
            errorLabel.isHidden = true
            countLabel.isHidden = false
            priceLabel.isHidden = false
            wishTable.isHidden = false
            if self.itemArr.count > 1 {
                countLabel.text = "WishList Total(\(self.itemArr.count) items):"
            } else {
                self.countLabel.text = "WishList Total(\(self.itemArr.count) item):"
            }
            var sum:Float = 0
            for it in self.itemArr {
                sum += Float(it.price)!
            }
            priceLabel.text = "$" + String(format: "%.2f", sum)
        }
    }
    
    
    
    func createItems(data: [JSON]) -> [Item] {
        var returnList:[Item] = []
        for it in data {
//            print(it["galleryURL"][0])
            //            let url = NSData(contentsOf: NSURL(fileURLWithPath: it["galleryURL"][0].stringValue) as URL)
            var image: UIImage
            let url = NSURL(string: it["galleryURL"][0].stringValue)
            if let urlData = NSData(contentsOf: url! as URL) {
                image = UIImage(data: urlData as Data)!
            } else {
                image = UIImage(named: "unchecked")!
            }
            //            image.draw(in: CGRect(x: 20, y: 10.5, width: 80, height: 80))
            let title = it["title"][0].stringValue
            let price = it["sellingStatus"][0]["currentPrice"][0]["__value__"].stringValue
            let ship = it["shippingInfo"][0]["shippingServiceCost"][0]["__value__"]
            var shipStr: String
            if ship == "0.0" {
                shipStr = "FREE SHIPPING"
            } else {
                shipStr = "$\(it["shippingInfo"][0]["shippingServiceCost"][0]["__value__"])"
            }
            let zip = it["postalCode"][0].stringValue
            let condId = it["condition"][0]["conditionId"][0].stringValue
            var cond = "NA"
            if condId == "1000" {
                cond = "NEW"
            } else if condId == "2000" || condId == "2500" {
                cond = "REFURBISHED"
            } else if condId == "3000" || condId == "4000" || condId == "5000" || condId == "6000" {
                cond = "USED"
            }
            let itemId = it["itemId"][0].stringValue
            
            let itRow = Item(image: image, title: title, price: price, ship: shipStr, zip: zip, cond: cond, itemId: itemId)
            returnList.append(itRow)
        }
        return returnList
        
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
