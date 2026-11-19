//
//  RegistrationViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 17/05/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import FlagPhoneNumber


class RegistrationViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var mainScrlView: UIScrollView!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobile: FPNTextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConPass: UITextField!
    @IBOutlet weak var txtContinent: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var btnSignupOutlet: UIButton!
    var cityData = NSArray()
    var stateData = NSArray()
    var country = NSArray()
    var continent = NSArray()
    
    var tagText = Int()
    @IBOutlet weak var vwOptions: UIView!
    @IBOutlet weak var dataFilterPicker: UIPickerView!
    var countryData = String()
    var usercityData = String()
    var userstateData = String()
    var continentData = String()
    var fromDenyLocation = Bool()
    var registered_token = String()
    var otp_string = String()
    var mobileString = String()
    var isUsernameCorrect = Bool()
    var isEmailCorrect = Bool()
    var isMobileCorrect = Bool()
    var countryList = NSMutableArray()
    var stateList = NSMutableArray()
    var cityList = NSMutableArray()
    var tempContinent = NSMutableArray()
    var tempCountry = NSMutableArray()
    var tempState = NSMutableArray()
    var tempCity = NSMutableArray()
    
    @IBOutlet weak var viewContinent: UIView!
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCity: UIView!
    var continentList = NSMutableArray()
    var country_code = String()
    
    @IBOutlet weak var txtFirstName: ImageTextField!
    
    var phoneFormatter = PhoneNumberFormatter() // (reset when loading different data into fields, with .reset() or new struct)
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
                
        self.fetchContinents()
        
        isUsernameCorrect = true
        isEmailCorrect = true
        isMobileCorrect = true
        
        txtFirstName.layer.borderColor = UIColor.lightGray.cgColor
        txtFirstName.layer.borderWidth = 1.5
        txtFirstName.layer.cornerRadius = 5
        
        txtLastName.layer.borderColor = UIColor.lightGray.cgColor
        txtLastName.layer.borderWidth = 1.5
        txtLastName.layer.cornerRadius = 5
        
        txtMobile.layer.borderColor = UIColor.lightGray.cgColor
        txtMobile.layer.borderWidth = 1.5
        txtMobile.layer.cornerRadius = 5
                
        txtUsername.layer.borderColor = UIColor.lightGray.cgColor
        txtUsername.layer.borderWidth = 1.5
        txtUsername.layer.cornerRadius = 5
        
        txtPassword.layer.borderColor = UIColor.lightGray.cgColor
        txtPassword.layer.borderWidth = 1.5
        txtPassword.layer.cornerRadius = 5
        
        txtConPass.layer.borderColor = UIColor.lightGray.cgColor
        txtConPass.layer.borderWidth = 1.5
        txtConPass.layer.cornerRadius = 5
        
        txtState.layer.borderColor = UIColor.lightGray.cgColor
        txtState.layer.borderWidth = 1.5
        txtState.layer.cornerRadius = 5
        
        txtContinent.layer.borderColor = UIColor.lightGray.cgColor
        txtContinent.layer.borderWidth = 1.5
        txtContinent.layer.cornerRadius = 5
        
        txtCity.layer.borderColor = UIColor.lightGray.cgColor
        txtCity.layer.borderWidth = 1.5
        txtCity.layer.cornerRadius = 5
        
        txtCountry.layer.borderColor = UIColor.lightGray.cgColor
        txtCountry.layer.borderWidth = 1.5
        txtCountry.layer.cornerRadius = 5
        
        txtEmailAddress.layer.borderColor = UIColor.lightGray.cgColor
        txtEmailAddress.layer.borderWidth = 1.5
        txtEmailAddress.layer.cornerRadius = 5
        
        txtZipCode.layer.borderColor = UIColor.lightGray.cgColor
        txtZipCode.layer.borderWidth = 1.5
        txtZipCode.layer.cornerRadius = 5
        
        txtMobile.parentViewController = self
        txtMobile.delegate = self
        
        txtFirstName.autocapitalizationType = .words
        txtLastName.autocapitalizationType = .words
        
        //txtMobile.flagSize = CGSize(width: 30, height: 30)
        //txtMobile.flagButtonEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Do any additional setup after loading the view.
        
        self.dataFilterPicker.isHidden = true
        self.vwOptions.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        mainScrlView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 900)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar()
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.items = items
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    //MARK:- Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func FormatField(_ sender: UITextField) {
        if let text = sender.text {
            if sender == txtMobile {
                sender.text = phoneFormatter.format(text)
                mobileString = sender.text!.onlyCharacters("0123456789")
            } else {
                //multiple phone numbers being validated at once require an additional unique hash parameter so we can keep them straight
                sender.text = phoneFormatter.format(text, hash: sender.hash)
            }
        }
    }
    
    //MARK:- Fetch Continent List
    
    func fetchContinents()
    {
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "get_continents"
        
        Alamofire.request(todosEndpoint, method: .post, parameters: nil,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                print("Registration Response:\(response)")
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                self.continentList = (json["continents"] as! NSArray).mutableCopy() as! NSMutableArray
                for conversationID in self.continentList {
                    let snapshotValue = conversationID as? NSDictionary
                    if let value = snapshotValue!["name"] as? String {
                        self.tempContinent.add(value)
                    }
                }
                self.continent = self.tempContinent
                if self.continent.count > 0 {
                    self.dataFilterPicker.isUserInteractionEnabled = true
                    self.dataFilterPicker.reloadAllComponents()
                } else {
                    self.dataFilterPicker.isUserInteractionEnabled = false
                }
        }
        SVProgressHUD.dismiss(completion: {
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
            self.vwOptions.isUserInteractionEnabled = true
        })
    }
    
    //MARK:- Fetch Country List
    
    func fetchCountries(forContinentName continentName: String){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "get_countries"
        
        let newTodo: [String: Any] = ["continent":continentName]
                
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                self.countryList = (json["countries"] as! NSArray).mutableCopy() as! NSMutableArray
                for conversationID in self.countryList {
                    let snapshotValue = conversationID as? NSDictionary
                    if let value = snapshotValue!["name"] as? String {
                        self.tempCountry.add(value)
                    }
                }
                self.country = self.tempCountry
                if self.country.count > 0 {
                    self.dataFilterPicker.isUserInteractionEnabled = true
                    self.dataFilterPicker.reloadAllComponents()
                } else {
                    self.dataFilterPicker.isUserInteractionEnabled = false
                }
        }
        SVProgressHUD.dismiss(completion: {
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
            self.vwOptions.isUserInteractionEnabled = true
        })
    }
    
    //MARK:- Fetch State Api call
    
    func fetchStates(forCountryName countryName: String) {
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "get_states"
        
        let newTodo: [String: Any] = ["country":countryName]
                
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                self.stateList = (json["countries"] as! NSArray).mutableCopy() as! NSMutableArray
                for conversationID in self.stateList {
                    let snapshotValue = conversationID as? NSDictionary
                    if let value = snapshotValue!["name"] as? String {
                        self.tempState.add(value)
                    }
                }
                self.stateData = self.tempState
                if self.country.count > 0 {
                   self.dataFilterPicker.isUserInteractionEnabled = true
                   self.dataFilterPicker.reloadAllComponents()
               } else {
                   self.dataFilterPicker.isUserInteractionEnabled = false
               }
        }
        SVProgressHUD.dismiss(completion: {
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
            self.vwOptions.isUserInteractionEnabled = true
        })
    }
    
    //MARK:- Fetch City Api Call
    
    func fetchCities(forStateName stateName: String) {
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "get_cities"
        
        let newTodo: [String: Any] = ["state":stateName]
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                self.cityList = (json["countries"] as! NSArray).mutableCopy() as! NSMutableArray
                for conversationID in self.cityList {
                    let snapshotValue = conversationID as? NSDictionary
                    if let value = snapshotValue!["name"] as? String {
                        self.tempCity.add(value)
                    }
                }
                self.cityData = self.tempCity
                if self.country.count > 0 {
                   self.dataFilterPicker.isUserInteractionEnabled = true
                   self.dataFilterPicker.reloadAllComponents()
                } else {
                   self.dataFilterPicker.isUserInteractionEnabled = false
                }
        }
        SVProgressHUD.dismiss(completion: {
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
            self.vwOptions.isUserInteractionEnabled = true
        })
    }
    
    
    //MARK:- TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField == self.txtUsername) {
            self.apiCallAvailability()
        }
        if (textField == self.txtEmailAddress) {
            self.apiCallEmailAvailability()
        }
        if (textField == self.txtMobile) {
            self.apiCallMobileAvailability()
        }
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        if(textField == self.txtCity){
//            self.view.endEditing(true)
//             textField.resignFirstResponder()
//            self.dataFilterPicker.isHidden = false
//            self.vwOptions.isHidden = false
//            tagText = 0
//            self.dataFilterPicker.reloadAllComponents()
//        }else if(textField == self.txtState){
//            self.view.endEditing(true)
//             textField.resignFirstResponder()
//            self.dataFilterPicker.isHidden = false
//            self.vwOptions.isHidden = false
//            tagText = 1
//            self.dataFilterPicker.reloadAllComponents()
//        }else if(textField == self.txtCountry){
//            self.view.endEditing(true)
//             textField.resignFirstResponder()
//            self.dataFilterPicker.isHidden = false
//            self.vwOptions.isHidden = false
//            tagText = 2
//            self.dataFilterPicker.reloadAllComponents()
//        }
//        else{
//            self.dataFilterPicker.isHidden = true
//            self.vwOptions.isHidden = true
//
//        }
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if (textField == txtConPass){
            if txtPassword.text != txtConPass.text{
                self.txtPassword.rightViewMode = UITextField.ViewMode.always
                self.txtConPass.rightViewMode = UITextField.ViewMode.always
                self.txtPassword.rightView = UIImageView(image: UIImage(named: "delete"))
                self.txtConPass.rightView = UIImageView(image: UIImage(named: "delete"))
            }else{
                self.txtPassword.rightViewMode = UITextField.ViewMode.always
                self.txtConPass.rightViewMode = UITextField.ViewMode.always
                self.txtPassword.rightView = UIImageView(image: UIImage(named: "check-circular"))
                self.txtConPass.rightView = UIImageView(image: UIImage(named: "check-circular"))
            }
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }else{
            // Combine the textView text and the replacement text to
            // create the updated text string
            let currentText:String = textView.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
            
            // If updated text view will be empty, add the placeholder
            // and set the cursor to the beginning of the text view
            if updatedText.isEmpty {
                
                textView.text = "Enter the address"
                textView.textColor = UIColor.lightGray
                
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
                
                // Else if the text view's placeholder is showing and the
                // length of the replacement string is greater than 0, set
                // the text color to black then set its text to the
                // replacement string
            else if textView.textColor == UIColor.lightGray && !text.isEmpty {
                textView.textColor = UIColor.black
                textView.text = text
            }
                
                // For every other case, the text should change with the usual
                // behavior...
            else {
                return true
            }
            
            // ...otherwise return false since the updates have already
            // been made
            return false
        }
    }
    
    //MARK:- Continent Button Action
    
    @IBAction func btnContinentDropdownDidTap(_ sender: Any) {
        self.view.endEditing(true)
        self.dataFilterPicker.isHidden = false
        self.vwOptions.isHidden = false
        tagText = 3
        self.dataFilterPicker.reloadAllComponents()
    }
    
    //MARK:- Country Button Action
    @IBAction func btnCountryDrodownDidTap(_ sender: Any) {
       self.view.endEditing(true)
       self.dataFilterPicker.isHidden = false
       self.vwOptions.isHidden = false
       tagText = 2
       self.dataFilterPicker.reloadAllComponents()
    }
    
    
    //MARK:- State Button Action
    @IBAction func btnStateDropdownDidTap(_ sender: Any) {
       self.view.endEditing(true)
       self.dataFilterPicker.isHidden = false
       self.vwOptions.isHidden = false
       tagText = 1
       self.dataFilterPicker.reloadAllComponents()
    }
    
    //MARK:- City Button Action
    @IBAction func btnCityDropdownDidTap(_ sender: Any) {
       self.view.endEditing(true)
       self.dataFilterPicker.isHidden = false
       self.vwOptions.isHidden = false
       tagText = 0
       self.dataFilterPicker.reloadAllComponents()
    }
    
    
    
    //MARK:- Signup Button Action
    @IBAction func btnSignupDidTap(_ sender: Any) {
        if txtFirstName.text! == "" && txtLastName.text! == "" && txtUsername.text! == "" && txtContinent.text! == "Enter the address" && txtEmailAddress.text! == "" && txtPassword.text! == "" && txtConPass.text! == "" && txtCity.text! == "" && txtState.text! == "" && txtCountry.text! == "" && txtZipCode.text! == ""{
            
            txtEmailAddress.attributedPlaceholder = NSAttributedString(string: "Please enter a valid email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtEmailAddress.layer.borderColor = UIColor.red.cgColor
            txtEmailAddress.layer.borderWidth = 1.0
            
            txtFirstName.attributedPlaceholder = NSAttributedString(string: "Please enter first name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtFirstName.layer.borderColor = UIColor.red.cgColor
            txtFirstName.layer.borderWidth = 1.0
            
            txtLastName.attributedPlaceholder = NSAttributedString(string: "Please enter last name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtLastName.layer.borderColor = UIColor.red.cgColor
            txtLastName.layer.borderWidth = 1.0
            
            txtUsername.attributedPlaceholder = NSAttributedString(string: "Please enter username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtUsername.layer.borderColor = UIColor.red.cgColor
            txtUsername.layer.borderWidth = 1.0
            
            txtCity.attributedPlaceholder = NSAttributedString(string: "Please select city", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtCity.layer.borderColor = UIColor.red.cgColor
            txtCity.layer.borderWidth = 1.0
            
            txtState.attributedPlaceholder = NSAttributedString(string: "Please select state", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtState.layer.borderColor = UIColor.red.cgColor
            txtState.layer.borderWidth = 1.0
            
            txtCountry.attributedPlaceholder = NSAttributedString(string: "Please select country", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtCountry.layer.borderColor = UIColor.red.cgColor
            txtCountry.layer.borderWidth = 1.0
            
            txtPassword.attributedPlaceholder = NSAttributedString(string: "Please enter password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtPassword.layer.borderColor = UIColor.red.cgColor
            txtPassword.layer.borderWidth = 1.0
            
            txtConPass.attributedPlaceholder = NSAttributedString(string: "Please confirm the entered password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtConPass.layer.borderColor = UIColor.red.cgColor
            txtConPass.layer.borderWidth = 1.0
            
            txtZipCode.attributedPlaceholder = NSAttributedString(string: "Please enter zipcode", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtZipCode.layer.borderColor = UIColor.red.cgColor
            txtZipCode.layer.borderWidth = 1.0
            
            txtContinent.layer.borderColor = UIColor.red.cgColor
            txtCountry.layer.borderColor = UIColor.red.cgColor
            txtState.layer.borderColor = UIColor.red.cgColor
            txtCity.layer.borderColor = UIColor.red.cgColor
            
            let alert = UIAlertController(title: "Alert", message: "Every field is mandatory", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
//        if (txtAddress.text! != "Enter the address"){
//            txtAddress.layer.borderColor = UIColor.black.cgColor
//        }
        if (txtFirstName.text!.count == 0 || txtFirstName.text!.isEmpty || (self.txtFirstName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
             txtFirstName.attributedPlaceholder = NSAttributedString(string: "Please enter first name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtFirstName.layer.borderColor = UIColor.red.cgColor
            txtFirstName.layer.borderWidth = 1.0
        }else{
            txtFirstName.layer.borderColor = UIColor.black.cgColor
        }
        if (txtLastName.text!.count == 0 || txtLastName.text!.isEmpty || (self.txtLastName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtLastName.attributedPlaceholder = NSAttributedString(string: "Please enter last name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtLastName.layer.borderColor = UIColor.red.cgColor
            txtLastName.layer.borderWidth = 1.0
        }
        else{
            txtLastName.layer.borderColor = UIColor.black.cgColor
        }
        if (txtUsername.text!.count == 0 || txtUsername.text!.isEmpty || (self.txtUsername.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtUsername.attributedPlaceholder = NSAttributedString(string: "Please enter username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtUsername.layer.borderColor = UIColor.red.cgColor
            txtUsername.layer.borderWidth = 1.0
        }
        else{
            txtUsername.layer.borderColor = UIColor.black.cgColor
        }
        if (txtEmailAddress.text!.count == 0 || txtEmailAddress.text!.isEmpty || (self.txtEmailAddress.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtEmailAddress.attributedPlaceholder = NSAttributedString(string: "Please enter email address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtEmailAddress.layer.borderColor = UIColor.red.cgColor
            txtEmailAddress.layer.borderWidth = 1.0
        }
        else{
            txtEmailAddress.layer.borderColor = UIColor.black.cgColor
        }
        if (txtPassword.text!.count == 0 || txtPassword.text!.isEmpty || (self.txtPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtPassword.attributedPlaceholder = NSAttributedString(string: "Please enter password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtPassword.layer.borderColor = UIColor.red.cgColor
            txtPassword.layer.borderWidth = 1.0
        }
        else{
            txtPassword.layer.borderColor = UIColor.black.cgColor
        }
        if (txtConPass.text!.count == 0 || txtConPass.text!.isEmpty || (self.txtConPass.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtConPass.attributedPlaceholder = NSAttributedString(string: "Please enter confirm password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtConPass.layer.borderColor = UIColor.red.cgColor
            txtConPass.layer.borderWidth = 1.0
        }
        else{
            txtConPass.layer.borderColor = UIColor.black.cgColor
        }
        if (txtState.text!.count == 0 || txtState.text!.isEmpty || (self.txtState.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtState.attributedPlaceholder = NSAttributedString(string: "Please select state", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtState.layer.borderColor = UIColor.red.cgColor
            txtState.layer.borderWidth = 1.0
        }
        else{
            txtState.layer.borderColor = UIColor.black.cgColor
        }
        if (txtCity.text!.count == 0 || txtCity.text!.isEmpty || (self.txtCity.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtCity.attributedPlaceholder = NSAttributedString(string: "Please select city", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtCity.layer.borderColor = UIColor.red.cgColor
            txtCity.layer.borderWidth = 1.0
        }
        else{
            txtCity.layer.borderColor = UIColor.black.cgColor
        }
        if (txtCountry.text!.count == 0 || txtCountry.text!.isEmpty || (self.txtCountry.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtCountry.attributedPlaceholder = NSAttributedString(string: "Please select country", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtCountry.layer.borderColor = UIColor.red.cgColor
            txtCountry.layer.borderWidth = 1.0
        }
        else{
            txtCountry.layer.borderColor = UIColor.black.cgColor
        }
        if (txtContinent.text!.count == 0 || txtContinent.text!.isEmpty || (self.txtContinent.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtContinent.attributedPlaceholder = NSAttributedString(string: "Please select continent", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtContinent.layer.borderColor = UIColor.red.cgColor
            txtContinent.layer.borderWidth = 1.0
        }
        else{
            txtCountry.layer.borderColor = UIColor.black.cgColor
        }
        if (txtZipCode.text!.count == 0 || txtZipCode.text!.isEmpty || (self.txtZipCode.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtZipCode.attributedPlaceholder = NSAttributedString(string: "Please enter zipcode", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtZipCode.layer.borderColor = UIColor.red.cgColor
            txtZipCode.layer.borderWidth = 1.0
        }else{
            txtZipCode.layer.borderColor = UIColor.black.cgColor
        }
        if txtPassword.text! != txtConPass.text!{
            let alert = UIAlertController(title: "Alert", message: "Password mismatch", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if !(isValidEmail(testStr: txtEmailAddress.text!)){
            txtEmailAddress.text = ""
            txtEmailAddress.attributedPlaceholder = NSAttributedString(string: "Please enter a valid email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtEmailAddress.layer.borderColor = UIColor.red.cgColor
            txtEmailAddress.layer.borderWidth = 1.0
            //txtEmailAddress.becomeFirstResponder()
        }else{
            if self.isUsernameCorrect == true && self.isEmailCorrect == true && self.isMobileCorrect == true{
                self.country_code = (txtMobile.selectedCountry?.phoneCode)!
                print(self.country_code)
                self.apiCallRegistration()
            }
            else{
                
            }
        }
    }
    
    //MARK: - API Call
    func apiCallRegistration(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "registration"
        
        let newTodo: [String: Any] = ["fname": txtFirstName.text!, "lname": txtLastName.text!,"username":txtUsername.text!, "email":txtEmailAddress.text!, "phone":mobileString, "password":txtPassword.text!, "address":txtContinent.text!, "city":txtCity.text!, "state":txtState.text!, "country":txtCountry.text!,"zip_code":txtZipCode.text!,"country_code": self.country_code]
                
        print(newTodo)
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                //In this instance IsAuthenticated = 1 in Api response (1 means true and 0 means false).It is displaying as 1 and 0 but actually it is boolean value
                print(json)
                if ((json["status"]  as! Int) == 1){
                    self.registered_token = json["otp_token"] as! String
                    UserDefaults.standard.set(self.registered_token, forKey: "registerToken")
                    
                    self.otp_string = String(json["otp"] as! Int)
                    let constring = (json["message"] as! String)
                    
                    
                    let alertController = UIAlertController(title: "Success", message: constring, preferredStyle: UIAlertController.Style.alert) //Replace
                    
                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let HomeViewController = storyBoard.instantiateViewController(withIdentifier: "OTP") as! OTPViewController
                        HomeViewController.registered_token = self.registered_token
                        self.navigationController?.pushViewController(HomeViewController, animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                   
                    SVProgressHUD.dismiss()
                }else{
                    
                    let alertController = UIAlertController(title: "Error", message: json["message"] as? String, preferredStyle: UIAlertController.Style.alert) //Replace
                    
                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                }
        }
    }
    
    //MARK:- Email Validation Checking
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK:- Picker view delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if tagText == 0 {
            return self.cityData.count
        } else if tagText == 1{
            return self.stateData.count
        } else if tagText == 2{
            return self.country.count
        } else if tagText == 3{
            return self.continent.count
        } else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if tagText == 0 {
            return self.cityData[row] as? String
        } else if tagText == 1{
            return self.stateData[row] as? String
        } else if tagText == 2{
            return self.country[row] as? String
        } else if tagText == 3{
            return self.continent[row] as? String
        }else{
            return ""
        }
    }
    
    //MARK:- Done Button Action
    
    @IBAction func btnDoneDidTap(_ sender: Any)
    {
        let row = self.dataFilterPicker.selectedRow(inComponent: 0);
        NSLog("value L %d", row)
        if tagText == 0 {
            if self.cityData.count > 0{
                self.txtCity.text = self.cityData[row] as? String
                self.dataFilterPicker.isHidden = true
                self.vwOptions.isHidden = true
            }
        }else if tagText == 1 {
            if self.stateData.count > 0{
                self.txtState.text = self.stateData[row] as? String
                self.dataFilterPicker.isHidden = true
                self.vwOptions.isHidden = true
                self.tempCity = []
                self.txtCity.text = usercityData
                self.fetchCities(forStateName: ((self.stateData[row] as? String)!))
            }
        }else if tagText == 2 {
            if self.country.count > 0{
                self.txtCountry.text = self.country[row] as? String
                self.dataFilterPicker.isHidden = true
                self.vwOptions.isHidden = true
                self.tempState = []
                self.txtState.text = userstateData
                self.txtCity.text = usercityData
                self.fetchStates(forCountryName: ((self.country[row] as? String)!))
            }
        }else if tagText == 3 {
            if self.continent.count > 0{
                self.txtContinent.text = self.continent[row] as? String
                self.dataFilterPicker.isHidden = true
                self.vwOptions.isHidden = true
                self.tempContinent = []
                self.txtCountry.text = ""
                self.txtState.text = ""
                self.txtCity.text = ""
                self.fetchCountries(forContinentName: (self.continent[row] as? String)!)
            }
        }
    }
    
    //MARK:- Cancel Button Action
    
    @IBAction func btnCancelDidTap(_ sender: Any)
    {
        if tagText == 0 {
            self.txtCity.text = usercityData
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
        }else if tagText == 1 {
            self.txtState.text = userstateData
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
        }else if tagText == 2 {
            self.txtCountry.text = countryData
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
        }else if tagText == 3 {
            self.txtContinent.text = continentData
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
        }
    }
    
    //MARK:- SignIn Button
    
    @IBAction func btnSignInDidTap(_ sender: Any) {
        let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        self.navigationController?.pushViewController(LoginViewController, animated: true)
    }
    
    //MARK:- Mobile Availability Api Call
    
    func apiCallMobileAvailability(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "check_phone_if_exist"
        
        let newTodo: [String: Any] = ["phone":mobileString]
        print(newTodo)
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                
                if ((json["status"]  as! Int) == 1){
                    self.txtMobile.rightViewMode = UITextField.ViewMode.always
                    self.txtMobile.rightView = UIImageView(image: UIImage(named: "check-circular"))
                    self.isMobileCorrect = true
                    SVProgressHUD.dismiss()
                }else{
                    self.txtMobile.rightViewMode = UITextField.ViewMode.always
                    self.txtMobile.rightView = UIImageView(image: UIImage(named: "delete"))
                    //self.txtEmailAddress.becomeFirstResponder()
                    self.isMobileCorrect = false
                    SVProgressHUD.dismiss()
                }
        }
    }
    
    //MARK:- Email Availability Api Call
    
    func apiCallEmailAvailability(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "check_email_if_exist"
        
        let newTodo: [String: Any] = ["email":txtEmailAddress.text!]
                
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                
                if ((json["status"]  as! Int) == 1){
                    self.txtEmailAddress.rightViewMode = UITextField.ViewMode.always
                    self.txtEmailAddress.rightView = UIImageView(image: UIImage(named: "check-circular"))
                    self.isEmailCorrect = true
                    SVProgressHUD.dismiss()
                }else{
                    self.txtEmailAddress.rightViewMode = UITextField.ViewMode.always
                    self.txtEmailAddress.rightView = UIImageView(image: UIImage(named: "delete"))
                    //self.txtEmailAddress.becomeFirstResponder()
                    self.isEmailCorrect = false
                    SVProgressHUD.dismiss()
                }
        }
    }
    
    
    //MARK:- Availability Api Call
    
    func apiCallAvailability(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "check_username_if_exist"
        
        let newTodo: [String: Any] = ["username":txtUsername.text!]
                
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                
                if ((json["status"]  as! Int) == 1){
                    self.txtUsername.rightViewMode = UITextField.ViewMode.always
                    self.txtUsername.rightView = UIImageView(image: UIImage(named: "check-circular"))
                    self.isUsernameCorrect = true
                    SVProgressHUD.dismiss()
                }else{
                    self.txtUsername.rightViewMode = UITextField.ViewMode.always
                    self.txtUsername.rightView = UIImageView(image: UIImage(named: "delete"))
                    //self.txtUsername.becomeFirstResponder()
                    self.isUsernameCorrect = false
                    SVProgressHUD.dismiss()
                }
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

extension RegistrationViewController: FPNTextFieldDelegate {
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        //textField.rightViewMode = .always
        //textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "success") : #imageLiteral(resourceName: "error"))
        
        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
            textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
            textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
            textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
            textField.getRawPhoneNumber() ?? "Raw: nil"
        )
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }
}
