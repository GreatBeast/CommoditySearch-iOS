//
//  ResultViewController.swift
//  Hw5
//
//  Created by 朱正楠 on 4/8/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Toast_Swift

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(itemList.count)
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemCell
        cell.btnWish.tag = indexPath.row
        cell.setItem(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let nowWish = self.allItem[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemCell
//        if WishItem.search(item: nowWish) {
//            cell.btnWish.isSelected = true
//        } else {
//            cell.btnWish.isSelected = false
//        }
//    }
    
    @IBAction func touchWish(_ sender: UIButton) {
        let nowWish = self.itemList[sender.tag]
        let nowJson = self.allItem[sender.tag]
        if WishItem.search(itemid: nowWish.itemId) {
            WishItem.remove(item: nowWish)
            self.view.makeToast("\(nowWish.title) was removed from wishList")
            sender.isSelected = false
        } else {
            WishItem.add(newItem: nowWish, newJson: nowJson)
            self.view.makeToast("\(nowWish.title) was added to the wishList")
            sender.isSelected = true
        }
    }

    var query = ""
    var itemList:[Item] = []
    var allItem: JSON = []
    var myIndex = -1
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Searching...")
//        self.itemList.append(Item(image: UIImage(named: "wishListEmpty")!, title: "1", price: "2", ship: "3", zip: "4", cond: "5", wish: UIImage(named: "wishListEmpty")!))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        AF.request(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!).responseJSON {
            response in
            let json = JSON(response.data as Any)
//            var returnList:[Item] = []
            self.allItem = json["findItemsAdvancedResponse"][0]["searchResult"][0]["item"]
            self.itemList = self.createItems()
//            print(self.itemList.count)
            DispatchQueue.main.async{
                if (self.itemList.count == 0) {
                    let alert = UIAlertController(title: "No Results!", message: "Fail to fetch search results", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: {ACTION in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                self.tableView.reloadData()
                SwiftSpinner.hide()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        self.itemList = createItems()
//        self.tableView.reloadData()
        if myIndex != -1 {
            let cell = tableView.cellForRow(at: IndexPath(row: self.myIndex, section: 0))! as! ItemCell
            if WishItem.search(itemid: self.itemList[self.myIndex].itemId) {
                cell.btnWish.isSelected = true
            } else {
                cell.btnWish.isSelected = false
            }
            myIndex = -1
        }

    }

    func createItems() -> [Item] {
//        let json = JSON(data as Any)
        var returnList:[Item] = []
//        self.allItem = json["findItemsAdvancedResponse"][0]["searchResult"][0]["item"]
        for (_,it):(String, JSON) in allItem {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.myIndex = indexPath.row
        performSegue(withIdentifier: "detail", sender: self)
    }
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        self.myIndex = indexPath.row
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as! TabBarController
            vc.nowItem = self.allItem[self.myIndex]
            vc.usefulItem = self.itemList[self.myIndex]
        }
    }
}

//extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return itemList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let item = itemList[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemCell
//        cell.setItem(item: item)
//        return cell
//    }
//
//}
