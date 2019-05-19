//
//  ViewController.swift
//  Hw5
//
//  Created by 朱正楠 on 4/7/19.
//  Copyright © 2019 zzn. All rights reserved.
//

import UIKit
import McPicker
import Toast_Swift
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate,  UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var btnCond1: UIButton!
    @IBOutlet weak var btnCond2: UIButton!
    @IBOutlet weak var btnCond3: UIButton!
    @IBOutlet weak var btnShip1: UIButton!
    @IBOutlet weak var btnShip2: UIButton!
    @IBOutlet weak var txtKey: UITextField!
    @IBOutlet weak var txtCate: UITextField!
    @IBOutlet weak var txtDist: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var swZip: UISwitch!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    let locationManager = CLLocationManager()
    
    var postalCode: String!
    var httpQuery = ""
    var zipSug:[String] = []
    @IBOutlet weak var zipTable: UITableView!
    
    @IBOutlet weak var wishBar: UISegmentedControl!
    @IBOutlet weak var wishListView: UIView!
    
    var usefulItemWish: Item!
    var nowItemWish: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCate.text = "All"
        // Do any additional setup after loading the view.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        btnCond1.setBackgroundImage(UIImage(named: "checked"), for: .selected)
        btnCond2.setBackgroundImage(UIImage(named: "checked"), for: .selected)
        btnCond3.setBackgroundImage(UIImage(named: "checked"), for: .selected)
        btnShip1.setBackgroundImage(UIImage(named: "checked"), for: .selected)
        btnShip2.setBackgroundImage(UIImage(named: "checked"), for: .selected)
        txtZip.isHidden = true
        wishListView.isHidden = true
        swZip.addTarget(self, action:  #selector(switchChanged), for: .valueChanged)
        zipTable.isHidden = true
        txtCate.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.allowsBackgroundLocationUpdates = true
        startReceivingLocationChanges()
        zipTable.layer.borderWidth = 2
        zipTable.layer.cornerRadius = 7
        zipTable.delegate = self
        zipTable.dataSource = self
        
        
    }
    
    @IBAction func clearAll(_ sender: Any) {
        txtKey.text = ""
        txtCate.text = "All"
        txtDist.text = ""
        txtZip.text = ""
        swZip.isOn = false
        if !txtZip.isHidden {
            btnSubmit.frame.origin.y = btnSubmit.frame.origin.y - 50
            btnClear.frame.origin.y = btnClear.frame.origin.y - 50
        }
        txtZip.isHidden = true
        zipTable.isHidden = true
        btnCond1.isSelected = false
        btnCond2.isSelected = false
        btnCond3.isSelected = false
        btnShip1.isSelected = false
        btnShip2.isSelected = false
        
    }
    @objc func switchChanged(mySwitch: UISwitch) {
        txtZip.isHidden = !txtZip.isHidden
        if txtZip.isHidden {
            zipTable.isHidden = true
            btnSubmit.frame.origin.y = btnSubmit.frame.origin.y - 50
            btnClear.frame.origin.y = btnClear.frame.origin.y - 50
        }
        else {
            btnSubmit.frame.origin.y = btnSubmit.frame.origin.y + 50
            btnClear.frame.origin.y = btnClear.frame.origin.y + 50
        }
        // Do something
    }
    
    @IBAction func cateTouch(_ sender: Any){
        McPicker.show(data: [["All", "Art", "Baby", "Books", "Clothing,Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]]) {  [weak self] (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                self?.txtCate.text = name
            }
        }
    }
    
    @IBAction func checkboxClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
    }
    
    @IBAction func closeKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

    
    func startReceivingLocationChanges() {
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            print("No Authorization")
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            print("No service")
            return
        }
        locationManager.startUpdatingLocation()
        
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.postalCode = pm?.postalCode
                } else {
                print("Problem with the data received from geocoder")
            }
        })
    }

    
    @IBAction func submitForm(_ sender: Any) {
        locationManager.startUpdatingLocation()
        if txtKey.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.view.makeToast("Keyword is Mandatory")
        }
        else if swZip.isOn && txtZip.text?.trimmingCharacters(in: .whitespaces) == "" {
            self.view.makeToast("Zipcode is Mandatory")
        }
        else {
            self.httpQuery = "https://zzncs571hw9.appspot.com/users?keyword=\(txtKey.text!)&category=\(txtCate.text!)"
            if swZip.isOn {
                self.httpQuery += "&zipcode=\(txtZip.text!)"
            } else {
                self.httpQuery += "&defaultzip=\(postalCode!)"
                print(postalCode!)
//                self.httpQuery += "&defaultzip=90007"
            }
            if txtDist.text != "" {
                self.httpQuery += "&distance=\(txtDist.text!)"
            }
            if btnCond1.isSelected {
                self.httpQuery += "&condition1=true"
            }
            if btnCond2.isSelected {
                self.httpQuery += "&condition2=true"
            }
            if btnCond3.isSelected {
                self.httpQuery += "&condition3=true"
            }
            if btnShip1.isSelected {
                self.httpQuery += "&shipping1=true"
            }
            if btnShip2.isSelected {
                self.httpQuery += "&shipping2=true"
            }
            performSegue(withIdentifier: "search", sender: self)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            let vc = segue.destination as! ResultViewController
            vc.query = self.httpQuery
        } else if segue.identifier == "wishDetail" {
            let vc = segue.destination as! TabBarController
            vc.usefulItem = self.usefulItemWish
            vc.nowItem = self.nowItemWish
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipSug.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let zip = zipSug[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "zipCell") as! ZipCell
        cell.zip.text = zip
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtZip.text = zipSug[indexPath.row]
        zipTable.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    @IBAction func zipChanged(_ sender: UITextField) {
        if sender.text == "" {
            self.zipTable.isHidden = true
        } else if let nowZip = sender.text {
            AF.request("https://zzncs571hw9.appspot.com/detail?zipcode=\(nowZip)").responseJSON {
                response in
                let places = JSON(response.data!)["postalCodes"]
                self.zipSug = []
                for (_,p) : (String,JSON) in places {
                    self.zipSug.append(p["postalCode"].stringValue)
                }
                DispatchQueue.main.async{
                    if self.zipSug.count == 0 {
                        self.zipTable.isHidden = true
                    } else {
                        self.zipTable.isHidden = false
                    }
                    self.zipTable.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func zipEnd(_ sender: Any) {
        self.zipTable.isHidden = true
    }
    
    @IBAction func changeWish(_ sender: Any) {
        if (wishBar.selectedSegmentIndex == 0) {
            wishListView.isHidden = true
        } else {
            wishListView.isHidden = false
        }
    }
}
