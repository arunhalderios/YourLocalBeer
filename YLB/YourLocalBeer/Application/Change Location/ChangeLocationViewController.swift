//
//  ChangeLocationViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 04/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire


class ChangeLocationViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var txtContinent: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    var fromLocationDeactive = Bool()
    var fromMapPage = Bool()
    var fromCategoryPage = Bool()
    var fromPage = String()
    @IBOutlet weak var vwPicker: UIPickerView!
    var cityData = NSArray()
    var stateData = NSArray()
    var country = NSArray()
    var continent = NSArray()
    var tagText = Int()
    @IBOutlet weak var vwOptions: UIView!
    var countryList = NSMutableArray()
    var stateList = NSMutableArray()
    var cityList = NSMutableArray()
    var tempCountry = NSMutableArray()
    var tempState = NSMutableArray()
    var tempCity = NSMutableArray()
    var continentList = NSMutableArray()
    var tempContinent = NSMutableArray()
    
    @IBOutlet weak var viewContinent: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCity: UIView!
    var changeLocation = Bool()
    
    
    
    //MARK:- View Lifecycle
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        self.fetchContinents()
        
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor(red: 183.0/255.0, green: 97.0/255.0, blue: 20.0/255.0, alpha: 1.0)
//        }
        
        txtContinent.layer.borderColor = UIColor.lightGray.cgColor
        txtContinent.layer.borderWidth = 1.5
        txtContinent.layer.cornerRadius = 5
        
        txtCountry.layer.borderColor = UIColor.lightGray.cgColor
        txtCountry.layer.borderWidth = 1.5
        txtCountry.layer.cornerRadius = 5
        
        txtState.layer.borderColor = UIColor.lightGray.cgColor
        txtState.layer.borderWidth = 1.5
        txtState.layer.cornerRadius = 5
        
        txtCity.layer.borderColor = UIColor.lightGray.cgColor
        txtCity.layer.borderWidth = 1.5
        txtCity.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
        
        self.vwPicker.isHidden = true
        self.vwOptions.isHidden = true
        
        UserDefaults.standard.removeObject(forKey: "key_currentcontinent_info")
        UserDefaults.standard.removeObject(forKey: "key_currentdenycountry_info")
        UserDefaults.standard.removeObject(forKey: "key_currentdenystate_info")
        UserDefaults.standard.removeObject(forKey: "key_currentdenycity_info")
        UserDefaults.standard.removeObject(forKey: "key_continentzip_info")
        UserDefaults.standard.removeObject(forKey: "key_currentdenyzip_info")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show(withStatus: "It's working...")
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu"), style:  UIBarButtonItemStyle.plain, target: self, action: #selector(ChangeLocationViewController.barButtonClickAction))
        
        if (fromLocationDeactive == true){
            self.navigationItem.setHidesBackButton(true, animated:true);
        }else{
            self.navigationItem.setHidesBackButton(false, animated:true);
        }
        // Only execute the code if there's a navigation controller
        if self.navigationController == nil {
            return
        }
        
        // Create a navView to add to the navigation bar
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = "Change Search Location"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        
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
    
    @objc func barButtonClickAction() {
        print("Button click...")
    }
    
    //MARK:- Reset Button Action
    @IBAction func btnResetDidTap(_ sender: Any) {
        self.txtContinent.text = ""
        self.txtCountry.text = ""
        self.txtState.text = ""
        self.txtCity.text = ""
    }
    
    //MARK:- Fetch Continent List
    
    func fetchContinents()
    {
        let todosEndpoint: String = BASE_URL + "get_continents"
        
        Alamofire.request(todosEndpoint, method: .post, parameters: nil,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    //print("Error: \(response.result.error as! NSString)")
                    SVProgressHUD.dismiss()
                    return
                }
                print("JSON: \(json)")
                self.continentList = (json["continents"] as! NSArray).mutableCopy() as! NSMutableArray
                for conversationID in self.continentList {
                    let snapshotValue = conversationID as? NSDictionary
                    if let value = snapshotValue!["name"] as? String {
                        self.tempContinent.add(value)
                    }
                }
                self.continent = self.tempContinent
                self.vwPicker.selectRow(1, inComponent: 0, animated: false)
                self.txtContinent.text = self.continent[1] as? String
                self.fetchCountries(forContinentName: self.txtContinent.text!)
                self.vwPicker.reloadAllComponents()
        }
        SVProgressHUD.dismiss()
    }
    
    //MARK:- Fetch Country List
    
    func fetchCountries(forContinentName continentName: String){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "get_countries"
        
        let newTodo: [String: Any] = ["continent":continentName]
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
                self.countryList = (json["countries"] as! NSArray).mutableCopy() as! NSMutableArray
                for conversationID in self.countryList {
                    let snapshotValue = conversationID as? NSDictionary
                    if let value = snapshotValue!["name"] as? String {
                        self.tempCountry.add(value)
                    }
                }
                self.country = self.tempCountry
                if self.txtContinent.text == "Europe"{
                    
                }else{
                    self.txtCountry.text = self.country[1] as? String
                    self.fetchStates(forCountryName: self.txtCountry.text!)
                }
                SVProgressHUD.dismiss()
                self.vwPicker.reloadAllComponents()
        }
        
    }
    
    //MARK:- Fetch State Api call
    
    func fetchStates(forCountryName countryName: String) {
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "get_states"
        
        let newTodo: [String: Any] = ["country":countryName]
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
                self.stateList = (json["countries"] as! NSArray).mutableCopy() as! NSMutableArray
                for conversationID in self.stateList {
                    let snapshotValue = conversationID as? NSDictionary
                    if let value = snapshotValue!["name"] as? String {
                        self.tempState.add(value)
                    }
                }
                self.stateData = self.tempState
                self.vwPicker.reloadAllComponents()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Fetch City Api Call
    
    func fetchCities(forStateName stateName: String) {
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "get_cities"
        
        let newTodo: [String: Any] = ["state":stateName]
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
                self.cityList = (json["countries"] as! NSArray).mutableCopy() as! NSMutableArray
                for conversationID in self.cityList {
                    let snapshotValue = conversationID as? NSDictionary
                    if let value = snapshotValue!["name"] as? String {
                        self.tempCity.add(value)
                    }
                }
                self.cityData = self.tempCity
                self.vwPicker.reloadAllComponents()
                SVProgressHUD.dismiss()
        }
        
    }
    
    //MARK:- TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == self.txtCity){
            self.view.endEditing(true)
            self.vwPicker.isHidden = false
            self.vwOptions.isHidden = false
            tagText = 3
            self.vwPicker.reloadAllComponents()
        }else if(textField == self.txtState){
            self.view.endEditing(true)
            self.vwPicker.isHidden = false
            self.vwOptions.isHidden = false
            tagText = 2
            self.vwPicker.reloadAllComponents()
        }else if(textField == self.txtCountry){
            self.view.endEditing(true)
            self.vwPicker.isHidden = false
            self.vwOptions.isHidden = false
            tagText = 1
            self.vwPicker.reloadAllComponents()
        }else if(textField == self.txtContinent){
            self.view.endEditing(true)
            self.vwPicker.isHidden = false
            self.vwOptions.isHidden = false
            tagText = 0
            self.vwPicker.reloadAllComponents()
        }
        else{
            self.vwPicker.isHidden = true
            self.vwOptions.isHidden = true
        }
    }
    
    
    //MARK:- Submit Button Action
    @IBAction func btnSubmitDidTap(_ sender: Any) {
        
            if txtContinent.text!.count == 0{
                let alert = UIAlertController(title: "Alert", message: "Please select an continent", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else if txtCountry.text!.count == 0{
                let alert = UIAlertController(title: "Alert", message: "Please select the country", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if self.txtContinent.text == "Europe"{
                
            }else{
                if txtState.text!.count == 0{
//                    let alert = UIAlertController(title: "Alert", message: "Please select the state", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
                }else if txtCity.text!.count == 0{
//                    let alert = UIAlertController(title: "Alert", message: "Please select the city", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            if ((txtContinent.text!.count > 0) && (txtCountry.text!.count > 0) || (txtState.text!.count > 0) || (txtCity.text!.count > 0)){
                let currentContinentData = NSKeyedArchiver.archivedData(withRootObject: self.txtContinent.text! )
                UserDefaults.standard.setValue(currentContinentData, forKey: "key_currentcontinent_info")
                UserDefaults.standard.synchronize()
                
                let currentCountryData = NSKeyedArchiver.archivedData(withRootObject: self.txtCountry.text! )
                UserDefaults.standard.setValue(currentCountryData, forKey: "key_currentdenycountry_info")
                UserDefaults.standard.synchronize()
                
                let stateData = NSKeyedArchiver.archivedData(withRootObject: self.txtState.text! )
                UserDefaults.standard.setValue(stateData, forKey: "key_currentdenystate_info")
                UserDefaults.standard.synchronize()
                
                let cityData = NSKeyedArchiver.archivedData(withRootObject: self.txtCity.text! )
                UserDefaults.standard.setValue(cityData, forKey: "key_currentdenycity_info")
                UserDefaults.standard.synchronize()
                
                if (fromLocationDeactive == true){
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let ViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    ViewController.fromDenyLocation = true
                    self.navigationController?.pushViewController(ViewController, animated: true)
                }else if (fromMapPage == true || fromCategoryPage == true){
                    if fromMapPage == true{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Application", bundle:nil)
                        let ViewController = storyBoard.instantiateViewController(withIdentifier: "MapPage") as! MapPageViewController
                        print(self.fromMapPage)
                        ViewController.fromMapPage = self.fromMapPage
                        ViewController.fromCategoryPage = true
                        ViewController.PageName = self.fromPage
                        self.navigationController?.pushViewController(ViewController, animated: true)
                    }else if fromCategoryPage == true || changeLocation == true{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Application", bundle:nil)
                        let ViewController = storyBoard.instantiateViewController(withIdentifier: "Category") as! CategoryViewController
                        print(self.fromCategoryPage)
                        ViewController.fromCategoryPage = self.fromCategoryPage
                        ViewController.changeLocation = self.changeLocation
                        self.navigationController?.pushViewController(ViewController, animated: true)
                    }
                    else{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
                else{
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let ViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    ViewController.fromDenyLocation = true
                    self.navigationController?.pushViewController(ViewController, animated: true)
                }
            }
    }
    
    //MARK:- Picker view delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if tagText == 0 {
            return self.continent.count
        } else if tagText == 1{
            return self.country.count
        } else if tagText == 2{
            return self.stateData.count
        }else if tagText == 3{
            return self.cityData.count
        }else if tagText == 4{
            return self.continent.count
        }else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if tagText == 0 {
            return self.continent[row] as? String
        } else if tagText == 1{
            return self.country[row] as? String
        } else if tagText == 2{
            return self.stateData[row] as? String
        }else if tagText == 3{
            return self.cityData[row] as? String
        }else if tagText == 4{
            return self.continent[row] as? String
        }else{
            return ""
        }
    }
    
    @IBAction func btnOtherContinentDidTap(_ sender: Any) {
        self.view.endEditing(true)
        self.vwPicker.isHidden = false
        self.vwOptions.isHidden = false
        tagText = 4
        self.vwPicker.reloadAllComponents()
    }
    
    
    @IBAction func btnDoneDidTap(_ sender: Any) {
        let row = self.vwPicker.selectedRow(inComponent: 0);
        NSLog("value L %d", row)
        if tagText == 3 {
            if self.cityData.count > 0{
                self.txtCity.text = self.cityData[row] as? String
                self.vwPicker.isHidden = true
                self.vwOptions.isHidden = true
            }else{
                self.vwPicker.isHidden = true
                self.vwOptions.isHidden = true
            }
        }else if tagText == 2 {
            if self.stateData.count > 0{
                self.txtState.text = self.stateData[row] as? String
                self.vwPicker.isHidden = true
                self.vwOptions.isHidden = true
                self.tempCity = []
                self.txtCity.text = ""
                self.fetchCities(forStateName: ((self.stateData[row] as? String)!))
            }else{
                self.vwPicker.isHidden = true
                self.vwOptions.isHidden = true
            }
        }else if tagText == 1 {
            self.txtCountry.text = self.country[row] as? String
            self.vwPicker.isHidden = true
            self.vwOptions.isHidden = true
            self.tempState = []
            self.txtState.text = ""
            self.txtCity.text = ""
            self.fetchStates(forCountryName: ((self.country[row] as? String)!))
        }else if tagText == 0 {
            self.txtContinent.text = self.continent[row] as? String
            if self.txtContinent.text == "Europe"{
                self.txtState.placeholder = "County / Province"
            }else{
                self.txtState.placeholder = "Select State"
            }
            self.vwPicker.isHidden = true
            self.vwOptions.isHidden = true
            self.tempCountry = []
            self.txtCountry.text = ""
            self.txtState.text = ""
            self.txtCity.text = ""
            self.fetchCountries(forContinentName: (self.continent[row] as? String)!)
        }
    }
    
    @IBAction func btnCancelDidTap(_ sender: Any) {
        if tagText == 3 {
            self.txtCity.text = ""
            self.vwPicker.isHidden = true
            self.vwOptions.isHidden = true
        }else if tagText == 2 {
            self.txtState.text = ""
            self.vwPicker.isHidden = true
            self.vwOptions.isHidden = true
        }else if tagText == 1 {
            self.txtCountry.text = ""
            self.vwPicker.isHidden = true
            self.vwOptions.isHidden = true
        }else if tagText == 0 {
            self.txtContinent.text = ""
            self.viewState.isHidden = false
            self.viewCity.isHidden = false
            self.vwPicker.isHidden = true
            self.vwOptions.isHidden = true
        }
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
