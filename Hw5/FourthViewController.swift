//
//  FourthViewController.swift
//  Hw5
//
//  Created by 朱正楠 on 4/10/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON
import Alamofire

class FourthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    

    var nowItem: JSON = []
    var similar: JSON = []
    var items: [SimilarItem] = []
    @IBOutlet weak var sortBy: UISegmentedControl!
    @IBOutlet weak var order: UISegmentedControl!
    @IBOutlet weak var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching Similar Items...")
        let tabbar = tabBarController as! TabBarController
        self.nowItem = tabbar.nowItem
        let str = "https://zzncs571hw9.appspot.com/detail?similar=\(nowItem["itemId"][0])"
        AF.request(str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!).responseJSON {
            response in
            self.similar = JSON(response.data!)["getSimilarItemsResponse"]["itemRecommendations"]["item"]
            DispatchQueue.main.async{
                self.initItems()
                self.order.isUserInteractionEnabled = false
                self.collection.reloadData()
                SwiftSpinner.hide()
            }
        }
        self.collection.delegate = self
        self.collection.dataSource = self
    }
    
    @IBAction func orderChanged(_ sender: Any) {
        let sob = sortBy.selectedSegmentIndex
        let ord = order.selectedSegmentIndex
        order.isUserInteractionEnabled = true
        if sob == 0 {
            self.items.sort { (a, b) -> Bool in
                a.index < b.index
            }
            order.selectedSegmentIndex = 0
            order.isUserInteractionEnabled = false
        } else if sob == 1 {
            if ord == 0 {
                self.items.sort { (a, b) -> Bool in
                    a.title < b.title
                }
            } else if ord == 1 {
                self.items.sort { (a, b) -> Bool in
                    a.title > b.title
                }
            }
        } else if sob == 2 {
            if ord == 0 {
                self.items.sort { (a, b) -> Bool in
                    a.price < b.price
                }
            } else if ord == 1 {
                self.items.sort { (a, b) -> Bool in
                    a.price > b.price
                }
            }
        } else if sob == 3 {
            if ord == 0 {
                self.items.sort { (a, b) -> Bool in
                    a.day < b.day
                }
            } else if ord == 1 {
                self.items.sort { (a, b) -> Bool in
                    a.day > b.day
                }
            }
        } else if sob == 4 {
            if ord == 0 {
                self.items.sort { (a, b) -> Bool in
                    a.ship < b.ship
                }
            } else if ord == 1 {
                self.items.sort { (a, b) -> Bool in
                    a.ship > b.ship
                }
            }
        }
        self.collection.reloadData()
    }
    func initItems() {
        var i = 0
        for (_,it):(String, JSON) in similar {
            var image: UIImage
            let imageurl = NSURL(string: it["imageURL"].stringValue)
            let urlData = NSData(contentsOf: imageurl! as URL)
            image = UIImage(data: urlData! as Data)!
            let title = it["title"].stringValue
            let price = Float(it["buyItNowPrice"]["__value__"].stringValue)
            let ship = Float(it["shippingCost"]["__value__"].stringValue)!
            let dayAll = it["timeLeft"].stringValue
            var day: Int
            let index1 = dayAll.index(dayAll.startIndex, offsetBy: 1)
            let index2 = dayAll.index(dayAll.startIndex, offsetBy: 2)
//            let t = (dayAll[index2...index2] as NSString).intValue

            if dayAll[index2] == "D" {
                day = Int(dayAll[index1...index1])!
            } else {
                day = Int(dayAll[index1...index2])!
            }
            let url = it["viewItemURL"].stringValue
            self.items.append(SimilarItem(index: i, image: image, title: title, ship: ship, price: price!, day: day, url: url))
            i += 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as! SimilarCell
        cell.image.image = item.image
        cell.similarTitle.text = item.title
        cell.similarShip.text = "$\(item.ship)"
        if item.day == 1 {
            cell.similarLeft.text = "\(item.day) Day Left"
        } else {
            cell.similarLeft.text = "\(item.day) Days Left"
        }
        if item.price == 0.0 {
            cell.similarPrice.text = "N/A"
        } else {
            cell.similarPrice.text = "$\(item.price)"
        }
        
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.gray.cgColor
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 184, height: 310)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goURL = items[indexPath.row].url
        UIApplication.shared.open(URL(string: goURL)!, options: [:])
    }

}
