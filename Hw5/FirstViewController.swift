//
//  FirstViewController.swift
//  Hw5
//
//  Created by 朱正楠 on 4/9/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class nameValue {
    var title: String
    var detail: String
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
}

class FirstViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    

    var nowItem: JSON = []
    var itemDetail: JSON = []
    var pics: JSON = []
    var nameValueList:[nameValue] = []
    var newframe = CGRect(x: 0, y: 0, width: 0, height: 0)
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var nameValueTable: UITableView!
    
    @IBOutlet weak var desIcon: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    
    var fbButton: UIButton = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching Product Details...")
        let tabbar = tabBarController as! TabBarController
        self.nowItem = tabbar.nowItem
        self.fbButton = tabbar.fbButton
        AF.request("https://zzncs571hw9.appspot.com/detail?itemId=\(nowItem["itemId"][0])").responseJSON {
            response in
            self.itemDetail = JSON(response.data!)
            self.itemDetail = self.itemDetail["Item"]
            DispatchQueue.main.async{
                self.pics = self.itemDetail["PictureURL"]
                self.product.text = self.itemDetail["Title"].stringValue
                self.price.text = "$" + String(format: "%.2f", Float(self.nowItem["sellingStatus"][0]["currentPrice"][0]["__value__"].stringValue)! as CVarArg)
                self.initScrollView()
                self.initNameValue()
                self.fbButton.addTarget(self, action: #selector(self.fbShare(_:)), for: .touchUpInside)
                self.nameValueTable.separatorInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
                self.nameValueTable.reloadData()
                SwiftSpinner.hide()
            }
        }
        self.scrollView.delegate = self
        self.nameValueTable.delegate = self
        self.nameValueTable.dataSource = self
    }

    @IBAction func fbShare(_ sender: Any) {
        let dest = "http://www.facebook.com/sharer.php?&u=\(itemDetail["ViewItemURLForNaturalSearch"])&quote=Buy \(itemDetail["Title"]) for $\(nowItem["sellingStatus"][0]["currentPrice"][0]["__value__"]) from Ebay!&hashtag=#CSCI571Spring2019Ebay"
        UIApplication.shared.open(URL(string: dest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, options: [:])
    }
    
    func initScrollView() {
        pageControl.numberOfPages = pics.count
        for index in 0..<pics.count {
            let url = NSURL(string: pics[index].stringValue)
            let urlData = NSData(contentsOf: url! as URL)
            let image = UIImage(data: urlData! as Data)!
            newframe.origin.x = scrollView.frame.size.width * CGFloat(index)
            newframe.size = scrollView.frame.size
            let imageView = UIImageView(frame: newframe)
            imageView.image = image
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(pics.count), height: scrollView.frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    func initNameValue() {
        for (_,nv):(String, JSON) in itemDetail["ItemSpecifics"]["NameValueList"] {
            nameValueList.append(nameValue(title: nv["Name"].stringValue, detail: nv["Value"][0].stringValue))
        }
        if nameValueList.count == 0 {
            desIcon.isHidden = true
            desLabel.isHidden = true
            nameValueTable.isHidden = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNum)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameValueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = nameValueList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell") as! NameValueCell
        cell.setNameValue(n:name)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell") as! NameValueCell
//        return 30
//    }

}
