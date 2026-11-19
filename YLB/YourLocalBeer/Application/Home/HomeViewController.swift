//
//  HomeViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 13/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView
import PopupDialog
import Alamofire
import SVProgressHUD
import CoreLocation
import TCPickerView

class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,HomeTableViewCellDelegate,HomeBeerTableViewCellDelegate,UIPopoverPresentationControllerDelegate,CLLocationManagerDelegate,TCPickerViewOutput {

    //MARK:- Variable Declaration
    @IBOutlet weak var tblDataList: UITableView!
    @IBOutlet weak var txtSearch: ImageTextField!
    
    var imageArray = NSArray()
    var bar_index = NSInteger()
    
    @IBOutlet weak var btnBreweryOutlet: UIButton!
    @IBOutlet weak var btnBeerOutlet: UIButton!
    @IBOutlet weak var btnBarOutlet: UIButton!
    @IBOutlet weak var btnBottleOutlet: UIButton!
    
    @IBOutlet weak var vwBrewery: UIView!
    @IBOutlet weak var vwBeer: UIView!
    @IBOutlet weak var vwBar: UIView!
    @IBOutlet weak var vwBottle: UIView!
    @IBOutlet weak var vwSort: UIView!
    @IBOutlet weak var btnSortOutlet: UIButton!
    
    var breweryData = NSMutableArray()
    var beerData = NSMutableArray()
    var barData = NSMutableArray()
    var bottleData = NSMutableArray()
        
    var brewery = Bool()
    var beer = Bool()
    var bar = Bool()
    var bottle = Bool()
    
    var fromBeer = Bool()
    var fromBar = Bool()
    var fromBottle = Bool()
    var fromBrewery = Bool()

    var logindict = String()
    var searchlocation = Bool()
    var searchText = String()
    var totalPageCount = Int()
    var pageNo = Int()
    var country = String()
    var city = String()
    var state = String()
    var continent = String()
    var zip = String()
    var continentZip = String()
    
    var fromCategoryPage = Bool()
    var isLoadingTableView = Bool()
    var SelectSpecialityCode = String()
    
