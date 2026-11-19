//
//  SaveSearchViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 25/06/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CoreLocation

class SaveSearchViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,HomeTableViewCellDelegate {

    @IBOutlet weak var tblSearch: UITableView!
    var breweryData = NSMutableArray()
    var barData = NSMutableArray()
    var bottleData = NSMutableArray()
    var pageNo = Int()
    var isLoadingTableView = Bool()
    var logdict = NSDictionary()
    var login_token = String()
    var noData = Bool()
    var sort_style = String()
    var userLat = Double()
    var userLng = Double()
    var locationManager:CLLocationManager!
    var color = String()
    var brewery = Bool()
    var bar = Bool()
    var bottle = Bool()
    
    @IBOutlet weak var btnBreweryOutlet: UIButton!
    @IBOutlet weak var btnBarOutlet: UIButton!
    @IBOutlet weak var btnBottleOutlet: UIButton!
    
    @IBOutlet weak var vwBrewery: UIView!
    @IBOutlet weak var vwBar: UIView!
    @IBOutlet weak var vwBottle: UIView!
    var nearSort = Bool()
    var favouriteId = String()
    var nearbySearch = Bool()
    
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        pageNo = 1
        self.isLoadingTableView = false
        
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logdict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logdict)")
        
        login_token = "\(logdict .value(forKey: "login_token")!)"
        brewery = true
        bar = false
        bottle = false
        
        
        if brewery == true{
            btnBreweryOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            btnBarOutlet.tintColor = UIColor.black
            btnBottleOutlet.tintColor = UIColor.black
            vwBrewery.isHidden = false
            vwBar.isHidden = true
            vwBottle.isHidden = true
            brewery = true
            bar = false
            bottle = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logdict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logdict)")
        
        login_token = "\(logdict .value(forKey: "login_token")!)"
        
        self.determineMyCurrentLocation()
    }

    //MARK:- Determine user current location
    func determineMyCurrentLocation() {
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                if #available(iOS 10.0, *) {
                    let alertController = UIAlertController(title: "Location Service Disabled",
                                                            message: "Location services are not enabled",
                                                            preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    
                    let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    alertController.addAction(openAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // Fallback on earlier versions
                }
            case .authorizedAlways, .authorizedWhenInUse:
                //      print("Access")
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//                locationManager.requestLocation()
//                if CLLocationManager.locationServicesEnabled() {
                    locationManager.startUpdatingLocation()
//                    //locationManager.stopUpdatingLocation()
//                }
            }
        }else{
            let alertController = UIAlertController(title: "Location Service Disabled",
                                                    message: "Location services are not enabled",
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        //Fallback on earlier versions
                    }
                }
            }
            alertController.addAction(openAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let userLocation:CLLocation = locations[0] as CLLocation
        //self.locationManager.stopUpdatingLocation()
        
        if let location = locations.first {
            print("Found user's location: \(location)")
            print("user latitude = \(location.coordinate.latitude)")
            print("user longitude = \(location.coordinate.longitude)")
            
            self.locationManager.stopUpdatingLocation()
            self.locationManager.delegate = nil
            
            self.userLat = location.coordinate.latitude
            self.userLng = location.coordinate.longitude
            
            if brewery == true{
                self.pageNo = 1
                self.breweryData = NSMutableArray()
                self.fetchBreweryList()
            }else if bar == true{
                self.pageNo = 1
                self.barData = NSMutableArray()
                self.fetchBarList()
            }else{
                self.pageNo = 1
                self.bottleData = NSMutableArray()
                self.fetchBottleList()
            }
        }
        
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func fatalError(){
        print("Error")
    }
    
    //MARK:- Fetch Brewery List
    
    func fetchBreweryList(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "search-list"
                
        let newTodo: [String: Any] = ["category": "brewery","page_number": pageNo,"sort":self.sort_style,"lat": self.userLat,"long": self.userLng,"login_token": login_token]
        
        print("Parameter:== \(newTodo)")
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    //print("Error: \(response.result.error as! NSString)")
                    SVProgressHUD.dismiss()
                    return
                }
                print("JSON: \(json)")
                if((json["list"] as! Array<Any>).count > 0){
                    self.isLoadingTableView = true
                    self.breweryData.addObjects(from: ((json["list"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                }else{
                    self.noData = true
                    self.isLoadingTableView = false
                }
                self.tblSearch.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Fetch Bar List
    
    func fetchBarList(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "search-list"
        
        let newTodo: [String: Any] = ["category": "bar","page_number": pageNo,"sort":self.sort_style,"lat": self.userLat,"long": self.userLng,"login_token": login_token]
        
        print("Parameter:== \(newTodo)")
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
        encoding: JSONEncoding.default)
        .responseJSON { response in
        guard let json = response.result.value as? [String: Any] else {
            print("didn't get todo object as JSON from API")
            //print("Error: \(response.result.error as! NSString)")
            SVProgressHUD.dismiss()
            return
        }
        print("JSON: \(json)")
        if((json["list"] as! Array<Any>).count > 0){
            self.isLoadingTableView = true
            self.barData.addObjects(from: ((json["list"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
        }else{
            self.noData = true
            self.isLoadingTableView = false
        }
            self.tblSearch.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    //MARK:- Fetch Bottle List
    func fetchBottleList(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "search-list"
        
        let newTodo: [String: Any] = ["category": "bottleshop","page_number": pageNo,"sort":self.sort_style,"lat": self.userLat,"long": self.userLng,"login_token": login_token]
        
        print("Parameter:== \(newTodo)")
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    //print("Error: \(response.result.error as! NSString)")
                    SVProgressHUD.dismiss()
                    return
                }
                print("JSON: \(json)")
                if((json["list"] as! Array<Any>).count>0){
                    self.isLoadingTableView = true
//                    self.bottleData = (json["list"] as! NSArray).mutableCopy() as! NSMutableArray
                    self.bottleData.addObjects(from: ((json["list"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                }else{
                    self.noData = true
                    self.isLoadingTableView = false
                }
                self.tblSearch.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    
    //MARK: - TableView Deleagte/DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if brewery == true{
            if(breweryData.count == 0){
                return 1
            }else{
                return breweryData.count
            }
        }
        else if bar == true{
            if(barData.count == 0){
                return 1
            }else{
                return barData.count
            }
        }else if bottle == true{
            if(bottleData.count == 0){
                return 1
            }else{
                return bottleData.count
            }
        }else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if brewery == true{
        if(breweryData.count == 0){
            var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                
                cell = tblSearch.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            }
            
            if self.noData == true{
                self.noData = false
                cell.textLabel?.text = "No Data Found"
                cell.textLabel?.textAlignment = .center
            }else{
                cell.textLabel?.text = ""
            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"homeCell", for: indexPath)as! HomeTableViewCell
            let infoDic = ((self.breweryData) .object(at: indexPath.row) as! NSDictionary)
            
            cell.lblName.text = "\(infoDic["name"]!)"
            
            if let value = (infoDic["state"] as? String)
            {
                //NOT NULL
                cell.lblAddress.text = "\((infoDic["address"] as? String)!),\((infoDic["country"] as? String)!),\(value),\((infoDic["city"] as? String)!)"
            }
            else
            {
                //NULL
                cell.lblAddress.text = "\((infoDic["address"] as? String)!),\((infoDic["country"] as? String)!),\((infoDic["city"] as? String)!)"
            }
            
            cell.lblAddress.numberOfLines = 0
            cell.lblAddress.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.lblAddress.clipsToBounds = true
            
            //cell.lblCount.text = String(indexPath.row + 1)
            cell.lblCount.isHidden = true
            
            if "\(infoDic["phone"]!)" == ""{
                cell.lblPhone.text = "N/A"
            }else{
                cell.lblPhone.text = "\(infoDic["phone"]!)"
            }
            cell.vwCategoryImage.image = UIImage(named: "Brewrie.png")
            cell.delegate = self
            cell.index = indexPath.row
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            self.color = "\(infoDic["color"]!)"
            
            if self.color == "G"{
                cell.viewRating.isHidden = false
                cell.lblNoScore.isHidden = true
                cell.lblRate.isHidden = false
                cell.viewRating.value = CGFloat(Float((infoDic["beer_avgRate"] as! NSNumber).floatValue))
                let rateVal = Double("\(infoDic["beer_avgRate"]!)")
                cell.lblRate.text = String(format: "%.1f/10", rateVal!)
                cell.lblRate.backgroundColor = UIColor(red: 53.0/255.0, green: 125.0/255.0, blue: 34.0/255.0, alpha: 1.0)
            }else if self.color == "Y"{
                cell.viewRating.isHidden = false
                cell.lblNoScore.isHidden = true
                cell.lblRate.isHidden = false
                let rateVal = Double("\(infoDic["beer_avgRate"]!)")
                cell.lblRate.text = String(format: "%.1f/10", rateVal!)
                cell.viewRating.value = CGFloat(Float((infoDic["beer_avgRate"] as! NSNumber).floatValue))
                cell.lblRate.backgroundColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            }else /*if self.color == "R"*/{
                cell.lblNoScore.isHidden = false
                cell.viewRating.isHidden = true
                cell.lblRate.isHidden = true
                cell.lblNoScore.backgroundColor = UIColor.red
                cell.lblNoScore.text = "No score yet"
            }
            return cell
            }
        }
        
        else if bar == true{
            if (barData.count == 0){
                
                var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                    
                    cell = tblSearch.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
                }
                
                if self.noData == true{
                    self.noData = false
                    cell.textLabel?.text = "No Data Found"
                    cell.textLabel?.textAlignment = .center
                }else{
                    cell.textLabel?.text = ""
                }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }else{
                let cell = tblSearch.dequeueReusableCell(withIdentifier:"homeCell", for: indexPath)as! HomeTableViewCell
                
                let infoDic = ((self.barData) .object(at: indexPath.row) as! NSDictionary)
                
                /*if self.nearSort == true{
                    
                    if let lat = infoDic["lat"] as? NSNumber {
                        self.Latitude = double_t(lat.stringValue)!
                    }
                    else if let lat = infoDic["lat"] as? String {
                        self.Latitude = double_t(lat)!
                    }
                    
                    if let lng = infoDic["long"] as? NSNumber {
                        self.Longitude = double_t(lng.stringValue)!
                    }
                    else if let lng = infoDic["long"] as? String {
                        self.Longitude = double_t(lng)!
                    }
                    
                    //My location
                    let myLocation = CLLocation(latitude: self.userLat, longitude: self.userLng)
                    
                    //My buddy's location
                    let myBuddysLocation = CLLocation(latitude: CLLocationDegrees(self.Latitude), longitude: CLLocationDegrees(self.Longitude))
                    
                    //Measuring my distance to my buddy's (in km)
                    let distance = myLocation.distance(from: myBuddysLocation) / 1000
                    
                    //Display the result in km
                    let doubleStr = (String(format: "%.1f Miles", ceil(distance*100)/100))
                    //print(String(format: "The distance to my buddy is %.01fkm", distance))
                    
                    cell.lblDistance.text = doubleStr
                }else{
                    cell.lblDistance.text = ""
                }
                */
                if let value = (infoDic["state"] as? String)
                {
                    //NOT NULL
                    cell.lblAddress.text = "\((infoDic["address"] as? String)!),\((infoDic["country"] as? String)!),\(value),\((infoDic["city"] as? String)!)"
                }
                else
                {
                    //NULL
                    cell.lblAddress.text = "\((infoDic["address"] as? String)!),\((infoDic["country"] as? String)!),\((infoDic["city"] as? String)!)"
                }
                
                cell.lblName.text = "\(infoDic["name"]!)"
                //cell.lblCount.text = String(indexPath.row + 1)
                cell.lblCount.isHidden = true
                if "\(infoDic["phone"]!)" == ""{
                    cell.lblPhone.text = "N/A"
                }else{
                    cell.lblPhone.text = "\(infoDic["phone"]!)"
                }
                cell.vwCategoryImage.image = UIImage(named: "restaurent-bar.png")
                cell.delegate = self
                cell.index = indexPath.row
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                self.color = "\(infoDic["color"]!)"
                
                if self.color == "G"{
                    cell.viewRating.isHidden = false
                    cell.lblNoScore.isHidden = true
                    cell.lblRate.isHidden = false
                    cell.viewRating.value = CGFloat(Float((infoDic["avgRate"] as! NSNumber).floatValue))
                    let rateVal = Double("\(infoDic["avgRate"]!)")
                    cell.lblRate.text = String(format: "%.1f/10", rateVal!)
                    cell.lblRate.backgroundColor = UIColor(red: 53.0/255.0, green: 125.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                }else if self.color == "Y"{
                    cell.viewRating.isHidden = false
                    cell.lblNoScore.isHidden = true
                    cell.lblRate.isHidden = false
                    let rateVal = Double("\(infoDic["avgRate"]!)")
                    cell.lblRate.text = String(format: "%.1f/10", rateVal!)
                    cell.viewRating.value = CGFloat(Float((infoDic["avgRate"] as! NSNumber).floatValue))
                    cell.lblRate.backgroundColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
                }else if self.color == "R"{
                    cell.lblNoScore.isHidden = false
                    cell.viewRating.isHidden = true
                    cell.lblRate.isHidden = true
                    cell.lblNoScore.backgroundColor = UIColor.red
                    cell.lblNoScore.text = "No score yet"
                }
                return cell
            }
        }
        else if bottle == true{
            if (bottleData.count == 0){
                var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                    
                    cell = tblSearch.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
                }
                
                if noData == true{
                    self.noData = false
                    cell.textLabel?.text = "No Data Found"
                    cell.textLabel?.textAlignment = .center
                }else{
                    cell.textLabel?.text = ""
                }
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }else{
                let cell = tblSearch.dequeueReusableCell(withIdentifier:"homeCell", for: indexPath)as! HomeTableViewCell
                
                let infoDic = ((self.bottleData) .object(at: indexPath.row) as! NSDictionary)
                
                /*if self.nearSort == true{
                    
                    if let lat = infoDic["lat"] as? NSNumber {
                        self.Latitude = double_t(lat.stringValue)!
                    }
                    else if let lat = infoDic["lat"] as? String {
                        self.Latitude = double_t(lat)!
                    }
                    
                    if let lng = infoDic["long"] as? NSNumber {
                        self.Longitude = double_t(lng.stringValue)!
                    }
                    else if let lng = infoDic["long"] as? String {
                        self.Longitude = double_t(lng)!
                    }
                    
                    //My location
                    let myLocation = CLLocation(latitude: self.userLat, longitude: self.userLng)
                    
                    //My buddy's location
                    let myBuddysLocation = CLLocation(latitude: CLLocationDegrees(self.Latitude), longitude: CLLocationDegrees(self.Longitude))
                    
                    //Measuring my distance to my buddy's (in km)
                    let distance = myLocation.distance(from: myBuddysLocation) / 1000
                    
                    //Display the result in km
                    let doubleStr = (String(format: "%.1f Miles", ceil(distance*100)/100))
                    //print(String(format: "The distance to my buddy is %.01fkm", distance))
                    
                    cell.lblDistance.text = doubleStr
                }else{
                    cell.lblDistance.text = ""
                }*/
                
                if let value = (infoDic["state"] as? String)
                {
                    //NOT NULL
                    cell.lblAddress.text = "\((infoDic["address"] as? String)!),\((infoDic["country"] as? String)!),\(value),\((infoDic["city"] as? String)!)"
                }
                else
                {
                    //NULL
                    cell.lblAddress.text = "\((infoDic["address"] as? String)!),\((infoDic["country"] as? String)!),\((infoDic["city"] as? String)!)"
                }
                
                cell.lblName.text = "\(infoDic["name"]!)"
                //cell.lblCount.text = String(indexPath.row + 1)
                cell.lblCount.isHidden = true
                
                if "\(infoDic["phone"]!)" == ""{
                    cell.lblPhone.text = "N/A"
                }else{
                    cell.lblPhone.text = "\(infoDic["phone"]!)"
                }
                cell.vwCategoryImage.image = UIImage(named: "bottle-shop.png")
                cell.delegate = self
                cell.index = indexPath.row
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                self.color = "\(infoDic["color"]!)"
                
                if self.color == "G"{
                    cell.viewRating.isHidden = false
                    cell.lblNoScore.isHidden = true
                    cell.lblRate.isHidden = false
                    cell.viewRating.value = CGFloat(Float((infoDic["avgRate"] as! NSNumber).floatValue))
                    let rateVal = Double("\(infoDic["avgRate"]!)")
                    cell.lblRate.text = String(format: "%.1f/10", rateVal!)
                    cell.lblRate.backgroundColor = UIColor(red: 53.0/255.0, green: 125.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                }else if self.color == "Y"{
                    cell.viewRating.isHidden = false
                    cell.lblNoScore.isHidden = true
                    cell.lblRate.isHidden = false
                    let rateVal = Double("\(infoDic["avgRate"]!)")
                    cell.lblRate.text = String(format: "%.1f/10", rateVal!)
                    cell.viewRating.value = CGFloat(Float((infoDic["avgRate"] as! NSNumber).floatValue))
                    cell.lblRate.backgroundColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
                }else if self.color == "R"{
                    cell.lblNoScore.isHidden = false
                    cell.viewRating.isHidden = true
                    cell.lblRate.isHidden = true
                    cell.lblNoScore.backgroundColor = UIColor.red
                    cell.lblNoScore.text = "No score yet"
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if brewery == true{
                let infoDic = ((self.breweryData) .object(at: indexPath.row) as! NSDictionary)
                self.favouriteId = (infoDic["_id"] as? String)!
                self.delete()
            }else if bar == true{
                let infoDic = ((self.barData) .object(at: indexPath.row) as! NSDictionary)
                self.favouriteId = (infoDic["_id"] as? String)!
                self.delete()
            }else{
                let infoDic = ((self.bottleData) .object(at: indexPath.row) as! NSDictionary)
                self.favouriteId = (infoDic["_id"] as? String)!
                self.delete()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if brewery == true{
            if indexPath.row == self.breweryData.count - 1 && self.isLoadingTableView == true
            {
                pageNo = pageNo + 1;
                print("Page:== \(pageNo)")
                self.fetchBreweryList()
            }
        }else if bar == true{
            if indexPath.row == self.barData.count - 1 && self.isLoadingTableView == true
            {
                pageNo = pageNo + 1;
                print("Page:== \(pageNo)")
                self.fetchBarList()
            }
        }else{
            if indexPath.row == self.bottleData.count - 1 && self.isLoadingTableView == true
            {
                pageNo = pageNo + 1;
                print("Page:== \(pageNo)")
                self.fetchBottleList()
            }
        }
    }
    //MARK:- Custom Tableview cell
    
    func HomeTableViewCell(_ obj: HomeTableViewCell, info index: Int){
        print("Index: \(index)")
        if brewery == true{
            let BreweryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreweryDetail") as! BreweryDetailViewController
            let infoDic = ((self.breweryData) .object(at: index) as! NSDictionary)
            BreweryDetailViewController.breweryID = (infoDic["_id"] as? String)!
            BreweryDetailViewController.BreweryName = "\(infoDic["name"]!)"
            BreweryDetailViewController.BreweryAddress = "\(infoDic["address"]!)"
            self.navigationController?.pushViewController(BreweryDetailViewController, animated: true)
        }else if bar == true{
            let RestaurantDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetailViewController
            let infoDic = ((self.barData) .object(at: index) as! NSDictionary)
            RestaurantDetailViewController.barID = (infoDic["_id"] as? String)!
            RestaurantDetailViewController.BarName = "\(infoDic["name"]!)"
            RestaurantDetailViewController.BarAddress = "\(infoDic["address"]!)"
            self.navigationController?.pushViewController(RestaurantDetailViewController, animated: true)
        }else{
            let BottleshopDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BottleshopDetail") as! BottleshopDetailViewController
            let infoDic = ((self.bottleData) .object(at: index) as! NSDictionary)
            BottleshopDetailViewController.bottleID = (infoDic["_id"] as? String)!
            BottleshopDetailViewController.BottleName = "\(infoDic["name"]!)"
            BottleshopDetailViewController.BottleAddress = "\(infoDic["address"]!)"
            self.navigationController?.pushViewController(BottleshopDetailViewController, animated: true)
        }
        
    }
    
    func HomeTableViewCell(_ obj: HomeTableViewCell, rate index: Int)
    {
        
    }
    
    //MARK:- Delete Api Call
    func delete(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "delete-search"
        
        let newTodo: [String: Any] = ["login_token": login_token,"search_id": "","place_id": self.favouriteId]
        
        print("Parameter:== \(newTodo)")
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    //print("Error: \(response.result.error as! NSString)")
                    SVProgressHUD.dismiss()
                    return
                }
                print("JSON: \(json)")
                self.view.makeToast("Removed from Saved Places", duration: 3.0, position: .bottom)
                if self.brewery == true{
                    self.breweryData = NSMutableArray()
                    self.fetchBreweryList()
                }else if self.bar == true{
                    self.barData = NSMutableArray()
                    self.fetchBarList()
                }else{
                    self.bottleData = NSMutableArray()
                    self.fetchBottleList()
                }
                SVProgressHUD.dismiss()
        }
    }
    
    
    
    
    //MARK:- Brewery Button Action
    
    @IBAction func btnBreweryDidTap(_ sender: Any) {
        self.pageNo = 1
        btnBreweryOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBarOutlet.tintColor = UIColor.black
        btnBottleOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = false
        vwBar.isHidden = true
        vwBottle.isHidden = true
        brewery = true
        bar = false
        bottle = false
        self.sort_style = ""
        self.userLat = 0
        self.userLng = 0
        self.nearSort = false
        self.breweryData = NSMutableArray()
//        self.fetchBreweryList()
//        self.tblSearch.reloadData()
        self.determineMyCurrentLocation()
    }
    
    
    
    //MARK:- Bar Button Action
    
    @IBAction func btnBarDidTap(_ sender: Any) {
        self.pageNo = 1
        btnBarOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBreweryOutlet.tintColor = UIColor.black
        btnBottleOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = true
        vwBar.isHidden = false
        vwBottle.isHidden = true
        bar = true
        brewery = false
        bottle = false
        self.sort_style = ""
        self.userLat = 0
        self.userLng = 0
        self.nearSort = false
        self.barData = NSMutableArray()
//        self.fetchBarList()
//        self.tblSearch.reloadData()
        self.determineMyCurrentLocation()
    }
    
    
    //MARK:- Bottle Button Action
    
    @IBAction func btnBottleDidTap(_ sender: Any) {
        self.pageNo = 1
        btnBottleOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBreweryOutlet.tintColor = UIColor.black
        btnBarOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = true
        vwBar.isHidden = true
        vwBottle.isHidden = false
        bottle = true
        bar = false
        brewery = false
        self.sort_style = ""
        self.userLat = 0
        self.userLng = 0
        self.nearSort = false
        self.bottleData = NSMutableArray()
//        self.fetchBottleList()
//        self.tblSearch.reloadData()
        self.determineMyCurrentLocation()
    }
    
    
    //MARK:- Sort By Button Action
    @IBAction func btnSortByDidTap(_ sender: Any) {
        if brewery == true{
            self.nearbySearch = true
            let myActionSheet = UIAlertController()
            let action1 = UIAlertAction(title: "Name", style: .default, handler: { (action) -> Void in
                print("Name selected!")
                self.nearSort = false
                if self.brewery == true{
                    self.pageNo = 1
                    self.breweryData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.barData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.bottleData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBottleList()
                }
            })
            
            let action2 = UIAlertAction(title: "Rating (High to Low)", style: .default, handler: { (action) -> Void in
                self.nearSort = false
                print("Ranking High to Low selected!")
                if self.brewery == true{
                    self.pageNo = 1
                    self.breweryData = NSMutableArray()
                    self.sort_style = "beer_avgRate||DESC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.barData = NSMutableArray()
                    self.sort_style = "avgRate||DESC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.bottleData = NSMutableArray()
                    self.sort_style = "avgRate||DESC"
                    self.fetchBottleList()
                }
            })
            
            let action3 = UIAlertAction(title: "Rating (Low to High)", style: .default, handler: { (action) -> Void in
                self.nearSort = false
                print("Ranking Low to High selected!")
                if self.brewery == true{
                    self.pageNo = 1
                    self.breweryData = NSMutableArray()
                    self.sort_style = "beer_avgRate||ASC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.barData = NSMutableArray()
                    self.sort_style = "avgRate||ASC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.bottleData = NSMutableArray()
                    self.sort_style = "avgRate||ASC"
                    self.fetchBottleList()
                }
            })
            
            let action4 = UIAlertAction(title: "Nearby", style: .default, handler: { (action) -> Void in
                let alertController = UIAlertController(title: "Alert", message: "This feature is only available for your current location. Do you want to see your local results (this will change your search location in the app)?", preferredStyle: UIAlertController.Style.alert) //Replace
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    
                }
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    self.nearSort = true
                    if self.brewery == true{
                        self.pageNo = 1
                        self.breweryData = NSMutableArray()
                        self.sort_style = "distance||ASC"
                    }
                    else if self.bar == true{
                        self.pageNo = 1
                        self.barData = NSMutableArray()
                        self.sort_style = "distance||ASC"
                    }
                    else if self.bottle == true{
                        self.pageNo = 1
                        self.bottleData = NSMutableArray()
                        self.sort_style = "distance||ASC"
                    }
                    self.determineMyCurrentLocation()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            })
            
            myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            // Add action buttons and present the Alert
            myActionSheet.addAction(action1)
            myActionSheet.addAction(action2)
            myActionSheet.addAction(action3)
            myActionSheet.addAction(action4)
            
            if let popoverController = myActionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(myActionSheet, animated: true, completion: nil)
        }
        else if self.bar == true{
            self.nearbySearch = true
            let myActionSheet = UIAlertController()
            let action1 = UIAlertAction(title: "Name", style: .default, handler: { (action) -> Void in
                print("Name selected!")
                self.nearSort = false
                if self.brewery == true{
                    self.pageNo = 1
                    self.breweryData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.barData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.bottleData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBottleList()
                }
            })
            
            let action2 = UIAlertAction(title: "Rating (High to Low)", style: .default, handler: { (action) -> Void in
                self.nearSort = false
                print("Ranking High to Low selected!")
                if self.brewery == true{
                    self.pageNo = 1
                    self.breweryData = NSMutableArray()
                    self.sort_style = "beer_avgRate||DESC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.barData = NSMutableArray()
                    self.sort_style = "avgRate||DESC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.bottleData = NSMutableArray()
                    self.sort_style = "avgRate||DESC"
                    self.fetchBottleList()
                }
            })
            
            let action3 = UIAlertAction(title: "Rating (Low to High)", style: .default, handler: { (action) -> Void in
                self.nearSort = false
                print("Ranking Low to High selected!")
                if self.brewery == true{
                    self.pageNo = 1
                    self.breweryData = NSMutableArray()
                    self.sort_style = "beer_avgRate||ASC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.barData = NSMutableArray()
                    self.sort_style = "avgRate||ASC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.bottleData = NSMutableArray()
                    self.sort_style = "avgRate||ASC"
                    self.fetchBottleList()
                }
            })
            
            let action4 = UIAlertAction(title: "Nearby", style: .default, handler: { (action) -> Void in
                let alertController = UIAlertController(title: "Alert", message: "This feature is only available for your current location. Do you want to see your local results (this will change your search location in the app)?", preferredStyle: UIAlertController.Style.alert) //Replace
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    
                }
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    self.nearSort = true
                    if self.brewery == true{
                        self.pageNo = 1
                        self.breweryData = NSMutableArray()
                        self.sort_style = ""
                    }
                    else if self.bar == true{
                        self.pageNo = 1
                        self.barData = NSMutableArray()
                        self.sort_style = ""
                    }
                    else if self.bottle == true{
                        self.pageNo = 1
                        self.bottleData = NSMutableArray()
                        self.sort_style = ""
                    }
                    self.determineMyCurrentLocation()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
            
            myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            // Add action buttons and present the Alert
            myActionSheet.addAction(action1)
            myActionSheet.addAction(action2)
            myActionSheet.addAction(action3)
            myActionSheet.addAction(action4)
            
            if let popoverController = myActionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(myActionSheet, animated: true, completion: nil)
        }
        else if self.bottle == true{
            self.nearbySearch = true
            let myActionSheet = UIAlertController()
            let action1 = UIAlertAction(title: "Name", style: .default, handler: { (action) -> Void in
                print("Name selected!")
                self.nearSort = false
                if self.brewery == true{
                    self.pageNo = 1
                    self.breweryData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.barData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.bottleData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBottleList()
                }
            })
            
            let action2 = UIAlertAction(title: "Rating(High to Low)", style: .default, handler: { (action) -> Void in
                self.nearSort = false
                print("Ranking High to Low selected!")
                if self.brewery == true{
                    self.pageNo = 1
                    self.breweryData = NSMutableArray()
                    self.sort_style = "beer_avgRate||DESC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.barData = NSMutableArray()
                    self.sort_style = "avgRate||DESC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.bottleData = NSMutableArray()
                    self.sort_style = "avgRate||DESC"
                    self.fetchBottleList()
                }
            })
            
            let action3 = UIAlertAction(title: "Rating(Low to High)", style: .default, handler: { (action) -> Void in
                self.nearSort = false
                print("Ranking Low to High selected!")
                if self.brewery == true{
                    self.pageNo = 1
                    self.breweryData = NSMutableArray()
                    self.sort_style = "beer_avgRate||ASC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.barData = NSMutableArray()
                    self.sort_style = "avgRate||ASC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.bottleData = NSMutableArray()
                    self.sort_style = "avgRate||ASC"
                    self.fetchBottleList()
                }
            })
            
            let action4 = UIAlertAction(title: "Nearby", style: .default, handler: { (action) -> Void in
                let alertController = UIAlertController(title: "Alert", message: "This feature is only available for your current location. Do you want to see your local results (this will change your search location in the app)?", preferredStyle: UIAlertController.Style.alert) //Replace
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    
                }
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    self.nearSort = true
                    if self.brewery == true{
                        self.pageNo = 1
                        self.breweryData = NSMutableArray()
                        self.sort_style = ""
                    }
                    else if self.bar == true{
                        self.pageNo = 1
                        self.barData = NSMutableArray()
                        self.sort_style = ""
                    }
                    else if self.bottle == true{
                        self.pageNo = 1
                        self.bottleData = NSMutableArray()
                        self.sort_style = ""
                    }
                    self.determineMyCurrentLocation()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
            
            myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            // Add action buttons and present the Alert
            myActionSheet.addAction(action1)
            myActionSheet.addAction(action2)
            myActionSheet.addAction(action3)
            myActionSheet.addAction(action4)
            
            if let popoverController = myActionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(myActionSheet, animated: true, completion: nil)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
