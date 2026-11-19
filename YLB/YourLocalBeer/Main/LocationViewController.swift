//
//  LocationViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 17/05/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController,CLLocationManagerDelegate {

    //MARK:- Variable declaration
    @IBOutlet weak var txtCurrentLocation: UITextField!
    @IBOutlet weak var btnLocationOutlet: UIButton!
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    //var placeMark = CLPlacemark()
    var isLocationEnabled = Bool()
    var fromLocationDeactive = Bool()
    
    var addressString : String = ""
    var Latitude = Double()
    var Longitude = Double()
    var country = String()
    var city = String()
    var state = String()
    
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        isLocationEnabled = false
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        isLocationEnabled = true
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- ClLocation Method
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        
        //manager.delegate = nil
        
        let location = locationManager.location?.coordinate
        
        
        geoCoder.reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                return
            }
            let pm = placemarks! as [CLPlacemark]
            manager.stopUpdatingLocation()
            if pm.count > 0 {
                
                self.locationManager.stopUpdatingLocation()
                self.locationManager.delegate = nil
                
                let pm = placemarks![0]
                
                if (error) == nil {
                    let address = "\(pm.name ?? ""),\(pm.thoroughfare ?? ""), \(pm.locality ?? ""), \(pm.subLocality ?? ""), \(pm.administrativeArea ?? ""), \(pm.postalCode ?? ""), \(pm.country ?? "")"
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
                    self.addressString = self.addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    self.addressString = self.addressString + pm.postalCode! + " "
                }
                print("Address String:------ \(self.addressString)")
                
                if self.addressString == ""{
                    self.locationManager.delegate = self
                    self.locationManager.requestAlwaysAuthorization()
                    self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
                    self.locationManager.startUpdatingLocation()
                }else{
//                    let alertController = UIAlertController(title: "Success", message: self.addressString, preferredStyle: UIAlertController.Style.alert) //Replace
//
//                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
//                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
//                      (result : UIAlertAction) -> Void in
//
//                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                        let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                        self.navigationController?.pushViewController(viewController, animated: true)
//
//                    }
//                    alertController.addAction(okAction)
//
//                    self.present(alertController, animated: true, completion: nil)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
                self.txtCurrentLocation.text = self.addressString
                
                self.Latitude = location!.latitude
                self.Longitude = location!.longitude
                self.country = pm.country!
                self.city = pm.locality!
                self.state = pm.administrativeArea!
                
                let fullAddress = NSKeyedArchiver.archivedData(withRootObject: self.addressString )
                UserDefaults.standard.setValue(fullAddress, forKey: "key_currentaddress_info")
                UserDefaults.standard.synchronize()
                
                let currentLatData = NSKeyedArchiver.archivedData(withRootObject: self.Latitude )
                UserDefaults.standard.setValue(currentLatData, forKey: "key_currentlat_info")
                UserDefaults.standard.synchronize()
                
                let currentLngData = NSKeyedArchiver.archivedData(withRootObject: self.Longitude )
                UserDefaults.standard.setValue(currentLngData, forKey: "key_currentlng_info")
                UserDefaults.standard.synchronize()
                
                let countryData = NSKeyedArchiver.archivedData(withRootObject: self.country )
                UserDefaults.standard.setValue(countryData, forKey: "key_currentcountry_info")
                UserDefaults.standard.synchronize()
                
                let cityData = NSKeyedArchiver.archivedData(withRootObject: self.city )
                UserDefaults.standard.setValue(cityData, forKey: "key_currentcity_info")
                UserDefaults.standard.synchronize()
                
                let stateData = NSKeyedArchiver.archivedData(withRootObject: self.state )
                UserDefaults.standard.setValue(stateData, forKey: "key_currentstate_info")
                UserDefaults.standard.synchronize()
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            if (status == CLAuthorizationStatus.denied) {
                // The user denied authorization
                
            } else if (status == CLAuthorizationStatus.notDetermined){
                if isLocationEnabled == true{
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Application", bundle:nil)
                    let viewController = storyBoard.instantiateViewController(withIdentifier: "ChangeLocation") as! ChangeLocationViewController
                    viewController.fromLocationDeactive = true
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            else if (status == CLAuthorizationStatus.authorizedAlways) || (status == CLAuthorizationStatus.authorizedWhenInUse){
                // The user accepted authorization
            }
        }else{
            
        }
    }
    
    
    //MARK:- Current Location Button Action
    @IBAction func btnCurrentLocDidTap(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                if #available(iOS 10.0, *) {
                    let alertController = UIAlertController(title: "Location Service Disabled",
                                                            message: "Location services are not enabled",
                                                            preferredStyle: .alert)

                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                            self.showMessageResetApp()
                    }

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
                if self.addressString == ""{
                    locationManager.delegate = self
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }else{
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        } else {
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
    
    func showMessageResetApp(){
        let exitAppAlert = UIAlertController(title: "Location is needed",
                                             message: "We need to access your location inorder to proceed with the app.\n Please allow the location or else the app will be closed.",
                                             preferredStyle: .alert)
        
        let resetApp = UIAlertAction(title: "Close Now", style: .destructive) {
            (alert) -> Void in
            // home button pressed programmatically - to thorw app to background
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            // terminaing app in background
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                exit(EXIT_SUCCESS)
            })
        }
        
        let laterAction = UIAlertAction(title: "Later", style: .cancel) {
            (alert) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        exitAppAlert.addAction(resetApp)
        exitAppAlert.addAction(laterAction)
        self.present(exitAppAlert, animated: true, completion: nil)
        
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
