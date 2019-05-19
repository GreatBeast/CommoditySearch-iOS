//
//  ThirdViewController.swift
//  Hw5
//
//  Created by 朱正楠 on 4/9/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class ThirdViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var nowItem: JSON = []
    var photos: JSON = []
    var newframe = CGRect(x: 0, y: 0, width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching Google Images...")
        let tabbar = tabBarController as! TabBarController
        self.nowItem = tabbar.nowItem

        let str = "https://zzncs571hw9.appspot.com/detail?title=\(nowItem["title"][0])"
       
        let repStr = str.replacingOccurrences(of: "&", with: " ")
        AF.request(repStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!).responseJSON {
            response in
            self.photos = JSON(response.data!)["items"]
            DispatchQueue.main.async{
                self.initScrollView()
                SwiftSpinner.hide()
            }
            self.scrollView.delegate = self
        }
    }
    
    func initScrollView() {
        var opp: CGFloat = 0.0
        for index in 0..<photos.count {
            let url = NSURL(string: photos[index]["link"].stringValue)
            let urlData = NSData(contentsOf: url! as URL)
            if urlData == nil {
                continue
            }
            let image = UIImage(data: urlData! as Data)!
//            newframe.origin.y = scrollView.frame.size.height * CGFloat(index)
            
            newframe.size.height = image.size.height * scrollView.frame.width / image.size.width
            newframe.size.width = scrollView.frame.width
            newframe.origin.y = opp
            opp += 10 + newframe.size.height
            
            let imageView = UIImageView(frame: newframe)
            imageView.image = image
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: opp)
    }


}
