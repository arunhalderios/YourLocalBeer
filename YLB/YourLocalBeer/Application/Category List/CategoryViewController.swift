//
//  CategoryViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 05/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import AZSearchView
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import MapKit
import Alamofire
import SVProgressHUD


class CategoryViewController: BaseViewController,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var vwBreweries: UIView!
    @IBOutlet weak var vwBeer: UIView!
    @IBOutlet weak var vwBars: UIView!
    @IBOutlet weak var vwBottleshop: UIView!
    var logindict = String()

    @IBOutlet weak var viewLocationMap: MKMapView!
    var searchLocation = Bool()
    var searchedText = String()
    var fromBrewery = Bool()
    var fromBeer = Bool()
    var fromBar = Bool()
    var fromBottle = Bool()
    var fromCategoryPage = Bool()
    var locationManager = CLLocationManager()
    var dataarray = NSMutableArray()
    var txtSearch = String()
    var type = String()
    var tempData = [String]()
    var searchView = AZSearchViewController()
    var country = String()
    var city = String()
    var state = String()
    var continent = String()
    var zip = String()
    var continentZip = String()
    var searchlocation = Bool()
    var searchText = String()
    @IBOutlet weak var googleMapContainer: UIView!
    var changeLocation = Bool()
    var address = String()
    
    var geoCoder = CLGeocoder()
    //var placeMark = CLPlacemark()
    var addressString : String = ""
    var locationData = CLLocationCoordinate2D()
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    var lat = Double()
    var lng = Double()
    
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet var btnLocationOutlet: UIButton!
    
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        self.continent = ""
        self.continentZip = ""
        self.country = ""
        self.state = ""
        self.city = ""
        self.zip = ""
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
        
        //fromCategoryPage = false
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnCurrentLocationButton(_ sender: Any) {
        if fromCategoryPage == true || changeLocation == true{
            self.fromCategoryPage = false
            self.changeLocation = false
            self.locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let addressData = UserDefaults.standard.object(forKey: "key_currentaddress_info")
        if addressData == nil{
            self.locationManager.startUpdatingLocation()
        }else{
            if searchLocation == true{
                logindict = searchedText
               // print("UserDict: == \(logindict)")
            }
            if fromCategoryPage == true || changeLocation == true{
                
                self.country = ""
                self.address = ""
                if (UserDefaults.standard.object(forKey: "key_currentcontinent_info") != nil){
                    if  let currentContinentData = UserDefaults.standard.object(forKey: "key_currentcontinent_info"){
                        self.continent = NSKeyedUnarchiver.unarchiveObject(with: currentContinentData as! Data) as! String
                    }
                }else{
                    self.continent = ""
                }
                
                if (UserDefaults.standard.object(forKey: "key_currentdenycountry_info") != nil){
                    if let currentCountryData = UserDefaults.standard.object(forKey: "key_currentdenycountry_info"){
                        self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
                    }
                }else{
                    if let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info"){
                        self.country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
                    }
                }
                
                if (UserDefaults.standard.object(forKey: "key_currentdenystate_info") != nil){
                    if let stateData = UserDefaults.standard.object(forKey: "key_currentdenystate_info"){
                        
                        self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
                    }
                }else{
                    if let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info"){
                        
                        self.state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
                    }
                }
                
                if (UserDefaults.standard.object(forKey: "key_currentdenycity_info") != nil){
                    if let cityData = UserDefaults.standard.object(forKey: "key_currentdenycity_info"){
                        
                        self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
                    }
                }else{
                    if let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info"){
                        self.city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
                    }
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
                
                if !(continent.isEmpty){
                    self.address = logindict
                    print(self.address)
                    
                    //let key : String = "AIzaSyDvFw9p8CbHpr6qvpHc3kG-_RTWSWfMLJk"
                    let key : String = "AIzaSyDLJEq6CGF6j9BbkpJVPKNWHDxsaiACwgM"
                    let postParameters:[String: Any] = [ "address": self.address,"key":key]
                    let url : String = "https://maps.googleapis.com/maps/api/geocode/json"

                    Alamofire.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON {  response in

                        guard let json = response.result.value as? [String: Any] else {
                           print("didn't get todo object as JSON from API")
                           //print("Error: \(response.result.error as! NSString)")
                           SVProgressHUD.dismiss()
                           return
                       }

                    print("JSON: \(json)")
                        
                    let result = json["results"] as? NSArray
                    let firstObject = result![0] as? NSDictionary
                    let geometry = firstObject!["geometry"] as? NSDictionary
                    print(geometry!)
                    let locations = geometry!["location"] as? NSDictionary
                    self.lat = (locations!["lat"] as? double_t)!
                    self.lng = (locations!["lng"] as? double_t)!
                    
                    print(self.lat)
                    print(self.lng)
                    // Use your location
                    
                    let position = CLLocationCoordinate2DMake(self.lat, self.lng)
                    let marker = GMSMarker(position: position)
                    
                    marker.map = self.googleMapsView
                    
                    let camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.lng, zoom: 12)
                    self.googleMapsView.camera = camera
                    }
                }
                else{
                    let currentCountryData = UserDefaults.standard.object(forKey: "key_currentcountry_info")
                    country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
                    
                    let stateData = UserDefaults.standard.object(forKey: "key_currentstate_info")
                    state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
                    
                    let cityData = UserDefaults.standard.object(forKey: "key_currentcity_info")
                    city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
                    
                    let currentLatData = UserDefaults.standard.object(forKey: "key_currentlat_info")
                    self.lat = NSKeyedUnarchiver.unarchiveObject(with: currentLatData as! Data) as! Double
                    
                    let currentLngData = UserDefaults.standard.object(forKey: "key_currentlng_info")
                    self.lng = NSKeyedUnarchiver.unarchiveObject(with: currentLngData as! Data) as! Double
                    
                    let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    
                    logindict = "\(city),\(state),\(country)"
                    
                    let position = CLLocationCoordinate2DMake(self.lat, self.lng)
                    let marker = GMSMarker(position: position)
                    
                    marker.map = self.googleMapsView

                    let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 12)
                    self.googleMapsView.camera = camera
                }
            }
            else{
                self.locationManager.startUpdatingLocation()
            }
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "magnifying-glass"), style:  UIBarButtonItem.Style.plain, target: self, action: #selector(CategoryViewController.barButtonClickAction))
        
        addSlideMenuButton("CategoryViewController")
        
        self.setupNavigationTitle()
        
        
        
        vwBreweries.layer.cornerRadius = 10
        vwBreweries.layer.borderWidth = 1
        vwBreweries.layer.borderColor = UIColor.darkGray.cgColor
        
        vwBeer.layer.cornerRadius = 10
        vwBeer.layer.borderWidth = 1
        vwBeer.layer.borderColor = UIColor.darkGray.cgColor
        
        vwBars.layer.cornerRadius = 10
        vwBars.layer.borderWidth = 1
        vwBars.layer.borderColor = UIColor.darkGray.cgColor
        
        vwBottleshop.layer.cornerRadius = 10
        vwBottleshop.layer.borderWidth = 1
        vwBottleshop.layer.borderColor = UIColor.darkGray.cgColor
        
        vwBreweries.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        vwBeer.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        vwBars.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        vwBottleshop.dropShadow(color: .lightGray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    /**
     action for search location by address
     
     - parameter sender: button search location
     */
    
    //MARK:- Search Button Action
    @objc func barButtonClickAction() {
        print("Button click...")
        let SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        self.navigationController?.pushViewController(SearchViewController, animated: true)
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
    
    
    //MARK:- mapView delegate
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        //manager.delegate = nil
        
        self.locationData = locationManager.location!.coordinate
        //     print(location)
        self.lat = self.locationData.latitude
        self.lng = self.locationData.longitude
        
        SVProgressHUD.show(withStatus: "Loading")
        
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
                
                self.country = pm.country ?? ""
                self.city = pm.locality ?? ""
                self.state = pm.administrativeArea ?? ""
                
                let fullAddress = NSKeyedArchiver.archivedData(withRootObject: self.addressString )
                UserDefaults.standard.setValue(fullAddress, forKey: "key_currentaddress_info")
                UserDefaults.standard.synchronize()
                
                let currentLatData = NSKeyedArchiver.archivedData(withRootObject: self.lat )
                UserDefaults.standard.setValue(currentLatData, forKey: "key_currentlat_info")
                UserDefaults.standard.synchronize()
                
                let currentLngData = NSKeyedArchiver.archivedData(withRootObject: self.lng )
                UserDefaults.standard.setValue(currentLngData, forKey: "key_currentlng_info")
                UserDefaults.standard.synchronize()
                
                let countryData = NSKeyedArchiver.archivedData(withRootObject: self.country )
                UserDefaults.standard.setValue(countryData, forKey: "key_currentcountry_info")
                UserDefaults.standard.synchronize()
                
                let cityData = NSKeyedArchiver.archivedData(withRootObject: self.city )
                UserDefaults.standard.setValue(cityData, forKey: "key_currentcity_info")
                UserDefaults.standard.synchronize()
                
                
                let center = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

                self.logindict = "\(self.city),\(self.state),\(self.country)"
                
                self.title = self.logindict
                
                let position = CLLocationCoordinate2DMake(self.lat, self.lng)
                let marker = GMSMarker(position: position)

                marker.map = self.googleMapsView

                let camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.lng, zoom: 12)
                self.googleMapsView.camera = camera
                
                self.setupNavigationTitle()
                //self.cameraMoveToLocation(toLocation: self.locationData)
            }
        })
        
        SVProgressHUD.dismiss()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error: \(error)")
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            googleMapsView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 14)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func btnBeerListDidTap(_ sender: Any) {
        let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        HomeViewController.fromBeer = true
        HomeViewController.searchlocation = searchLocation
        HomeViewController.searchText = searchedText
        HomeViewController.fromCategoryPage = fromCategoryPage
        HomeViewController.changeLocation = changeLocation
        self.navigationController?.pushViewController(HomeViewController, animated: true)
    }
    
    @IBAction func btnBreweryListDidTap(_ sender: Any) {
        let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        HomeViewController.fromBrewery = true
        HomeViewController.searchlocation = searchLocation
        HomeViewController.searchText = searchedText
        HomeViewController.changeLocation = changeLocation
        HomeViewController.fromCategoryPage = fromCategoryPage
        self.navigationController?.pushViewController(HomeViewController, animated: true)
    }
    
    @IBAction func btnBarListDidTap(_ sender: Any) {
        let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        HomeViewController.fromBar = true
        HomeViewController.searchlocation = searchLocation
        HomeViewController.searchText = searchedText
        HomeViewController.changeLocation = changeLocation
        self.navigationController?.pushViewController(HomeViewController, animated: true)
    }
    
    @IBAction func btnBottleshopDidTap(_ sender: Any) {
        let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        HomeViewController.fromBottle = true
        HomeViewController.searchlocation = searchLocation
        HomeViewController.searchText = searchedText
        HomeViewController.changeLocation = changeLocation
        self.navigationController?.pushViewController(HomeViewController, animated: true)
    }
    
    
    @IBAction func btnBrowseLocation(_ sender: Any) {
        fromCategoryPage = true
        changeLocation = true
        let ChangeLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangeLocation") as! ChangeLocationViewController
        ChangeLocationViewController.fromCategoryPage = fromCategoryPage
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

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

