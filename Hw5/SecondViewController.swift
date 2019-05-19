//
//  SecondViewController.swift
//  Hw5
//
//  Created by 朱正楠 on 4/9/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON
import Alamofire

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var sectionData: [[nameValue]] = []
    var nowItem: JSON = []
    var itemDetail: JSON = []
    var sectionImage:[String] = []
    var storeurl: String = ""
    @IBAction func storeButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: storeurl)!, options: [:])
    }
    @IBOutlet weak var shipTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching Shipping Data...")
        let tabbar = tabBarController as! TabBarController
        self.nowItem = tabbar.nowItem
        AF.request("https://zzncs571hw9.appspot.com/detail?itemId=\(nowItem["itemId"][0])").responseJSON {
            response in
            self.itemDetail = JSON(response.data!)
            self.itemDetail = self.itemDetail["Item"]
            DispatchQueue.main.async{
                self.initContent()
                self.shipTable.separatorStyle = .none
                self.shipTable.reloadData()
                SwiftSpinner.hide()
            }
            self.shipTable.delegate = self
            self.shipTable.dataSource = self
        }
        
        // Do any additional setup after loading the view.
    }
    
    func initContent() {
        var seller: [nameValue] = []
        if let storeName = self.itemDetail["Storefront"]["StoreName"].string {
            seller.append(nameValue(title: "Store Name", detail: storeName))
            self.storeurl = self.itemDetail["Storefront"]["StoreURL"].stringValue
            print(self.itemDetail["Storefront"]["StoreURL"])
        }
        if let feedScroe = self.itemDetail["Seller"]["FeedbackScore"].int {
            seller.append(nameValue(title: "Feedback Score", detail: String(feedScroe)))
        }
        if let pop = self.itemDetail["Seller"]["PositiveFeedbackPercent"].float {
            seller.append(nameValue(title: "Popularity", detail: String(pop)))
        }
        if let feedStar = self.itemDetail["Seller"]["FeedbackRatingStar"].string {
            seller.append(nameValue(title: "Feedback Star", detail: feedStar))
        }
        var shipping: [nameValue] = []
        if let shipCost = self.nowItem["shippingInfo"][0]["shippingServiceCost"][0]["__value__"].string {
            if shipCost == "0.0" {
                shipping.append(nameValue(title: "Shipping Cost", detail: "FREE"))
            } else {
                shipping.append(nameValue(title: "Shipping Cost", detail: "$\(shipCost)"))
            }
        }
        if let shipGlobal = self.itemDetail["GlobalShipping"].bool {
            if shipGlobal == false {
                shipping.append(nameValue(title: "Global Shipping", detail: "No"))
            } else {
                shipping.append(nameValue(title: "Global Shipping", detail: "Yes"))
            }
        }
        if let shipHandle = self.itemDetail["HandlingTime"].int {
            if shipHandle == 1 {
                shipping.append(nameValue(title: "Handling Time", detail: "1 day"))
            } else {
                shipping.append(nameValue(title: "Handling Time", detail: "\(shipHandle) days"))
            }
        }
        var returnPly: [nameValue] = []
        if var returnPolicy = self.itemDetail["ReturnPolicy"]["ReturnsAccepted"].string {
            if returnPolicy == "ReturnsNotAccepted"{
                returnPolicy = "Returns Not Accepted"
            }
            returnPly.append(nameValue(title: "Policy", detail: returnPolicy))
        }
        if var returnRefund = self.itemDetail["ReturnPolicy"]["Refund"].string {
            if returnRefund == "Money back or replacement (buyer's choice)"{
                returnRefund = "Money back or replacement"
            }
            returnPly.append(nameValue(title: "Refund Mode", detail: returnRefund))
        }
        if let returnWithin = self.itemDetail["ReturnPolicy"]["ReturnsWithin"].string {
            returnPly.append(nameValue(title: "Return Within", detail: returnWithin))
        }
        if let returnCost = self.itemDetail["ReturnPolicy"]["ShippingCostPaidBy"].string {
            returnPly.append(nameValue(title: "Shipping Cost Paid By", detail: returnCost))
        }
        if seller.count > 0 {
            self.sectionData.append(seller)
            self.sectionImage.append("Seller")
        }
        if shipping.count > 0 {
            self.sectionData.append(shipping)
            self.sectionImage.append("Shipping Info")
        }
        if returnPly.count > 0 {
            self.sectionData.append(returnPly)
            self.sectionImage.append("Return Policy")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionData[section].count)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
        cell.headerImage.image = UIImage(named: sectionImage[section])
        cell.headerTitle.text = sectionImage[section]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell") as! NormalCell
        cell.normalTitle.text = sectionData[indexPath.section][indexPath.row].title
        if sectionData[indexPath.section][indexPath.row].title == "Store Name" {
//            let storeName = NSMutableAttributedString(string: sectionData[indexPath.section][indexPath.row].detail)
//            let strRange = NSRange.init(location: 0, length: storeName.length)
//            storeName.addAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.blue], range: strRange)
//            cell.storeBtn.setAttributedTitle(storeName, for: .normal)
//            cell.storeBtn.adjustsImageWhenHighlighted = false
//            cell.storeBtn.showsTouchWhenHighlighted = false
//            cell.storeBtn.isHidden = false
//            cell.normalDetail.isHidden = true
//            cell.icon.isHidden = true
            
            let storeName = NSMutableAttributedString(string: sectionData[indexPath.section][indexPath.row].detail)
            let strRange = NSRange.init(location: 0, length: storeName.length)
            storeName.addAttributes([.underlineStyle : NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.blue], range: strRange)
            cell.normalDetail.attributedText = storeName
            let tap = UITapGestureRecognizer(target: self, action: #selector(storeButton(_:)))
            cell.normalDetail.addGestureRecognizer(tap)
            cell.normalDetail.isHidden = false
            cell.icon.isHidden = true
        } else if sectionData[indexPath.section][indexPath.row].title == "Feedback Star" {
            let imgGood = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
            let imgBad = UIImage(named: "starBorder")?.withRenderingMode(.alwaysTemplate)
            cell.normalDetail.text = ""
            switch sectionData[indexPath.section][indexPath.row].detail {
            case "Yellow":
                cell.icon.image = imgBad
                cell.icon.tintColor = .orange
            case "Blue":
                cell.icon.image = imgBad
                cell.icon.tintColor = .blue
            case "Turquoise":
                cell.icon.image = imgBad
                cell.icon.tintColor = .cyan
            case "Purple":
                cell.icon.image = imgBad
                cell.icon.tintColor = .purple
            case "Red":
                cell.icon.image = imgBad
                cell.icon.tintColor = .red
            case "Green":
                cell.icon.image = imgBad
                cell.icon.tintColor = .green
            case "YellowShooting":
                cell.icon.image = imgGood
                cell.icon.tintColor = .orange
            case "TurquoiseShooting":
                cell.icon.image = imgGood
                cell.icon.tintColor = .cyan
            case "PurpleShooting":
                cell.icon.image = imgGood
                cell.icon.tintColor = .purple
            case "RedShooting":
                cell.icon.image = imgGood
                cell.icon.tintColor = .red
            case "GreenShooting":
                cell.icon.image = imgGood
                cell.icon.tintColor = .green
            case "SilverShooting":
                cell.icon.image = imgGood
                cell.icon.tintColor = .gray
            default:
                cell.normalDetail.text = "None"
            }
            
        } else {
            cell.normalDetail.text = sectionData[indexPath.section][indexPath.row].detail
            cell.normalDetail.numberOfLines = 0
            cell.normalDetail.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.normalDetail.sizeToFit()
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 27
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

}