    var ambienceValue = String()
    var qualityValue = String()
    var selectionValue = String()
    var staffValue = String()
    var serviceValue = String()
    var value = String()
    var review_id = String()
    var review_comment = String()
    var anonymousStatus = String()
    var foodValue = String()
    var logdict = NSDictionary()
    var login_token = String()
    var barID = String()
    var bottleID = String()
    var beerId = String()
    var noData = Bool()
    @IBOutlet weak var lblTotalDataCount: UILabel!
    var changeLocation = Bool()
    var color = String()
    var sort_style = String()
    var locManager: CLLocationManager!
    var userLat = Double()
    var userLng = Double()
    var nearbySearch = Bool()
    var nearSort = Bool()
    var Latitude = Double()
    var Longitude = Double()
    var styleList = NSArray()
    var styleValue = String()
    var picker: TCPickerViewInput = TCPickerView()
    var geoCoder = CLGeocoder()
    //var placeMark = CLPlacemark()
    var addressString : String = ""
    
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageNo = 1
        self.isLoadingTableView = false
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        if self.brewery == true{
            self.sort_style = "beer_avgRate||ASC"
        }
        else if self.bar == true{
            self.sort_style = "avgRate||DESC"
        }
        else if self.bottle == true{
            self.sort_style = "avgRate||DESC"
        }
        else if self.beer == true{
            self.sort_style = "baRating||DESC"
        }
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logdict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logdict)")
        
        login_token = "\(logdict .value(forKey: "login_token")!)"
        
        let addressData = UserDefaults.standard.object(forKey: "key_currentaddress_info")
        if addressData == nil{
            if (UserDefaults.standard.object(forKey: "key_currentcontinent_info") != nil){
                let currentContinentData = UserDefaults.standard.object(forKey: "key_currentcontinent_info")
                self.continent = NSKeyedUnarchiver.unarchiveObject(with: currentContinentData as! Data) as! String
            }else{
                self.continent = ""
            }
            
            if (UserDefaults.standard.object(forKey: "key_currentdenycountry_info") != nil){
                let currentCountryData = UserDefaults.standard.object(forKey: "key_currentdenycountry_info")
                self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
            }else{
                let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info")
                self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
            }
            
            if (UserDefaults.standard.object(forKey: "key_currentdenystate_info") != nil){
                let stateData = UserDefaults.standard.object(forKey: "key_currentdenystate_info")
                self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
            }else{
                let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info")
                self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
            }
            
            if (UserDefaults.standard.object(forKey: "key_currentdenycity_info") != nil){
                let cityData = UserDefaults.standard.object(forKey: "key_currentdenycity_info")
                self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
            }else{
                let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info")
                self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
            }
            
            
            logindict = "\(city),\(state),\(country),\(continent)"      //ALASKA, 99515-1901"
            print("UserDict: == \(logindict)")
            
        }else{
            if searchlocation == true{
                logindict = searchText
            }else{
                if fromCategoryPage == true || changeLocation == true{
                    if (UserDefaults.standard.object(forKey: "key_currentcontinent_info") != nil){
                        let currentContinentData = UserDefaults.standard.object(forKey: "key_currentcontinent_info")
                        self.continent = NSKeyedUnarchiver.unarchiveObject(with: currentContinentData as! Data) as! String
                    }else{
                        self.continent = ""
                    }
                    
                    if (UserDefaults.standard.object(forKey: "key_currentdenycountry_info") != nil){
                        let currentCountryData = UserDefaults.standard.object(forKey: "key_currentdenycountry_info")
                        self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
                    }else{
                        let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info")
                        self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
                    }
                    
                    if (UserDefaults.standard.object(forKey: "key_currentdenystate_info") != nil){
                        let stateData = UserDefaults.standard.object(forKey: "key_currentdenystate_info")
                        self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
                    }else{
                        let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info")
                        self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
                    }
                    
                    if (UserDefaults.standard.object(forKey: "key_currentdenycity_info") != nil){
                        let cityData = UserDefaults.standard.object(forKey: "key_currentdenycity_info")
                        self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
                    }else{
                        let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info")
                        self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
                    }
                    
                    if continent == "" && country == "" && state == "" && city == ""{
                        logindict = "\(continentZip),\(zip)"
                    }else if continentZip == "" && zip == ""{
                        if continent == "Europe" && country != ""{
                            logindict = "\(continent),\(country)"
                        }else{
                            logindict = "\(city),\(state),\(country)"
                        }
                    }else if continent != "" && country != ""{
                        logindict = "\(continent),\(country)"
                    }else{
                        logindict = "\(city),\(state),\(country)"
                    }
                    print(logindict)
                    
                }else{
                    let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info")
                    country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
                    
                    if  let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info"){
                        state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String

                    }
                    
                    let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info")
                    city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
                    
                    logindict = "\(city),\(state),\(country)"
                    //NSKeyedUnarchiver.unarchiveObject(with: addressData as! Data) as! String
                    print("UserDict: == \(logindict)")
                }
            }
            
        }
        
        self.nearbySearch = false
        self.nearSort = false
        
        if fromBrewery == true{
            self.breweryData = NSMutableArray()
            self.fetchBreweryList()
        }
        if fromBeer == true{
            self.fetchBeerList()
        }
        if fromBar == true{
            pageNo = 1
            barData = NSMutableArray()
            self.fetchBarList()
        }
        if fromBottle == true{
            pageNo = 1
            bottleData = NSMutableArray()
            self.fetchBottleList()
        }
        
        
        login_token = "\(logdict .value(forKey: "login_token")!)"
        self.noData = false
        
        brewery = true
        (tblDataList).register(UINib(nibName:"HomeBeerTableViewCell", bundle: nil), forCellReuseIdentifier: "beerCell")
        
        if fromBrewery == true{
            btnBreweryOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            btnBarOutlet.tintColor = UIColor.black
            btnBottleOutlet.tintColor = UIColor.black
            btnBeerOutlet.tintColor = UIColor.black
            vwBrewery.isHidden = false
            vwBeer.isHidden = true
            vwBar.isHidden = true
            vwBottle.isHidden = true
            brewery = true
            beer = false
            bar = false
            bottle = false
        }else if fromBeer == true{
            btnBeerOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            btnBreweryOutlet.tintColor = UIColor.black
            btnBottleOutlet.tintColor = UIColor.black
            btnBarOutlet.tintColor = UIColor.black
            vwBrewery.isHidden = true
            vwBeer.isHidden = false
            vwBar.isHidden = true
            vwBottle.isHidden = true
            beer = true
            bar = false
            brewery = false
            bottle = false
        }else if fromBar == true{
            btnBarOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            btnBreweryOutlet.tintColor = UIColor.black
            btnBottleOutlet.tintColor = UIColor.black
            btnBeerOutlet.tintColor = UIColor.black
            vwBrewery.isHidden = true
            vwBeer.isHidden = true
            vwBar.isHidden = false
            vwBottle.isHidden = true
            bar = true
            brewery = false
            beer = false
            bottle = false
        }else{
            btnBottleOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            btnBreweryOutlet.tintColor = UIColor.black
            btnBarOutlet.tintColor = UIColor.black
            btnBeerOutlet.tintColor = UIColor.black
            vwBrewery.isHidden = true
            vwBeer.isHidden = true
            vwBar.isHidden = true
            vwBottle.isHidden = false
            bottle = true
            bar = false
            brewery = false
            beer = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logdict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logdict)")
        
        login_token = "\(logdict .value(forKey: "login_token")!)"
        
        let addressData = UserDefaults.standard.object(forKey: "key_currentaddress_info")
        if addressData == nil{
            if (UserDefaults.standard.object(forKey: "key_currentcontinent_info") != nil){
                let currentContinentData = UserDefaults.standard.object(forKey: "key_currentcontinent_info")
                self.continent = NSKeyedUnarchiver.unarchiveObject(with: currentContinentData as! Data) as! String
            }else{
                self.continent = ""
            }
            
            if (UserDefaults.standard.object(forKey: "key_currentdenycountry_info") != nil){
                let currentCountryData = UserDefaults.standard.object(forKey: "key_currentdenycountry_info")
                self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
            }else{
                let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info")
                self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
            }
            
            if (UserDefaults.standard.object(forKey: "key_currentdenystate_info") != nil){
                let stateData = UserDefaults.standard.object(forKey: "key_currentdenystate_info")
                self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
            }else{
                let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info")
                self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
            }
            
            if (UserDefaults.standard.object(forKey: "key_currentdenycity_info") != nil){
                let cityData = UserDefaults.standard.object(forKey: "key_currentdenycity_info")
                self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
            }else{
                let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info")
                self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
            }
            
            
            logindict = "\(continent),\(country),\(state),\(city),\(zip)"                       //ALASKA, 99515-1901"
            print("UserDict: == \(logindict)")
            
        }else{
            if searchlocation == true{
                logindict = searchText
            }else{
                if fromCategoryPage == true || changeLocation == true{
                    if (UserDefaults.standard.object(forKey: "key_currentcontinent_info") != nil){
                        let currentContinentData = UserDefaults.standard.object(forKey: "key_currentcontinent_info")
                        self.continent = NSKeyedUnarchiver.unarchiveObject(with: currentContinentData as! Data) as! String
                    }else{
                        self.continent = ""
                    }
                    
                    if (UserDefaults.standard.object(forKey: "key_currentdenycountry_info") != nil){
                        let currentCountryData = UserDefaults.standard.object(forKey: "key_currentdenycountry_info")
                        self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
                    }else{
                        let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info")
                        self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
                    }
                    
                    if (UserDefaults.standard.object(forKey: "key_currentdenystate_info") != nil){
                        let stateData = UserDefaults.standard.object(forKey: "key_currentdenystate_info")
                        self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
                    }else{
                        let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info")
                        self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
                    }
                    
                    if (UserDefaults.standard.object(forKey: "key_currentdenycity_info") != nil){
                        let cityData = UserDefaults.standard.object(forKey: "key_currentdenycity_info")
                        self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
                    }else{
                        let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info")
                        self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
                    }
                    
                    if continent == "" && country == "" && state == "" && city == ""{
                        logindict = "\(continentZip),\(zip)"
                    }else if continentZip == "" && zip == ""{
                        if continent == "Europe" && country != ""{
                            logindict = "\(continent),\(country)"
                        }else{
                            logindict = "\(city),\(state),\(country)"
                        }
                    }else if continent != "" && country != ""{
                        logindict = "\(continent),\(country)"
                    }else{
                        logindict = "\(city),\(state),\(country)"
                    }
                    print(logindict)
                    
                }else{
                    
                    
                    if let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info"){
                        country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String

                    }
                    
                    if let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info"){
                        state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String

                    }

                    if let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info"){
                        city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String

                    }
                    
                    logindict = "\(city),\(state),\(country)"
                    //NSKeyedUnarchiver.unarchiveObject(with: addressData as! Data) as! String
                    print("UserDict: == \(logindict)")
                }
            }
            
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.navigationItem.setHidesBackButton(false, animated:true);
        
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "magnifying-glass"), style:  UIBarButtonItem.Style.plain, target: self, action: #selector(HomeViewController.barButtonClickAction))
        
        self.setupNavigationTitle()
        
    }
    
    func setupNavigationTitle(){
        // Only execute the code if there's a navigation controller
        if self.navigationController == nil {
            return
        }
        
        // Create a navView to add to the navigation bar
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = "\(logindict)"
        label.sizeToFit()
        label.center = navView.center
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textAlignment = NSTextAlignment.center
        label.frame = CGRect(x: -110, y: -15, width: 250, height: 25)
        
        // Create the image view
        let image = UIImageView()
        image.image = UIImage(named: "Location-Black")
        // To maintain the image's aspect ratio:
        let imageAspect = image.image!.size.width/image.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(image)
        
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView
        
        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        if let nav = self.navigationController {
            let isPopping = !nav.viewControllers.contains(self)
            if isPopping {

                for controller in self.navigationController!.viewControllers as Array
                {
                    if controller.isKind(of: CategoryViewController.self)
                    {
                        if self.nearbySearch == true{
                            let myVC = self.navigationController!.viewControllers[(self.navigationController?.viewControllers.count)! - 1] as! CategoryViewController
                            myVC.changeLocation = false
                            myVC.fromCategoryPage = false
                            self.navigationController?.popToViewController(myVC, animated: true)
                        }else{
                            let myVC = self.navigationController!.viewControllers[(self.navigationController?.viewControllers.count)! - 1] as! CategoryViewController
                            self.navigationController?.popToViewController(myVC, animated: true)
                        }
                        break
                    }
                }
                // popping off nav
            } else {
                // on nav, not popping off (pushing past, being presented over, etc.)
            }
        } else {
            // not on nav at all
        }
    }
 
    
    //MARK:- Search Button Action
    @objc func barButtonClickAction() {
        print("Button click...")
        let SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        self.navigationController?.pushViewController(SearchViewController, animated: true)
    }
    
    //MARK:- Fetch Brewery List
    
    func fetchBreweryList(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "breweries"
        
        let newTodo: [String: Any] = ["continent": continent,"country": country,"region": state,"city": city,"continentZip": continentZip,"zip_code": zip,"page_number": pageNo,"sort":self.sort_style,"latitude": self.userLat,"longitude": self.userLng]

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
                self.lblTotalDataCount.text = "Total No. of Breweries: \((json["total"] as! NSNumber).intValue)"
                if((json["brewries"] as! Array<Any>).count>0){
                    self.isLoadingTableView = true
                    self.breweryData.addObjects(from: ((json["brewries"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                }else{
                    self.noData = true
                    self.isLoadingTableView = false
                }
                self.tblDataList.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Fetch Bar List
    
    func fetchBarList(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "bars"
        
        let newTodo: [String: Any] = ["continent": continent,"country": country,"region": state,"city": city,"continentZip": continentZip,"zip_code": zip,"page_number": pageNo,"type": "bars","sort":self.sort_style,"latitude": self.userLat,"longitude": self.userLng]
        
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
                self.lblTotalDataCount.text = "Total No. of Bars & Restaurants: \((json["total"] as! NSNumber).intValue)"
                if((json["bars"] as! Array<Any>).count>0){
                    self.isLoadingTableView = true
                    self.barData.addObjects(from: ((json["bars"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                }else{
                    self.noData = true
                    self.isLoadingTableView = false
                }
                self.tblDataList.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Fetch Bottle List
    
    func fetchBottleList(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "bars"
        
        let newTodo: [String: Any] = ["continent": continent,"country": country,"region": state,"city": city,"continentZip": continentZip,"zip_code": zip,"page_number": pageNo,"type": "bottleshop","sort":self.sort_style,"latitude": self.userLat,"longitude": self.userLng]
        
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
                self.lblTotalDataCount.text = "Total No. of Bottle Shops: \((json["total"] as! NSNumber).intValue)"
                if((json["bars"] as! Array<Any>).count>0){
                    self.isLoadingTableView = true
                    self.bottleData.addObjects(from: ((json["bars"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                }else{
                    self.noData = true
                    self.isLoadingTableView = false
                }
                self.tblDataList.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Fetch Beer List
    
    func fetchBeerList(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "beer_list"
        
        let newTodo: [String: Any] = ["continent": continent,"country": country,"region": state,"city": city,"continentZip": continentZip,"zip_code": zip,"page_number": pageNo,"sort":self.sort_style,"style":self.styleValue]
        
        print("Parameter:== \(newTodo)")
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                print("JSON: \(json)")
                
                if((json["beers"] as! Array<Any>).count>0){
                    
                    if (((json["total"] as! NSNumber).intValue) > 50){
                        if self.styleValue == ""{
                            self.lblTotalDataCount.text = "Top 50 Beers in \(self.city)"
                        }else{
                            self.lblTotalDataCount.text = "Top 50 \(self.styleValue)s"
                        }
                    }else{
                        if self.styleValue == ""{
                            self.lblTotalDataCount.text = "Top \((json["total"] as! NSNumber).intValue) Beers in \(self.city)"
                        }else{
                            if(((json["total"] as! NSNumber).intValue) > 1){
                                self.lblTotalDataCount.text = "Top \((json["total"] as! NSNumber).intValue) \(self.styleValue)s"
                            }else{
                                self.lblTotalDataCount.text = "Top \((json["total"] as! NSNumber).intValue) \(self.styleValue)"
                            }
                        }
                    }
                    self.isLoadingTableView = true
                    self.beerData.addObjects(from: ((json["beers"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                }else{
                    self.noData = true
                    self.isLoadingTableView = false
                }
                self.tblDataList.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    
    //MARK: - TableView Deleagte/DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if brewery == true{
            return 175
        }else if beer == true{
            return 170
        }else if bar == true{
            return 175
        }else if bottle == true{
            return 175
        }
        else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if brewery == true{
            if(breweryData.count == 0){
                return 1
            }else{
                return breweryData.count
            }
        }else if beer == true{
            if(beerData.count == 0){
                return 1
            }else{
                return beerData.count
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
                    
                    cell = tblDataList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
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
                print(infoDic)
                
                cell.lblName.text = "\(infoDic["name"]!)"
                
                if self.nearbySearch == true{
                     if let distance = infoDic["distance"] as? NSNumber {
                        let doubleStr = Double(truncating: distance).rounded(toPlaces: 1)
                        print(doubleStr)
                        cell.lblDistance.text = (String(format: "%.1f Miles",doubleStr))
                     }
                     else if let distance = infoDic["distance"] as? String {
                        cell.lblDistance.text = (String(format: "%.1f Miles",distance))
                     }
                }else{
                    cell.lblDistance.text = ""
                }

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
                
                cell.lblCount.text = String(indexPath.row + 1)
                
                if "\(infoDic["phone"]!)" == ""{
                    cell.lblPhone.text = "N/A"
                }else{
                    cell.lblPhone.text = "\(infoDic["phone"]!)"
                }
                cell.vwCategoryImage.image = UIImage(named: "Brewrie.png")
                cell.delegate = self
                cell.index = indexPath.row
                cell.btnRateOutlet.isHidden = true
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
                
                if (indexPath.row == self.breweryData.count - 1) && self.isLoadingTableView == true
                {
                    pageNo = pageNo + 1;
                    self.fetchBreweryList()
                }
                
                return cell
            }
        }
        else if bar == true{
            if (barData.count == 0){
                
                var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                    
                    cell = tblDataList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
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
                let cell = tblDataList.dequeueReusableCell(withIdentifier:"homeCell", for: indexPath)as! HomeTableViewCell
               
                let infoDic = ((self.barData) .object(at: indexPath.row) as! NSDictionary)
                
                if self.nearbySearch == true{
                     if let distance = infoDic["distance"] as? NSNumber {
                        let doubleStr = Double(truncating: distance).rounded(toPlaces: 1)
                        print(doubleStr)
                        cell.lblDistance.text = (String(format: "%.1f Miles",doubleStr))
                     }
                     else if let distance = infoDic["distance"] as? String {
                        cell.lblDistance.text = (String(format: "%.1f Miles",distance))
                     }
                }else{
                    cell.lblDistance.text = ""
                }
                
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
                cell.lblCount.text = String(indexPath.row + 1)
                if "\(infoDic["phone"]!)" == ""{
                    cell.lblPhone.text = "N/A"
                }else{
                    cell.lblPhone.text = "\(infoDic["phone"]!)"
                }
                cell.vwCategoryImage.image = UIImage(named: "restaurent-bar.png")
                cell.delegate = self
                cell.index = indexPath.row
                cell.btnRateOutlet.isHidden = true
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
                
                if indexPath.row == self.barData.count - 1 && self.isLoadingTableView == true
                {
                    pageNo = pageNo + 1;
                    self.fetchBarList()
                }
                
                return cell
            }
        }
        else if beer == true{
              if (beerData.count == 0){
                var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell

                if cell == nil {

                    tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")

                    cell = tblDataList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
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
              }
              else{
                let cell = tblDataList.dequeueReusableCell(withIdentifier:"beerCell", for: indexPath)as! HomeBeerTableViewCell
                
                let infoDic = ((self.beerData) .object(at: indexPath.row) as! NSDictionary)
                
                cell.lblCount.text = String(indexPath.row + 1)
                
                cell.beerName.text = "\(infoDic["name"]!)"
                cell.beerType.text = "\(infoDic["brewery"]!)"
                cell.beerStyle.text = "\(infoDic["style"]!)"
                
                let rateVal = Double("\(infoDic["baRating"]!)")
                cell.lblRating.text =  String(format: "%.1f/10", rateVal!)
                cell.lblRatingCount.text = "\(infoDic["baHads"]!) Ratings"
                cell.viewRating.value = CGFloat(Float((infoDic["baRating"] as! NSNumber).floatValue))
                cell.delegate = self
                cell.index = indexPath.row
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.btnRateOutlet.isHidden = true
                let hads = Int("\(infoDic["baHads"]!)")
                
                if hads! >= 10{
                    cell.lblRating.isHidden = false
                    cell.lblNoScore.isHidden = true
                    cell.viewRating.isHidden = false
                    cell.lblRatingCount.isHidden = false
                    cell.viewRating.value = CGFloat(Float((infoDic["baRating"] as! NSNumber).floatValue))
                    let rateVal = Double("\(infoDic["baRating"]!)")
                    cell.lblRating.text =  String(format: "%.1f/10", rateVal!)
                    cell.lblRatingCount.text = "\(infoDic["baHads"]!) Ratings"
                    cell.lblRating.backgroundColor = UIColor(red: 53.0/255.0, green: 125.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                }else if hads! > 0{
                    cell.lblRating.isHidden = false
                    cell.lblNoScore.isHidden = true
                    cell.viewRating.isHidden = false
                    cell.lblRatingCount.isHidden = false
                    cell.viewRating.value = CGFloat(Float((infoDic["baRating"] as! NSNumber).floatValue))
                    let rateVal = Double("\(infoDic["baRating"]!)")
                    cell.lblRating.text =  String(format: "%.1f/10", rateVal!)
                    cell.lblRatingCount.text = "\(infoDic["baHads"]!) Ratings"
                    cell.lblRating.backgroundColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
                }else{
                    cell.lblNoScore.isHidden = false
                    cell.viewRating.isHidden = true
                    cell.lblRatingCount.isHidden = true
                    cell.lblRating.isHidden = true
                    cell.lblNoScore.backgroundColor = UIColor.red
                    cell.lblNoScore.text = "No score yet"
                }
                if indexPath.row == self.beerData.count - 1 && self.isLoadingTableView == true
                {
                    if self.beerData.count == 50{
                        
                    }else{
                        pageNo = pageNo + 1;
                        self.fetchBeerList()
                    }
                }
                return cell
              }
        }
        else if bottle == true{
            if (bottleData.count == 0){
                var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
    
                if cell == nil {
    
                    tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
    
                    cell = tblDataList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
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
                let cell = tblDataList.dequeueReusableCell(withIdentifier:"homeCell", for: indexPath)as! HomeTableViewCell

                let infoDic = ((self.bottleData) .object(at: indexPath.row) as! NSDictionary)
                
                if self.nearbySearch == true{
                     if let distance = infoDic["distance"] as? NSNumber {
                        let doubleStr = Double(truncating: distance).rounded(toPlaces: 1)
                        print(doubleStr)
                        cell.lblDistance.text = (String(format: "%.1f Miles",doubleStr))
                     }
                     else if let distance = infoDic["distance"] as? String {
                        cell.lblDistance.text = (String(format: "%.1f Miles",distance))
                     }
                }else{
                    cell.lblDistance.text = ""
                }
                
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
                cell.lblCount.text = String(indexPath.row + 1)
                if "\(infoDic["phone"]!)" == ""{
                    cell.lblPhone.text = "N/A"
                }else{
                    cell.lblPhone.text = "\(infoDic["phone"]!)"
                }
                cell.vwCategoryImage.image = UIImage(named: "bottle-shop.png")
                cell.delegate = self
                cell.index = indexPath.row
                cell.btnRateOutlet.isHidden = true
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
                if indexPath.row == self.bottleData.count - 1 && self.isLoadingTableView == true
                {
                    pageNo = pageNo + 1;
                    print("Page:== \(pageNo)")
                    self.fetchBottleList()
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
//
//        if indexPath.row == breweryData.count - 1 && self.isLoadingTableView == true// last cell
//        {
//            pageNo = pageNo + 1;
//            print("Page:== \(pageNo)")
//            self.self.fetchBreweryList()
//        }else if indexPath.row == self.barData.count - 1 && self.isLoadingTableView == true
//        {
//            pageNo = pageNo + 1;
//            self.fetchBarList()
//        }
//    }
    
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if(brewery == true){
//            cell.alpha = 0
//
//            UIView.animate(
//                withDuration: 0.1,
//                delay: 0.01 * Double(indexPath.row),
//                animations: {
//                    cell.alpha = 1
//            })
//            let animation = AnimationFactory.makeSlideIn(duration: 0.2, delayFactor: 0.02)
//            let animator = Animator(animation: animation)
//            animator.animate(cell: cell, at: indexPath, in: tableView)
            print("\(indexPath.row)")
            print("\(self.breweryData.count)")
            if indexPath.row == self.breweryData.count - 1 && self.isLoadingTableView == true// last cell
            {
                pageNo = pageNo + 1;
                print("Page:== \(pageNo)")
                self.fetchBreweryList()
            }
        }
        else if bar == true{
            if indexPath.row == self.barData.count - 1 && self.isLoadingTableView == true// last cell
            {
                pageNo = pageNo + 1;
                print("Page:== \(pageNo)")
                self.fetchBarList()
            }
        }
        else if beer == true{
            if indexPath.row == self.beerData.count - 1 && self.isLoadingTableView == true// last cell
            {
                pageNo = pageNo + 1;
                print("Page:== \(pageNo)")
                self.fetchBeerList()
            }
        }else if bottle == true{
            if indexPath.row == self.bottleData.count - 1 && self.isLoadingTableView == true// last cell
            {
                pageNo = pageNo + 1;
                print("Page:== \(pageNo)")
                self.fetchBottleList()
            }
        }
    }
 */
    
    //MARK:- Custom Delegate Methods
    func HomeBeerTableViewCell(_ obj: HomeBeerTableViewCell, info index: Int)
    {
        let BeerDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerDetail") as! BeerDetailViewController
        let infoDic = ((self.beerData) .object(at: index) as! NSDictionary)
        BeerDetailViewController.beerID = "\(infoDic["_id"]!)"
        BeerDetailViewController.BeerName = "\(infoDic["name"]!)"
        BeerDetailViewController.BreweryName = "\(infoDic["brewery"]!)"
        BeerDetailViewController.Style = "\(infoDic["style"]!)"
        self.navigationController?.pushViewController(BeerDetailViewController, animated: true)
    }
    
    func HomeBeerTableViewCell(_ obj: HomeBeerTableViewCell, rate index: Int)
    {
        print("Rate tapped of Index: \(index)")
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.rateActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
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
            let BarDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetailViewController
            let infoDic = ((self.barData) .object(at: index) as! NSDictionary)
            BarDetailViewController.barID = (infoDic["_id"] as? String)!
            BarDetailViewController.BarName = "\(infoDic["name"]!)"
            BarDetailViewController.BarAddress = "\(infoDic["address"]!)"
            self.navigationController?.pushViewController(BarDetailViewController, animated: true)
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
        if bar == true{
            print("Rate tapped of Index: \(index)")
            let infoDic = ((self.barData) .object(at: index) as! NSDictionary)
            barID = (infoDic["_id"] as? String)!
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
            let currentAction = UIAlertAction(title: "", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in })
            alert.addAction(currentAction)
            self.rateActionSheet()
            self.present(alert, animated: true, completion: nil)
        }else if bottle == true{
            print("Rate tapped of Index: \(index)")
            let infoDic = ((self.bottleData) .object(at: index) as! NSDictionary)
            bottleID = (infoDic["_id"] as? String)!
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
            let currentAction = UIAlertAction(title: "", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in })
            alert.addAction(currentAction)
            self.rateActionSheet()
            self.present(alert, animated: true, completion: nil)
        }else if beer == true{
            print("Rate tapped of Index: \(index)")
            let infoDic = ((self.beerData) .object(at: index) as! NSDictionary)
            beerId = (infoDic["_id"] as? String)!
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
            let currentAction = UIAlertAction(title: "", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in })
            alert.addAction(currentAction)
            self.rateActionSheet()
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    //MARK:- OPEN RATE METHODS
    func rateActionSheet() {
        let myActionSheet = UIAlertController()
        myActionSheet.view.layer.cornerRadius = 25
        
        let googleAction = UIAlertAction(title: "Quick Rate", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openRateView()
        })
        let appleAction = UIAlertAction(title: "Review", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openReview()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        myActionSheet.addAction(googleAction)
        myActionSheet.addAction(appleAction)
        myActionSheet.addAction(cancelAction)
        
        if let popoverController = myActionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func openRateView(){
        
        
            // Create a custom view controller
            let rateVC = RateViewController(nibName: "RateViewController", bundle: nil)
            
            // Create the dialog
            let popup = PopupDialog(viewController: rateVC,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .bounceDown,
                                    tapGestureDismissal: true,
                                    panGestureDismissal: false)
            
            // Create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 60) {
                //self.label.text = "You canceled the rating dialog"
                //rateVC.textFieldShouldReturn(rateVC.commentTextField)
            }
            
            // Create second button
            let buttonTwo = DefaultButton(title: "SAVE", height: 60) {
                //self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
                print(rateVC.lblAppearanceValue.text!)
            }
            
            // Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])
            
            // Present dialog
            present(popup, animated: true, completion: nil)
    }
    
    func openReview(){
        if fromBar == true{
            // Create a custom view controller
            let rateVC = BottleshopRateViewController(nibName: "BottleshopRateViewController", bundle: nil)
            rateVC.fromBottleBeer = "bar"
            
            // Create the dialog
            let popup = PopupDialog(viewController: rateVC,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .bounceDown,
                                    tapGestureDismissal: true,
                                    panGestureDismissal: false)
            
            // Create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 60) {
                //self.label.text = "You canceled the rating dialog"
                //rateVC.textFieldShouldReturn(rateVC.commentTextField)
            }
            
            // Create second button
            let buttonTwo = DefaultButton(title: "SAVE", height: 60) {
                //self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
                print(rateVC.lblAmbienceValue.text!)
                print(rateVC.lblQualityValue.text!)
                print(rateVC.lblSelectionValue.text!)
                print(rateVC.lblStaffValue.text!)
                print(rateVC.lblFoodValue.text!)
                print(rateVC.lblValue.text!)
                print(rateVC.anonymousStatus)
                
                
                self.ambienceValue = rateVC.lblAmbienceValue.text!
                self.qualityValue = rateVC.lblQualityValue.text!
                self.selectionValue = rateVC.lblSelectionValue.text!
                self.staffValue = rateVC.lblStaffValue.text!
                self.foodValue = rateVC.lblFoodValue.text!
                self.value = rateVC.lblValue.text!
                self.review_comment = rateVC.txtComment.text!
                self.anonymousStatus = rateVC.anonymousStatus
                
                self.giveReview()
             }
                //Add buttons to dialog
                popup.addButtons([buttonOne, buttonTwo])
        
                // Present dialog
                present(popup, animated: true, completion: nil)
        }else if fromBottle == true{
            // Create a custom view controller
            let rateVC = BottleshopRateViewController(nibName: "BottleshopRateViewController", bundle: nil)
            rateVC.fromBottleBeer = "bottle"

            // Create the dialog
            let popup = PopupDialog(viewController: rateVC,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .bounceDown,
                                    tapGestureDismissal: true,
                                    panGestureDismissal: false)

            // Create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 60) {
                //self.label.text = "You canceled the rating dialog"
                //rateVC.textFieldShouldReturn(rateVC.commentTextField)
            }

            // Create second button
            let buttonTwo = DefaultButton(title: "SAVE", height: 60) {
                //self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
                print(rateVC.lblAmbienceValue.text!)
                print(rateVC.lblQualityValue.text!)
                print(rateVC.lblSelectionValue.text!)
                print(rateVC.lblStaffValue.text!)
                print(rateVC.lblFoodValue.text!)
                print(rateVC.lblValue.text!)


                self.ambienceValue = rateVC.lblAmbienceValue.text!
                self.qualityValue = rateVC.lblQualityValue.text!
                self.selectionValue = rateVC.lblSelectionValue.text!
                self.staffValue = rateVC.lblStaffValue.text!
                self.serviceValue = rateVC.lblFoodValue.text!
                self.value = rateVC.lblValue.text!
                self.review_comment = rateVC.txtComment.text!
                self.anonymousStatus = rateVC.anonymousStatus

                self.giveReview()
            }
             //Add buttons to dialog
             popup.addButtons([buttonOne, buttonTwo])
    
            // Present dialog
            present(popup, animated: true, completion: nil)
        }else{
            // Create a custom view controller
            let reviewVC = ReviewViewController(nibName: "ReviewViewController", bundle: nil)

            // Create the dialog
            let popup = PopupDialog(viewController: reviewVC,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .bounceDown,
                                    tapGestureDismissal: true,
                                    panGestureDismissal: false)

            // Create first button
            let buttonOne = CancelButton(title: "CANCEL", height: 60) {
                //self.label.text = "You canceled the rating dialog"
                //reviewVC.textFieldShouldReturn(reviewVC.commentTextField)
            }

            // Create second button
            let buttonTwo = DefaultButton(title: "REVIEW", height: 60) {
                //self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
                //self.label.text = ratingVC.commentTextField.text
                //print(reviewVC.commentTextField.text!)
            }

            // Add buttons to dialog
            popup.addButtons([buttonOne, buttonTwo])

            // Present dialog
            present(popup, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK:- Button Actions
    @IBAction func btnBreweryDidTap(_ sender: Any) {
        self.pageNo = 1
        self.breweryData = NSMutableArray()
        btnBreweryOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBarOutlet.tintColor = UIColor.black
        btnBottleOutlet.tintColor = UIColor.black
        btnBeerOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = false
        vwBeer.isHidden = true
        vwBar.isHidden = true
        vwBottle.isHidden = true
        brewery = true
        beer = false
        bar = false
        bottle = false
        self.sort_style = ""
        self.userLat = 0
        self.userLng = 0
        if self.nearbySearch == true{
            self.nearbySearch = true
        }else{
            self.nearbySearch = false
        }
        
        self.fetchBreweryList()
        self.tblDataList.reloadData()
    }
    
    @IBAction func btnBeerDidTap(_ sender: Any) {
        self.pageNo = 1
        self.beerData = NSMutableArray()
        btnBeerOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBreweryOutlet.tintColor = UIColor.black
        btnBottleOutlet.tintColor = UIColor.black
        btnBarOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = true
        vwBeer.isHidden = false
        vwBar.isHidden = true
        vwBottle.isHidden = true
        beer = true
        bar = false
        brewery = false
        bottle = false
        self.sort_style = ""
        self.fetchBeerList()
        tblDataList.reloadData()
    }
    
    @IBAction func btnBarDidTap(_ sender: Any) {
        self.pageNo = 1
        self.barData = NSMutableArray()
        btnBarOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBreweryOutlet.tintColor = UIColor.black
        btnBottleOutlet.tintColor = UIColor.black
        btnBeerOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = true
        vwBeer.isHidden = true
        vwBar.isHidden = false
        vwBottle.isHidden = true
        bar = true
        brewery = false
        beer = false
        bottle = false
        self.sort_style = ""
        self.userLat = 0
        self.userLng = 0
        if self.nearbySearch == true{
            self.nearbySearch = true
        }else{
            self.nearbySearch = false
        }
        self.fetchBarList()
        tblDataList.reloadData()
    }
    
    @IBAction func btnBottleDidTap(_ sender: Any) {
        self.pageNo = 1
        self.bottleData = NSMutableArray()
        btnBottleOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBreweryOutlet.tintColor = UIColor.black
        btnBarOutlet.tintColor = UIColor.black
        btnBeerOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = true
        vwBeer.isHidden = true
        vwBar.isHidden = true
        vwBottle.isHidden = false
        bottle = true
        bar = false
        brewery = false
        beer = false
        self.sort_style = ""
        self.userLat = 0
        self.userLng = 0
        if self.nearbySearch == true{
            self.nearbySearch = true
        }else{
            self.nearbySearch = false
        }
        self.fetchBottleList()
        self.tblDataList.reloadData()
    }
    
    @IBAction func btnMapResults(_ sender: Any) {
        if brewery == true{
            let MapPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapPage") as! MapPageViewController
            MapPageViewController.fromBrewery = self.fromBrewery
            MapPageViewController.fromCategoryPage = self.fromCategoryPage
            MapPageViewController.changeLocation = self.changeLocation
            self.navigationController?.pushViewController(MapPageViewController, animated: true)
        }
        else if beer == true{
//            let MapPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapPage") as! MapPageViewController
//            MapPageViewController.fromBeer = self.fromBeer
//            MapPageViewController.fromCategoryPage = self.fromCategoryPage
//            self.navigationController?.pushViewController(MapPageViewController, animated: true)
        }
        else if bar == true{
            let MapPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapPage") as! MapPageViewController
            MapPageViewController.fromBar = self.bar
            MapPageViewController.fromCategoryPage = self.fromCategoryPage
            MapPageViewController.changeLocation = self.changeLocation
            self.navigationController?.pushViewController(MapPageViewController, animated: true)
        }
        else if bottle == true{
            let MapPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapPage") as! MapPageViewController
            MapPageViewController.fromBottle = self.bottle
            MapPageViewController.fromCategoryPage = self.fromCategoryPage
            MapPageViewController.changeLocation = self.changeLocation
            self.navigationController?.pushViewController(MapPageViewController, animated: true)
        }
    }
    
    //MARK:- Sort Button Action
    @IBAction func btnSortByDidTap(_ sender: Any) {
        
        if brewery == true{
            let myActionSheet = UIAlertController()
            let action1 = UIAlertAction(title: "Name", style: .default, handler: { (action) -> Void in
                print("Name selected!")
                self.nearbySearch = false
                if self.brewery == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.breweryData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.barData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.bottleData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBottleList()
                }
                else if self.beer == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.beerData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBeerList()
                }
                
            })
            
            let action2 = UIAlertAction(title: "Rating (High to Low)", style: .default, handler: { (action) -> Void in
                self.nearbySearch = false
                print("Ranking High to Low selected!")
                if self.brewery == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.breweryData = NSMutableArray()
                    self.sort_style = "beer_avgRate||DESC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.barData = NSMutableArray()
                    self.sort_style = "avgRate||DESC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.bottleData = NSMutableArray()
                    self.sort_style = "avgRate||DESC"
                    self.fetchBottleList()
                }
                else if self.beer == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.beerData = NSMutableArray()
                    self.sort_style = "baRating||DESC"
                    self.fetchBeerList()
                }
            })
            
            let action3 = UIAlertAction(title: "Rating (Low to High)", style: .default, handler: { (action) -> Void in
                self.nearbySearch = false
                print("Ranking Low to High selected!")
                if self.brewery == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.breweryData = NSMutableArray()
                    self.sort_style = "beer_avgRate||ASC"
                    self.fetchBreweryList()
                }
                else if self.bar == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.barData = NSMutableArray()
                    self.sort_style = "avgRate||ASC"
                    self.fetchBarList()
                }
                else if self.bottle == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.bottleData = NSMutableArray()
                    self.sort_style = "avgRate||ASC"
                    self.fetchBottleList()
                }
                else if self.beer == true{
                    self.pageNo = 1
                    self.userLat = 0.0
                    self.userLng = 0.0
                    self.beerData = NSMutableArray()
                    self.sort_style = "baRating||ASC"
                    self.fetchBeerList()
                }
            })
            
            let action4 = UIAlertAction(title: "Nearby", style: .default, handler: { (action) -> Void in
                let alertController = UIAlertController(title: "Attention", message: "This feature is only available for your current location. Do you want to see your local results (this will change your search location in the app)?", preferredStyle: UIAlertController.Style.alert) //Replace
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    
                }
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    self.nearbySearch = true
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
            self.nearbySearch = false
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
                else if self.beer == true{
                    self.pageNo = 1
                    self.beerData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBeerList()
                }
                
            })
            
            let action2 = UIAlertAction(title: "Rating (High to Low)", style: .default, handler: { (action) -> Void in
                self.nearbySearch = false
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
                else if self.beer == true{
                    self.pageNo = 1
                    self.beerData = NSMutableArray()
                    self.sort_style = "baRating||DESC"
                    self.fetchBeerList()
                }
            })
            
            let action3 = UIAlertAction(title: "Rating (Low to High)", style: .default, handler: { (action) -> Void in
                self.nearbySearch = false
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
                else if self.beer == true{
                    self.pageNo = 1
                    self.beerData = NSMutableArray()
                    self.sort_style = "baRating||ASC"
                    self.fetchBeerList()
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
                    self.nearbySearch = true
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
            
            let myActionSheet = UIAlertController()
            let action1 = UIAlertAction(title: "Name", style: .default, handler: { (action) -> Void in
                print("Name selected!")
                self.nearbySearch = false
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
                else if self.beer == true{
                    self.pageNo = 1
                    self.beerData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.fetchBeerList()
                }
                
            })
            
            let action2 = UIAlertAction(title: "Rating(High to Low)", style: .default, handler: { (action) -> Void in
                self.nearbySearch = false
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
                else if self.beer == true{
                    self.pageNo = 1
                    self.beerData = NSMutableArray()
                    self.sort_style = "baRating||DESC"
                    self.fetchBeerList()
                }
            })
            
            let action3 = UIAlertAction(title: "Rating(Low to High)", style: .default, handler: { (action) -> Void in
                self.nearbySearch = false
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
                else if self.beer == true{
                    self.pageNo = 1
                    self.beerData = NSMutableArray()
                    self.sort_style = "baRating||ASC"
                    self.fetchBeerList()
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
                    self.nearbySearch = true
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
        else if beer == true{
            self.nearbySearch = false
            let myActionSheet = UIAlertController()
            let action1 = UIAlertAction(title: "Name", style: .default, handler: { (action) -> Void in
                print("Name selected!")
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
                else if self.beer == true{
                    self.pageNo = 1
                    self.beerData = NSMutableArray()
                    self.sort_style = "name||ASC"
                    self.styleValue = ""
                    self.fetchBeerList()
                }
                
            })
            
            let action2 = UIAlertAction(title: "Rating(High to Low)", style: .default, handler: { (action) -> Void in
                self.nearbySearch = false
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
                else if self.beer == true{
                    self.pageNo = 1
                    self.beerData = NSMutableArray()
                    self.styleValue = ""
                    self.sort_style = "baRating||DESC"
                    self.fetchBeerList()
                }
            })
            
            let action3 = UIAlertAction(title: "Rating(Low to High)", style: .default, handler: { (action) -> Void in
                self.nearbySearch = false
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
                else if self.beer == true{
                    self.pageNo = 1
                    self.beerData = NSMutableArray()
                    self.styleValue = ""
                    self.sort_style = "baRating||ASC"
                    self.fetchBeerList()
                }
            })
            
            let action4 = UIAlertAction(title: "Style", style: .default, handler: { (action) -> Void in
                self.nearbySearch = false
                self.fetchStyleList()
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
    
    //MARK:- Fetch Style List
    
    func fetchStyleList()
    {
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "styles"
        
        let newTodo: [String: Any] = ["latitude": "36.174465","longitude": "-86.767960"]
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
                self.styleList = (json["data"] as! NSArray).mutableCopy() as! NSMutableArray
                self.showPicker()
                SVProgressHUD.dismiss()
        }
    }
    
    
    //MARK:- Show style picker
    
    func showPicker(){
        picker.title = "Styles"
        let values = self.styleList.map { TCPickerView.Value(title: $0 as! String) }
        picker.values = values
        picker.delegate = self
        picker.selection = .single
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                print(values[i].title)
                //self.styleValue = values[i].title
                self.pageNo = 1
                self.beerData = NSMutableArray()
                self.sort_style = "baRating||DESC"
                self.fetchBeerList()
            }
        }
        
        picker.closeAction = {
            self.styleValue = ""
            self.sort_style = ""
            self.pageNo = 1
            self.beerData = NSMutableArray()
            self.fetchBeerList()
        }
        picker.show()
    }
    
    //MARK:- Picker view Delegate/DataSource
    
    func pickerView(_ pickerView: TCPickerViewInput, didSelectRowAtIndex index: Int) {
        print("Uuser select row at index: \(index)")
        self.styleValue = (self.styleList[index] as? String)!
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
                    self.locManager = CLLocationManager()
                    self.locManager.delegate = self
                    self.locManager.desiredAccuracy = kCLLocationAccuracyBest
                    locManager.startUpdatingLocation()
            @unknown default:
                fatalError()
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
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.userLat = userLocation.coordinate.latitude
        self.userLng = userLocation.coordinate.longitude
        
        
       geoCoder.reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            let pm = placemarks! as [CLPlacemark]
            print("\(pm)")
            manager.stopUpdatingLocation()
            if pm.count > 0 {
                
                let pm = placemarks![0]
                
                if (error) == nil {
                    let address = "\(pm.name ?? ""),\(pm.thoroughfare ?? ""), \(pm.locality ?? ""), \(pm.subLocality ?? ""), \(pm.administrativeArea ?? ""), \(pm.postalCode ?? ""), \(pm.country ?? "")"
                    print("\(address)")
                }
                
                if pm.subLocality != nil {
                    self.addressString = self.addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    self.addressString = self.addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    self.addressString = self.addressString + pm.locality! + ", "
                }
                if pm.administrativeArea != nil{
                    self.addressString = self.addressString + pm.administrativeArea! + ", "
                }
                if pm.country != nil {
                    self.country = self.addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    self.addressString = self.addressString + pm.postalCode! + " "
                }
                print(self.addressString)
                
                self.country = pm.country!
                self.city = pm.locality!
                self.state = pm.administrativeArea!
                
                let fullAddress = NSKeyedArchiver.archivedData(withRootObject: self.addressString )
                UserDefaults.standard.setValue(fullAddress, forKey: "key_currentaddress_info")
                UserDefaults.standard.synchronize()
                
                let currentLatData = NSKeyedArchiver.archivedData(withRootObject: self.userLat )
                UserDefaults.standard.setValue(currentLatData, forKey: "key_currentlat_info")
                UserDefaults.standard.synchronize()
                
                let currentLngData = NSKeyedArchiver.archivedData(withRootObject: self.userLng )
                UserDefaults.standard.setValue(currentLngData, forKey: "key_currentlng_info")
                UserDefaults.standard.synchronize()
                
                let countryData = NSKeyedArchiver.archivedData(withRootObject: self.country )
                UserDefaults.standard.setValue(countryData, forKey: "key_currentcountry_info")
                UserDefaults.standard.synchronize()
                
                let cityData = NSKeyedArchiver.archivedData(withRootObject: self.city )
                UserDefaults.standard.setValue(cityData, forKey: "key_currentcity_info")
                UserDefaults.standard.synchronize()

                self.logindict = "\(self.city),\(self.state),\(self.country)"
                
                self.setupNavigationTitle()
                
                if self.brewery == true{
                    if self.nearbySearch == true{
                        self.sort_style = "distance||ASC"
                        self.pageNo = 1
                        self.breweryData = NSMutableArray()
                        self.fetchBreweryList()
                    }
                }
                if self.bar == true{
                    if self.nearbySearch == true{
                        self.sort_style = "distance||ASC"
                        self.pageNo = 1
                        self.barData = NSMutableArray()
                        self.fetchBarList()
                    }
                }
                if self.bottle == true{
                    if self.nearbySearch == true{
                        self.sort_style = "distance||ASC"
                        self.pageNo = 1
                        self.bottleData = NSMutableArray()
                        self.fetchBottleList()
                    }
                }
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    //MARK:- Give Review Api Call
    
    func giveReview(){
        if fromBar == true{
            SVProgressHUD.show(withStatus: "It's working...")
            let todosEndpoint: String = BASE_URL + "bar_review"
            
            let newTodo: [String: Any] = ["restaurent_id": barID,"login_token": login_token,"ambience": self.ambienceValue,"quality": self.qualityValue,"selection": self.selectionValue,"staffservice": self.staffValue,"food": self.foodValue,"value": self.value,"rev_id": self.review_id,"description":self.review_comment,"anonymous":self.anonymousStatus]
            
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
                    self.fetchBarList()
                    SVProgressHUD.dismiss()
            }
        }else{
            SVProgressHUD.show(withStatus: "It's working...")
            let todosEndpoint: String = BASE_URL + "bar_review"
            
            let newTodo: [String: Any] = ["restaurent_id": bottleID,"login_token": login_token,"ambience": self.ambienceValue,"quality": self.qualityValue,"selection": self.selectionValue,"staff": self.staffValue,"service": self.serviceValue,"value": self.value,"rev_id": self.review_id,"description":self.review_comment,"anonymous":self.anonymousStatus,"quickRating":""]
            
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
                    self.fetchBottleList()
                    SVProgressHUD.dismiss()
            }
        }
    }
    
    
    //MARK:- Save Search Button Action
    @IBAction func btnSaveSearchDidTap(_ sender: Any) {
        let SaveSearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SaveSearch") as! SaveSearchViewController
        self.navigationController?.pushViewController(SaveSearchViewController, animated: true)
        
    }
    
    
    
    
    
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
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


