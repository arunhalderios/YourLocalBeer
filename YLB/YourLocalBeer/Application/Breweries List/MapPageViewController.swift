//
//  MapPageViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 23/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import MapKit
import GooglePlaces
import Alamofire
import SVProgressHUD


class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var address: String!
    var image: String!
    
    init(position: CLLocationCoordinate2D, name: String, address: String, image: String) {
        self.position = position
        self.name = name
        self.address = address
        self.image = image
    }
}

let kClusterItemCount = 1000
let kCameraLatitude = -33.8
let kCameraLongitude = 151.2


class MapPageViewController: UIViewController,GMSMapViewDelegate,GMUClusterManagerDelegate,CLLocationManagerDelegate {

    //MARK:- Variable Declaration

    @IBOutlet weak var viewMap: GMSMapView!
    var fromBottleShop = Bool()
    var fromRestaurant = Bool()
    var AllLeakes = NSArray()
    var fromMapPage = Bool()
    
    @IBOutlet weak var btnBreweryOutlet: UIButton!
    @IBOutlet weak var btnBarOutlet: UIButton!
    @IBOutlet weak var btnBottleOutlet: UIButton!
    
    @IBOutlet weak var vwBrewery: UIView!
    @IBOutlet weak var vwBar: UIView!
    @IBOutlet weak var vwBottle: UIView!
    
    var brewery = Bool()
    var beer = Bool()
    var bar = Bool()
    var bottle = Bool()
    
    var fromBeer = Bool()
    var fromBar = Bool()
    var fromBottle = Bool()
    var fromBrewery = Bool()
    var locationManager = CLLocationManager()
    
    var breweryData = NSMutableArray()
    var beerData = NSMutableArray()
    var barData = NSMutableArray()
    var bottleData = NSMutableArray()
    
    var lat = Double()
    var lng = Double()
    var PageName = String()
    
    var totalPageCount = Int()
    var pageNo = Int()
    var country = String()
    var city = String()
    var state = String()
    var continent = String()
    var continentZip = String()
    var zip = String()
    var fromCategoryPage = Bool()
    var searchlocation = Bool()
    var searchText = String()
    var isLoadingTableView = Bool()
    var logindict = String()
    var logdict = NSDictionary()
    var login_token = String()
    var Latitude = Double()
    var Longitude = Double()
    var london: GMSMarker?
    var londonView: UIImageView?
    var marker = GMSMarker()
    @IBOutlet var lblShowingTotalData: UILabel!
    
    private var clusterManager: GMUClusterManager!
    struct Location {
        let title: String
        let latitude: Double
        let longitude: Double
    }
    
    var changeLocation = Bool()
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var calloutView: UIView!
    @IBOutlet weak var backView: UIView!
    var selectData = NSDictionary()
    @IBOutlet weak var vwCallout: UIView!
    @IBOutlet weak var vwCategory: UIView!
    @IBOutlet weak var imgCategory: UIImageView!
    var Lat = Double()
    var Lng = Double()
    var markers = [GMSMarker]()
    var address = String()
    @IBOutlet var btnLoadMore: UIButton!
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        //btnLoadMore.setImage(UIImage.gif(asset: "load-more"), for: .normal)
        
        // Do any additional setup after loading the view.
        pageNo = 1
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logdict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        
        login_token = "\(logdict .value(forKey: "login_token")!)"
        
        let addressData = UserDefaults.standard.object(forKey: "key_currentaddress_info")
        if addressData == nil{
            let currentContinentData = UserDefaults.standard.object(forKey: "key_currentcontinent_info")
            continent = NSKeyedUnarchiver.unarchiveObject(with: currentContinentData as! Data) as! String
            
            if (UserDefaults.standard.object(forKey: "key_continentzip_info") != nil){
                let continentZipData = UserDefaults.standard.object(forKey: "key_continentzip_info")
                continentZip = NSKeyedUnarchiver.unarchiveObject(with: continentZipData as! Data) as! String
            }else{
                continentZip = ""
            }
            
            let currentCountryData = UserDefaults.standard.object(forKey: "key_currentdenycountry_info")
            country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
            
            let stateData = UserDefaults.standard.object(forKey: "key_currentdenystate_info")
            state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
            
            let cityData = UserDefaults.standard.object(forKey: "key_currentdenycity_info")
            city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
            
            if (UserDefaults.standard.object(forKey: "key_currentdenyzip_info") != nil){
                let zipData = UserDefaults.standard.object(forKey: "key_currentdenyzip_info")
                zip = NSKeyedUnarchiver.unarchiveObject(with: zipData as! Data) as! String
            }else{
                zip = ""
            }
            
            
            logindict = "\(continent),\(country),\(state),\(city),\(zip)"                       //ALASKA, 99515-1901"
        }else{
            if searchlocation == true{
                logindict = searchText
            }else{
                if fromCategoryPage == true || changeLocation == true{
                    self.country = ""
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
                        }
                        else if continent != "" && country != ""{
                            logindict = "\(city),\(state),\(country),\(continent)"
                        }
                        else{
                            logindict = "\(city),\(state),\(country),\(continent)"
                        }
                        print(logindict)
                        
                }else{
                    if let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info"){
                        country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String

                    }
                    
                    if let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info"){
                        
                        state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String

                    }
                    
                    if  let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info"){
                        
                        city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String

                    }
                    
                    logindict = "\(country),\(state),\(city)"

                }
            }
        }
        
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        
        calloutView.isHidden = true
        backView.isHidden = false
        
        vwCallout.addBorder(toSide: .Left, withColor: UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0).cgColor, andThickness: 4.0)
        vwCallout.layer.cornerRadius = 5
        vwCallout.layer.masksToBounds = true
        
        
        vwCategory.layer.borderWidth = 2
        vwCategory.layer.borderColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0).cgColor
        vwCategory.layer.cornerRadius = vwCategory.frame.size.width/2
        vwCategory.layer.masksToBounds = true
        
        
        if fromBrewery == true || PageName == "Brewery"{
            btnBreweryOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            btnBarOutlet.tintColor = UIColor.black
            btnBottleOutlet.tintColor = UIColor.black
            vwBrewery.isHidden = false
            vwBar.isHidden = true
            vwBottle.isHidden = true
            brewery = true
            bar = false
            bottle = false
        }else if fromBar == true || PageName == "Bar"{
            btnBarOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            btnBreweryOutlet.tintColor = UIColor.black
            btnBottleOutlet.tintColor = UIColor.black
            vwBrewery.isHidden = true
            vwBar.isHidden = false
            vwBottle.isHidden = true
            bar = true
            brewery = false
            bottle = false
        }else{
            btnBottleOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
            btnBreweryOutlet.tintColor = UIColor.black
            btnBarOutlet.tintColor = UIColor.black
            vwBrewery.isHidden = true
            vwBar.isHidden = true
            vwBottle.isHidden = false
            bottle = true
            bar = false
            brewery = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        backView.addGestureRecognizer(tapGesture)
        
        viewMap.delegate=self
        initializeTheLocationManager()
        
        if fromMapPage == true{
            fromMapPage = false
            if PageName == "Bottleshop" {
                pageNo = 1
                self.fetchBottleList()
            }
            if PageName == "Brewery"{
                pageNo = 1
                self.fetchBreweryList()
            }
            if PageName == "Bar"{
                pageNo = 1
                self.fetchBarList()
            }
            
        }else{
            if fromBottle == true{
                PageName = "Bottleshop"
                self.fetchBottleList()
            }
            if fromBrewery == true{
                PageName = "Brewery"
                self.fetchBreweryList()
            }
            if fromBar == true{
                PageName = "Bar"
                self.fetchBarList()
            }
        }
    }
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        calloutView.isHidden = true
        backView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logdict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        
        login_token = "\(logdict .value(forKey: "login_token")!)"
        
        let addressData = UserDefaults.standard.object(forKey: "key_currentaddress_info")
        if addressData == nil{
            let currentContinentData = UserDefaults.standard.object(forKey: "key_currentcontinent_info")
            continent = NSKeyedUnarchiver.unarchiveObject(with: currentContinentData as! Data) as! String
            
            if (UserDefaults.standard.object(forKey: "key_continentzip_info") != nil){
                let continentZipData = UserDefaults.standard.object(forKey: "key_continentzip_info")
                continentZip = NSKeyedUnarchiver.unarchiveObject(with: continentZipData as! Data) as! String
            }else{
                continentZip = ""
            }
            
            let currentCountryData = UserDefaults.standard.object(forKey: "key_currentdenycountry_info")
            country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
            
            let stateData = UserDefaults.standard.object(forKey: "key_currentdenystate_info")
            state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
            
            let cityData = UserDefaults.standard.object(forKey: "key_currentdenycity_info")
            city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
            
            if (UserDefaults.standard.object(forKey: "key_currentdenyzip_info") != nil){
                let zipData = UserDefaults.standard.object(forKey: "key_currentdenyzip_info")
                zip = NSKeyedUnarchiver.unarchiveObject(with: zipData as! Data) as! String
            }else{
                zip = ""
            }
            
            
            logindict = "\(continent),\(country),\(state),\(city),\(zip)"                       //ALASKA, 99515-1901"
        }else{
            if searchlocation == true{
                logindict = searchText
            }else{
                if fromCategoryPage == true || changeLocation == true{
                    self.country = ""
                    self.address = ""
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
                    }
                    else if continent != "" && country != ""{
                        logindict = "\(city),\(state),\(country),\(continent)"
                    }
                    else{
                        logindict = "\(city),\(state),\(country),\(continent)"
                    }
                    print(logindict)
                    
//                    if !(continent.isEmpty){
//                       self.address = logindict
//                       print(self.address)
//                       let geoCoder = CLGeocoder()
//                       geoCoder.geocodeAddressString(self.address) { (placemarks, error) in
//                           guard
//                               let placemarks = placemarks,
//                               let location = placemarks.first?.location
//
//                               else {
//                                   // handle no location found
//                                   return
//                           }
//                           print(location)
//                           print(placemarks)
//
//                           self.lat = location.coordinate.latitude
//                           self.lng = location.coordinate.longitude
//
//                           print(self.lat)
//                           print(self.lng)
//                           // Use your location
//
//                           let position = CLLocationCoordinate2DMake(self.lat, self.lng)
//                           let marker = GMSMarker(position: position)
//
//                           marker.map = self.viewMap
//
//                           let camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.lng, zoom: 14)
//                           self.viewMap.camera = camera
//                       }
//                   }
            }else{
                    let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info")
                    country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
                    
                    let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info")
                    state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
                    
                    let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info")
                    city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
                    
                    logindict = "\(country),\(state),\(city)"
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            // Your code...
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }else{
            print(false)
        }
    }
    
    
    // MARK: - GMUClusterManagerDelegate
    
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: viewMap.camera.zoom + 2)
        let update = GMSCameraUpdate.setCamera(newCamera)
        viewMap.moveCamera(update)
        
        return false
    }
    
    //MARK:- Load more button Action
    
    @IBAction func btnLoadMoreDidTap(_ sender: Any) {
        
        if PageName == "Bottleshop" {
            self.markers = [GMSMarker]()
            pageNo = pageNo + 1
            self.fetchBottleList()
        }
        if PageName == "Brewery"{
            //if isLoadingTableView == true{
                self.markers = [GMSMarker]()
                pageNo = pageNo + 1
                self.fetchBreweryList()
            //}
        }
        if PageName == "Bar"{
            self.markers = [GMSMarker]()
            pageNo = pageNo + 1
            self.fetchBarList()
        }
    }
    
    
    // MARK: - GMUMapViewDelegate
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if marker.userData is POIItem {
            marker.icon = UIImage(named: "circle")
            marker.title = "2"
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let poiItem = marker.userData as? POIItem {
            NSLog("Did tap marker for cluster item \(poiItem.name)")
        } else {
            NSLog("Did tap a normal marker")
        }
        
        self.calloutView.isHidden = false
        self.backView.isHidden = false
    

        let index = markers.firstIndex(of: marker)
        
        if fromBrewery == true || PageName == "Brewery"{
            
            print(self.breweryData.count)
            print(markers.firstIndex(of: marker) as Any)
            
            if index != nil{
                self.selectData = self.breweryData[Int(index!)] as! NSDictionary
                
                self.Lat = (selectData["lat"] as! NSString).doubleValue
                self.Lng = (selectData["long"] as! NSString).doubleValue
                
                self.lblTitle.text = selectData["name"] as? String
                if let value = (selectData["state"] as? String)
                {
                    //NOT NULL
                    self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\(value),\((selectData["city"] as? String)!)"
                }
                else
                {
                    //NULL
                    self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\((selectData["city"] as? String)!)"
                }
                if let value = (selectData["city"] as? String)
                {
                    //NOT NULL
                    self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\((selectData["state"] as? String)!),\(value)"
                }
                else
                {
                    //NULL
                    self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\((selectData["state"] as? String)!)"
                }
                
                imgCategory.image = UIImage(named: "Brewrie.png")
                
                self.lblAddress.numberOfLines = 0
                self.lblAddress.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.lblAddress.layer.masksToBounds = true
            }
            
 
        }else if bar == true || PageName == "Bar"{
            
            if index != nil{
                self.selectData = self.barData[Int(index!)] as! NSDictionary
                self.Lat = (selectData["lat"] as! NSString).doubleValue
                self.Lng = (selectData["long"] as! NSString).doubleValue
                self.lblTitle.text = selectData["name"] as? String
                if let value = (selectData["state"] as? String)
                {
                    //NOT NULL
                    self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\(value),\((selectData["city"] as? String)!)"
                }
                else
                {
                    //NULL
                    self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\((selectData["city"] as? String)!)"
                }
                if let value = (selectData["city"] as? String)
                {
                    //NOT NULL
                    self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\((selectData["state"] as? String)!),\(value)"
                }
                else
                {
                    //NULL
                    self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\((selectData["state"] as? String)!)"
                }
                imgCategory.image = UIImage(named: "restaurent-bar.png")
                
                self.lblAddress.numberOfLines = 0
                self.lblAddress.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.lblAddress.layer.masksToBounds = true
            }
            
 
        }else{
            if index != nil{
                self.selectData = self.bottleData[Int(index!)] as! NSDictionary
                 self.Lat = (selectData["lat"] as! NSString).doubleValue
                 self.Lng = (selectData["long"] as! NSString).doubleValue
                 self.lblTitle.text = selectData["name"] as? String
                if let value = (selectData["state"] as? String)
                 {
                     //NOT NULL
                     self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\(value),\((selectData["city"] as? String)!)"
                 }
                 else
                 {
                     //NULL
                     self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\((selectData["city"] as? String)!)"
                 }
                 if let value = (selectData["city"] as? String)
                 {
                     //NOT NULL
                     self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\((selectData["state"] as? String)!),\(value)"
                 }
                 else
                 {
                     //NULL
                     self.lblAddress.text = "\((selectData["address"] as? String)!),\((selectData["country"] as? String)!),\((selectData["state"] as? String)!)"
                 }
                 imgCategory.image = UIImage(named: "bottle-shop.png")
                 
                 self.lblAddress.numberOfLines = 0
                 self.lblAddress.lineBreakMode = NSLineBreakMode.byWordWrapping
                 self.lblAddress.layer.masksToBounds = true
            }
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        UIView.animate(withDuration: 5.0, animations: { () -> Void in
            self.londonView?.tintColor = .blue
        }, completion: {(finished) in
            // Stop tracking view changes to allow CPU to idle.
            self.london?.tracksViewChanges = true
        })
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            viewMap.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 10)
        }
    }
    
    @IBAction func btnDetailDidTap(_ sender: Any) {
        self.calloutView.isHidden = true
        self.backView.isHidden = true
        
        if fromBrewery == true{
            let BreweryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreweryDetail") as! BreweryDetailViewController
            BreweryDetailViewController.breweryID = self.selectData["_id"] as! String;
            self.navigationController?.pushViewController(BreweryDetailViewController, animated: true)
        }else if bar{
            let BarDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetailViewController
            BarDetailViewController.barID = self.selectData["_id"] as! String;
            self.navigationController?.pushViewController(BarDetailViewController, animated: true)
        }else{
            let BottleshopDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BottleshopDetail") as! BottleshopDetailViewController
            BottleshopDetailViewController.bottleID = self.selectData["_id"] as! String;
            self.navigationController?.pushViewController(BottleshopDetailViewController, animated: true)
        }
       
    }
    
    @IBAction func btnNavigateDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.mapActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- OPEN MAP METHODS
    func mapActionSheet() {
        let myActionSheet = UIAlertController()
        let googleAction = UIAlertAction(title: "Google Maps", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGoogleMap()
        })
        let appleAction = UIAlertAction(title: "Apple Maps", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openAppleMap()
        })
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {
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
    
    func openGoogleMap() {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            let url = URL(string:"comgooglemaps://?saddr=\(self.lat),\(self.lng)&daddr=\(self.Latitude),\(self.Longitude)&directionsmode=driving")
            UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
                let url = URL(string:"http://maps.apple.com/?daddr=\(self.Latitude),\(self.Longitude)&saddr=\(self.lat),\(self.lng)")
                UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                NSLog("Can't use Apple Maps");
            }
            NSLog("Can't use Google Maps");
        }
    }
    
    
    func openAppleMap() {
        if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
            let url = URL(string:"http://maps.apple.com/?daddr=\(self.Latitude),\(self.Longitude)&saddr=\(self.lat),\(self.lng)")
            UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            NSLog("Can't use Apple Maps");
        }
    }
    
    
    // MARK: - Private
    
    /// Randomly generates cluster items within some extent of the camera and adds them to the
    /// cluster manager.
    private func generateClusterItems() {
        let extent = 0.2
        if bottle == true || PageName == "Bottleshop"{
            for i in 0 ..< self.bottleData.count {
                let selectValue = self.bottleData[i] as! NSDictionary
                let name = selectValue["name"] as? String
                
                if let lat = selectValue["lat"] as? NSNumber {
                    self.Latitude = double_t(lat.stringValue)!
                }
                else if let lat = selectValue["lat"] as? String {
                    self.Latitude = double_t(lat)!
                }
                
                if let lng = selectValue["long"] as? NSNumber {
                    self.Longitude = double_t(lng.stringValue)!
                }
                else if let lng = selectValue["long"] as? String {
                    self.Longitude = double_t(lng)!
                }
                
                if let value = (selectValue["state"] as? String)
                {
                    //NOT NULL
                     let item = POIItem(position: CLLocationCoordinate2DMake(Double(Latitude), Double(Longitude)), name: "\(i)", address: "\((selectValue["address"] as? String)!),\((selectValue["country"] as? String)!),\(value),\((selectValue["city"] as? String)!)",image: "bottle-shop.png")
                    clusterManager.add(item)
                }
                else
                {
                    //NULL
                     let item = POIItem(position: CLLocationCoordinate2DMake(Double(Latitude), Double(Longitude)), name: "\(i)", address: "\((selectValue["address"] as? String)!),\((selectValue["country"] as? String)!),\((selectValue["city"] as? String)!)",image: "bottle-shop.png")
                    clusterManager.add(item)
                }
                
                let position = CLLocationCoordinate2DMake(Double(Latitude), Double(Longitude))
                self.cameraMoveToLocation(toLocation: position)
            }
        }
        else if bar == true || PageName == "Bar"{
            for i in 0 ..< self.barData.count {
                let selectValue = self.barData[i] as! NSDictionary
                let name = selectValue["name"] as? String
                
                
                if let lat = selectValue["lat"] as? NSNumber {
                    self.Latitude = double_t(lat.stringValue)!
                }
                else if let lat = selectValue["lat"] as? String {
                    self.Latitude = double_t(lat)!
                }
                
                if let lng = selectValue["long"] as? NSNumber {
                    self.Longitude = double_t(lng.stringValue)!
                }
                else if let lng = selectValue["long"] as? String {
                    self.Longitude = double_t(lng)!
                }
                if let value = (selectValue["state"] as? String)
                {
                    //NOT NULL
                    let item = POIItem(position: CLLocationCoordinate2DMake(Double(Latitude), Double(Longitude)), name: "\(i)", address: "\((selectValue["address"] as? String)!),\((selectValue["country"] as? String)!),\(value),\((selectValue["city"] as? String)!)",image: "restaurent-bar.png")
                    clusterManager.add(item)
                }
                else
                {
                    //NULL
                    let item = POIItem(position: CLLocationCoordinate2DMake(Double(Latitude), Double(Longitude)), name: "\(i)", address: "\((selectValue["address"] as? String)!),\((selectValue["country"] as? String)!),\((selectValue["city"] as? String)!)",image: "restaurent-bar.png")
                    clusterManager.add(item)
                }
                
                let position = CLLocationCoordinate2DMake(Double(Latitude), Double(Longitude))
                self.cameraMoveToLocation(toLocation: position)
            }
        }
        else if brewery == true || PageName == "Brewery"{
            for i in 0 ..< self.breweryData.count {
                let selectValue = self.breweryData[i] as! NSDictionary
                //let name = selectValue["name"] as? String
                
                
                if let lat = selectValue["lat"] as? NSNumber {
                    self.Latitude = double_t(lat.stringValue)!
                }
                else if let lat = selectValue["lat"] as? String {
                    self.Latitude = double_t(lat)!
                }
                
                if let lng = selectValue["long"] as? NSNumber {
                    self.Longitude = double_t(lng.stringValue)!
                }
                else if let lng = selectValue["long"] as? String {
                    self.Longitude = double_t(lng)!
                }
                if let value = (selectValue["state"] as? String)
                {
                    //NOT NULL
                    let item = POIItem(position: CLLocationCoordinate2DMake(Double(Latitude), Double(Longitude)), name: "\(i)", address: "\((selectValue["address"] as? String)!),\((selectValue["country"] as? String)!),\(value),\((selectValue["city"] as? String)!)",image: "Brewrie.png")
                    clusterManager.add(item)
                }
                else
                {
                    //NULL
                    let item = POIItem(position: CLLocationCoordinate2DMake(Double(Latitude), Double(Longitude)), name: "\(i)", address: "\((selectValue["address"] as? String)!),\((selectValue["country"] as? String)!),\((selectValue["city"] as? String)!)",image: "Brewrie.png")
                    clusterManager.add(item)
                }
                let position = CLLocationCoordinate2DMake(double_t(Latitude), double_t(Longitude))
                self.cameraMoveToLocation(toLocation: position)
            }
        }
    }
    
    //MARK:- mapView delegate
    
    func initializeTheLocationManager()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
    }
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        let location = locationManager.location?.coordinate
        self.lat = location!.latitude
        self.lng = location!.longitude
        
        self.cameraMoveToLocation(toLocation: location)
    }
    
    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Fetch Brewery List
    
    func fetchBreweryList(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "breweries"
        
        let newTodo: [String: Any] = ["continent": continent,"country": country,"region": state,"city": city,"continentZip": continentZip,"zip_code": zip,"page_number": pageNo]
                
        print(newTodo)
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                if((json["brewries"] as! Array<Any>).count>0){
                    self.breweryData.addObjects(from: ((json["brewries"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                    
                    self.lblShowingTotalData.text = "Showing 1 - \(self.breweryData.count) of \((json["total"] as! NSNumber).intValue)"
                    
                    self.isLoadingTableView = true
                    self.backView.isHidden = true
                    
                    for i in 0 ..< self.breweryData.count {
                        let selectValue = self.breweryData[i] as! NSDictionary
                        
                        if let lat = selectValue["lat"] as? NSNumber {
                            self.Latitude = double_t(lat.stringValue)!
                        }
                        else if let lat = selectValue["lat"] as? String {
                            self.Latitude = double_t(lat)!
                        }
                        
                        if let lng = selectValue["long"] as? NSNumber {
                            self.Longitude = double_t(lng.stringValue)!
                        }
                        else if let lng = selectValue["long"] as? String {
                            self.Longitude = double_t(lng)!
                        }
                        let marker = CustomMarker(labelText: "\((selectValue["position"] as? Int)!)")
                        marker.position = CLLocationCoordinate2D(latitude: double_t(self.Latitude), longitude: double_t(self.Longitude))
                        marker.map = self.viewMap
                        self.markers.append(marker)
                        
                        self.cameraMoveToLocation(toLocation: marker.position)
                        SVProgressHUD.dismiss()
                    }
                }else{
                    self.backView.isHidden = true
                    self.isLoadingTableView = false
                    self.lblShowingTotalData.text = "Showing 1 - \((json["total"] as! NSNumber).intValue) of \((json["total"] as! NSNumber).intValue)"
                    SVProgressHUD.dismiss()
                }
        }
    }
    
    //MARK:- Fetch Bar List
    
    func fetchBarList(){
        //SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "bars"
        
        let newTodo: [String: Any] = ["continent": continent,"country": country,"region": state,"city": city,"continentZip": continentZip,"zip_code": zip,"page_number": pageNo,"type": "bars"]
                
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                if((json["bars"] as! Array<Any>).count>0){
                    self.barData.addObjects(from: ((json["bars"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                    
                    self.lblShowingTotalData.text = "Showing 1 - \(self.barData.count) of \((json["total"] as! NSNumber).intValue)"
                    
                    self.isLoadingTableView = true
                    self.backView.isHidden = true
                    
                    for i in 0 ..< self.barData.count {
                        let selectValue = self.barData[i] as! NSDictionary
                        
                        if let lat = selectValue["lat"] as? NSNumber {
                            self.Latitude = double_t(lat.stringValue)!
                        }
                        else if let lat = selectValue["lat"] as? String {
                            self.Latitude = double_t(lat)!
                        }
                        
                        if let lng = selectValue["long"] as? NSNumber {
                            self.Longitude = double_t(lng.stringValue)!
                        }
                        else if let lng = selectValue["long"] as? String {
                            self.Longitude = double_t(lng)!
                        }
                        let marker = CustomMarker(labelText: "\((selectValue["position"] as? Int)!)")
                        marker.position = CLLocationCoordinate2D(latitude: double_t(self.Latitude), longitude: double_t(self.Longitude))
                        marker.map = self.viewMap
                        self.markers.append(marker)
                        self.cameraMoveToLocation(toLocation: marker.position)
                        SVProgressHUD.dismiss()
                    }
                }else{
                    self.backView.isHidden = true
                    self.isLoadingTableView = false
                    self.lblShowingTotalData.text = "Showing 1 - \((json["total"] as! NSNumber).intValue) of \((json["total"] as! NSNumber).intValue)"
                    SVProgressHUD.dismiss()
                }
        }
    }
    
    //MARK:- Fetch Bottle List
    
    func fetchBottleList(){
        //SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "bars"
        
        let newTodo: [String: Any] = ["continent": continent,"country": country,"region": state,"city": city,"continentZip": continentZip,"zip_code": zip,"page_number": pageNo,"type": "bottleshop"]
                
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                if((json["bars"] as! Array<Any>).count>0){
                    self.bottleData.addObjects(from: ((json["bars"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                    
                    self.lblShowingTotalData.text = "Showing 1 - \(self.bottleData.count) of \((json["total"] as! NSNumber).intValue)"
                    
                    self.isLoadingTableView = true
                    self.backView.isHidden = true
                    
                    for i in 0 ..< self.bottleData.count {
                        let selectValue = self.bottleData[i] as! NSDictionary

                        if let lat = selectValue["lat"] as? NSNumber {
                            self.Latitude = double_t(lat.stringValue)!
                        }
                        else if let lat = selectValue["lat"] as? String {
                            self.Latitude = double_t(lat)!
                        }
                        
                        if let lng = selectValue["long"] as? NSNumber {
                            self.Longitude = double_t(lng.stringValue)!
                        }
                        else if let lng = selectValue["long"] as? String {
                            self.Longitude = double_t(lng)!
                        }
                        let marker = CustomMarker(labelText: "\((selectValue["position"] as? Int)!)")
                        marker.position = CLLocationCoordinate2D(latitude: double_t(self.Latitude), longitude: double_t(self.Longitude))
                        marker.map = self.viewMap
                        self.markers.append(marker)
                        self.cameraMoveToLocation(toLocation: marker.position)
                        SVProgressHUD.dismiss()
                    }
                }else{
                    self.backView.isHidden = true
                    self.isLoadingTableView = false
                    self.lblShowingTotalData.text = "Showing 1 - \((json["total"] as! NSNumber).intValue) of \((json["total"] as! NSNumber).intValue)"
                    SVProgressHUD.dismiss()
                }
        }
    }
    
    //MARK:- Button actions
    @IBAction func btnBreweryDidTap(_ sender: Any) {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        self.breweryData = NSMutableArray()
        btnBreweryOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBarOutlet.tintColor = UIColor.black
        btnBottleOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = false
        vwBar.isHidden = true
        vwBottle.isHidden = true
        fromBrewery = true
        fromBar = false
        fromBottle = false
        brewery = true
        beer = false
        bar = false
        bottle = false
        self.viewMap.clear()
        self.selectData = NSDictionary()
        self.breweryData = NSMutableArray()
        self.markers = [GMSMarker]()
        pageNo = 1
        self.PageName = "Brewery"
        self.fetchBreweryList()
    }
    
    @IBAction func btnBarDidTap(_ sender: Any) {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        self.barData = NSMutableArray()
        btnBarOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBreweryOutlet.tintColor = UIColor.black
        btnBottleOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = true
        vwBar.isHidden = false
        vwBottle.isHidden = true
        fromBrewery = false
        fromBar = true
        fromBottle = false
        bar = true
        brewery = false
        beer = false
        bottle = false
        self.viewMap.clear()
        self.selectData = NSDictionary()
        self.barData = NSMutableArray()
        self.markers = [GMSMarker]()
        pageNo = 1
        self.PageName = "Bar"
        self.fetchBarList()
    }
    
    @IBAction func btnBottleDidTap(_ sender: Any) {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        self.bottleData = NSMutableArray()
        btnBottleOutlet.tintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        btnBreweryOutlet.tintColor = UIColor.black
        btnBarOutlet.tintColor = UIColor.black
        vwBrewery.isHidden = true
        vwBar.isHidden = true
        vwBottle.isHidden = false
        fromBrewery = false
        fromBar = false
        fromBottle = true
        bottle = true
        bar = false
        brewery = false
        beer = false
        self.viewMap.clear()
        self.selectData = NSDictionary()
        self.bottleData = NSMutableArray()
        self.markers = [GMSMarker]()
        pageNo = 1
        self.PageName = "Bottleshop"
        self.fetchBottleList()
    }
    
    @IBAction func btnChangeLocationDidTap(_ sender: Any) {
        changeLocation = true
        let ChangeLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLocation") as! ChangeLocationViewController
        ChangeLocationViewController.fromMapPage = true
        ChangeLocationViewController.fromPage = self.PageName
        ChangeLocationViewController.changeLocation = changeLocation
        self.navigationController?.pushViewController(ChangeLocationViewController, animated: true)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

class CustomMarker: GMSMarker {
    
    var label: UILabel!
    
    init(labelText: String) {
        super.init()
        
        let iconView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        //iconView.backgroundColor = .white
        iconView.image = UIImage(named: "googleMarker")
        
        
        label = UILabel(frame: CGRect(origin: .init(x: 0, y: -5), size: CGSize(width: iconView.bounds.width, height: 40)))
        
        label.text = labelText
        label.font = label.font.withSize(14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        iconView.addSubview(label)
        
        self.iconView = iconView
    }
}
