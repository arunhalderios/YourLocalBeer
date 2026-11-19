//
//  EditProfileViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 16/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SVProgressHUD

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var userImage: UIImageView!
    var malecount = Int()
    var femalecount = Int()
    @IBOutlet weak var malebutton: UIButton!
    @IBOutlet weak var femalebutton: UIButton!
    var gender = String()
    
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var txtMobile: UITextField!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCountry: ImageTextField!
    @IBOutlet weak var txtState: ImageTextField!
    @IBOutlet weak var txtCity: ImageTextField!
    @IBOutlet weak var txtZipcode: UITextField!
    var logIndict = NSDictionary()
    var fileUrl = NSURL()
    var ImagePicker = UIImagePickerController()
    var fromCamera = Bool()
    var imageData: UIImage!
    var cameraData : NSData?
    var login_token = String()
    var user_id = String()
    var isUsernameCorrect = Bool()
    var isEmailCorrect = Bool()
    @IBOutlet weak var btnSaveOutlet: UIButton!
    var cityData = NSArray()
    var stateData = NSArray()
    var country = NSArray()
    var continent = NSArray()
    
    var countryData = String()
    var usercityData = String()
    var userstateData = String()
    var continentData = String()
    
    var countryList = NSMutableArray()
    var stateList = NSMutableArray()
    var cityList = NSMutableArray()
    var tempContinent = NSMutableArray()
    var tempCountry = NSMutableArray()
    var tempState = NSMutableArray()
    var tempCity = NSMutableArray()
    var continentList = NSMutableArray()
    var tagText = Int()
    @IBOutlet weak var vwOptions: UIView!
    @IBOutlet weak var dataFilterPicker: UIPickerView!
    
    
    var phoneFormatter = PhoneNumberFormatter() // (reset when loading different data into fields, with .reset() or new struct)
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
         } else {
            // Fallback on earlier versions
        }
        
        isUsernameCorrect = true
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logIndict)")
        
        // Do any additional setup after loading the view.
        userImage.layer.cornerRadius = self.userImage.frame.size.width/2
        userImage.clipsToBounds = true
        
        btnSaveOutlet.layer.cornerRadius = 20
        btnSaveOutlet.layer.masksToBounds = true
        
        txtCountry.inputView = dataFilterPicker
        txtState.inputView = dataFilterPicker
        txtCity.inputView = dataFilterPicker
        
        self.dataFilterPicker.dataSource = self
        self.dataFilterPicker.delegate = self
        
        self.dataFilterPicker.isHidden = true
        self.vwOptions.isHidden = true
        
        
               
       login_token = "\(logIndict["login_token"]!)"
       user_id = "\(logIndict["user_id"]!)"
       
       txtFirstName.text = "\(logIndict["fname"]!)"
       txtLastName.text = "\(logIndict["lname"]!)"
       
       if ("\(logIndict["email"]!)" == "" || "\(logIndict["email"]!)" == "<null>"){
           self.isEmailCorrect = false
           txtEmail.text = ""
       }else{
           txtEmail.text = "\(logIndict["email"]!)"
           self.isEmailCorrect = true
       }
       
       if ("\(logIndict["phone"]!)" == "" || "\(logIndict["phone"]!)" == "<null>"){
           txtMobile.text = ""
       }else{
           txtMobile.text = "\(logIndict["phone"]!)"
       }
       
       txtUsername.text = "\(logIndict["username"]!)"
       txtCity.text = "\(logIndict["city"]!)"
       txtCountry.text = "\(logIndict["country"]!)"
       txtState.text = "\(logIndict["state"]!)"
       txtZipcode.text = "\(logIndict["zip_code"]!)"
       txtAddress.text = "\(logIndict["address"]!)"
       
       if (logIndict["profile_image"] is NSNull || logIndict["profile_image"] == nil){
           //            cell.imageVWCell.image = placeholderImage
       }else{
           let imageUrl = logIndict["profile_image"] as! String
           let fullUrl = imageUrl
           self.fileUrl = NSURL(string: fullUrl)!
           
           self.userImage.image = UIImage(named: "placeholder.png")
           
           SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
               (receivedSize :Int, ExpectedSize :Int) in
               
           }, completed: {
               (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
               self.userImage.image = image
           })
       }
       
       self.gender = "\(logIndict .value(forKey: "sex")!)"
       
       if  self.gender == "Male"{
           self.malebutton.isSelected = false
           self.femalebutton.isSelected = false
           self.malecount = self.malecount + 1
           if( malebutton.isSelected != true)
           {
               if(femalebutton.isSelected == true && femalecount != 0)
               {
                   femalebutton.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
                   femalebutton.isSelected = true
                   malebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
                   malebutton.isSelected = false
                   gender = "Female"
               }else{
                   malebutton.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
                   malebutton.isSelected = true
                   femalebutton.isSelected = false
                   femalebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
                   gender = "Male"
               }
           }
               
           else
           {    malebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
               malebutton.isSelected = false
           }
       }else{
           self.malebutton.isSelected = false
           self.femalebutton.isSelected = false
           self.malebutton.isSelected = false
           self.femalebutton.isSelected = false
           self.femalecount =  self.femalecount + 1
           if( femalebutton.isSelected != true)
           {
               if(malebutton.isSelected == true && malecount != 0)
               {
                   malebutton.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
                   malebutton.isSelected = true
                   femalebutton.isSelected = false
                   femalebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
                   gender = "Male"
               }else{
                   malebutton.isSelected = false
                   femalebutton.isSelected = true
                   femalebutton.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
                   gender = "Female"
                   malebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
               }
           }
               
           else
           {    femalebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
               femalebutton.isSelected = false
           }
       }
        self.fetchCountries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
       let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
       logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
       print("UserDict: == \(logIndict)")
    }
    
    @IBAction func FormatField(_ sender: UITextField) {
        if let text = sender.text {
            if sender == txtMobile {
                sender.text = phoneFormatter.format(text)
            } else {
                //multiple phone numbers being validated at once require an additional unique hash parameter so we can keep them straight
                sender.text = phoneFormatter.format(text, hash: sender.hash)
            }
        }
    }
    
    //MARK:- Done Button Action
    
    @IBAction func btnDoneDidTap(_ sender: Any)
    {
        let row = self.dataFilterPicker.selectedRow(inComponent: 0);
        NSLog("value L %d", row)
        if tagText == 0 {
            self.txtCity.text = self.cityData[row] as? String
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
        }else if tagText == 1 {
            self.txtState.text = self.stateData[row] as? String
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
            self.tempCity = []
            self.txtCity.text = ""
            self.fetchCities(forStateName: ((self.stateData[row] as? String)!))
        }else if tagText == 2 {
            self.txtCountry.text = self.country[row] as? String
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
            self.tempState = []
            self.txtState.text = ""
            self.txtCity.text = ""
            self.fetchStates(forCountryName: ((self.country[row] as? String)!))
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
        }
    }
    
    //MARK:- Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField == self.txtUsername) {
            self.apiCallAvailability()
        }
        if (textField == self.txtEmail) {
            self.apiCallEmailAvailability()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == self.txtCity){
            self.view.endEditing(true)
            self.dataFilterPicker.isHidden = false
            self.vwOptions.isHidden = false
            tagText = 0
            self.dataFilterPicker.reloadAllComponents()
        }else if(textField == self.txtState){
            self.view.endEditing(true)
            self.dataFilterPicker.isHidden = false
            self.vwOptions.isHidden = false
            tagText = 1
            self.dataFilterPicker.reloadAllComponents()
        }else if(textField == self.txtCountry){
            self.view.endEditing(true)
            self.dataFilterPicker.isHidden = false
            self.vwOptions.isHidden = false
            tagText = 2
            self.dataFilterPicker.reloadAllComponents()
        }
        else{
            self.dataFilterPicker.isHidden = true
            self.vwOptions.isHidden = true
            
        }
    }
    
    //MARK:- Fetch Country List
    func fetchCountries(){
    //func fetchCountries(forContinentName continentName: String){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "get_countries"
        
        //let newTodo: [String: Any] = ["continent":continentName]
        
        //print("Parameter:== \(newTodo)")
        
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
                self.countryList = (json["countries"] as! NSArray).mutableCopy() as! NSMutableArray
                for conversationID in self.countryList {
                    let snapshotValue = conversationID as? NSDictionary
                    if let value = snapshotValue!["name"] as? String {
                        self.tempCountry.add(value)
                    }
                }
                self.country = self.tempCountry
                self.dataFilterPicker.reloadAllComponents()
        }
        SVProgressHUD.dismiss()
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
                self.dataFilterPicker.reloadAllComponents()
        }
        SVProgressHUD.dismiss()
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
                self.dataFilterPicker.reloadAllComponents()
        }
        SVProgressHUD.dismiss()
    }
    
    //MARK:- Email Availability Api Call
    
    func apiCallEmailAvailability(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "check_email_if_exist"
        
        let newTodo: [String: Any] = ["email":txtEmail.text!]
        
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
                
                if ((json["status"]  as! Int) == 1){
                    self.txtEmail.rightViewMode = UITextField.ViewMode.always
                    self.txtEmail.rightView = UIImageView(image: UIImage(named: "check-circular"))
                    self.isEmailCorrect = true
                    SVProgressHUD.dismiss()
                }else{
                    self.txtEmail.rightViewMode = UITextField.ViewMode.always
                    self.txtEmail.rightView = UIImageView(image: UIImage(named: "delete"))
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
        
        let newTodo: [String: Any] = ["username":txtUsername.text!,"user_id": user_id]
        
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
                //print(json)
                print("JSON: \(json)")
                
                if ((json["status"]  as! Int) == 1){
                    //                    let alertController = UIAlertController(title: "Success", message: json["message"] as? String, preferredStyle: UIAlertControllerStyle.alert) //Replace
                    //
                    //                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    //                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    //                        (result : UIAlertAction) -> Void in
                    //
                    //                    }
                    //                    alertController.addAction(okAction)
                    //                    self.present(alertController, animated: true, completion: nil)
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
    
    
    //MARK:- Button actions
    
    @IBAction func btnMaleButtonDidTap(_ sender: Any) {
        malecount = malecount + 1
        if(malebutton.isSelected != true)
        {
            malebutton.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
            malebutton.isSelected = true
            gender = "Male"
            
            if(femalebutton.isSelected == true && femalecount != 0)
            {
                femalebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
                femalebutton.isSelected = false
            }
        }
            
        else
        {
            malebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            malebutton.isSelected = false
        }
    }
    
    @IBAction func btnFemaleDidTap(_ sender: Any) {
        femalecount = femalecount + 1
        if(femalebutton.isSelected != true)
        {
            femalebutton.isSelected = true
            femalebutton.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
            gender = "Female"
            
            if(malebutton.isSelected == true && malecount != 0)
            {
                malebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
                malebutton.isSelected = false
            }
        }
        else
        {
            femalebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            femalebutton.isSelected = false
        }
    }
    
    @IBAction func btnUploadImageDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.customActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- OPEN CAMERA METHODS
    func customActionSheet() {
        let myActionSheet = UIAlertController()
        let galleryAction = UIAlertAction(title: "OPEN GALLERY", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cmaeraAction = UIAlertAction(title: "TAKE PHOTO", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
//        let removeAction = UIAlertAction(title: "REMOVE PHOTO", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.removePhoto()
//        })
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cmaeraAction)
        //myActionSheet.addAction(removeAction)
        myActionSheet.addAction(cancelAction)
        
        if let popoverController = myActionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        self.fromCamera = true
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            self.ImagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.ImagePicker.delegate = self
            self.ImagePicker.allowsEditing = true
            self.present(self.ImagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Camera is not supported", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        ImagePicker.delegate = self
        ImagePicker.allowsEditing = true
        ImagePicker.sourceType = .photoLibrary
        present(ImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        
        
        guard let possibleImage = info[.originalImage] as? UIImage
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                //return
        }
        
        // Set photoImageView to display the selected image.
        self.userImage.image = possibleImage
        self.imageData = possibleImage
        
        self.userImage.contentMode = .scaleAspectFill
         self.userImage.clipsToBounds = true
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        self.apiCallUploadPhoto()
    }
    
    /*
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
       
        
        
        if self.fromCamera == true{
             let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                imageData = pickedImage
                cameraData = imageData!.pngData() as NSData?
                self.userImage.image = imageData
                //UIImageWriteToSavedPhotosAlbum( self.userImage.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            //self.userImage.image = resizeImage(self.userImage.image!, newWidth: 200)
        }else{
             let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                imageData = pickedImage
                cameraData = imageData!.pngData() as NSData?
                self.userImage.image = imageData
            }
            //self.userImage.image = resizeImage(self.userImage.image!, newWidth: 200)
        }
        self.userImage.contentMode = .scaleAspectFill
        self.userImage.clipsToBounds = true
        picker.dismiss(animated: true, completion: nil)
        
    }
 */
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            // we got back an error!
            //            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            //            ac.addAction(UIAlertAction(title: "OK", style: .default))
            //            present(ac, animated: true)
        } else {
            self.apiCallUploadPhoto()
            //            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            //            ac.addAction(UIAlertAction(title: "OK", style: .default))
            //            present(ac, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //MARK: - API Call
    func apiCallUploadPhoto(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "Uploading photo...")

        let parameters: Parameters = [
            "login_token" : "\(login_token)"
        ]
                
        let myUrl = URL(string: BASE_URL + "upload_user_image");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
                for (key,value) in parameters {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                }
            DispatchQueue.main.sync {
                if self.userImage.image != nil{
                    multipartFormData.append( self.userImage.image!.jpegData(compressionQuality: 0.50)!, withName: "profile_image", fileName: "profile_image.jpeg", mimeType: "image/jpeg")
                }
            }
        }, to: myUrl!, method: .post,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    guard let json = response.result.value as? [String: Any] else {
                        print(response)
                        print(response.data as Any)
                        print("didn't get todo object as JSON from API")
                        //print("Error: \(response.result.error as! NSString)")
                        SVProgressHUD.dismiss()
                        return
                    }
                    
                    print("JSON: \(json)")
                    if (((json["status"] as! NSNumber).intValue) == 1){
                        let alert = UIAlertController(title: "Your Local Beer", message: "Your image has been uploaded successfully.", preferredStyle: UIAlertController.Style.alert)
                        let currentAction = UIAlertAction(title: "Dismiss", style: .default, handler: {
                            (alert: UIAlertAction!) -> Void in
                             self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(currentAction)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Your Local Beer", message: "Failed to update your profile.", preferredStyle: UIAlertController.Style.alert)
                        let currentAction = UIAlertAction(title: "Dismiss", style: .default, handler: {
                            (alert: UIAlertAction!) -> Void in
                           
                        })
                        alert.addAction(currentAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.viewDidLoad()
                    SVProgressHUD.dismiss()
                }
            case .failure(let encodingError):
                print("error:\(encodingError)")
                SVProgressHUD.dismiss()
            }
        })
    }
    
    //MARK:- Save Button Action
    
    @IBAction func btnSaveDidTap(_ sender: Any) {
        if txtFirstName.text! == "" || txtLastName.text! == "" || txtEmail.text! == "" || txtUsername.text! == "" || txtAddress.text! == "Enter the address" || self.txtCity.text! == "" || (self.txtCity.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || self.txtCity.text!.count == 0 || self.txtState.text! == "" || self.txtState.text!.count == 0 || (self.txtState.text?.trimmingCharacters(in: .whitespaces).isEmpty)! || txtCountry.text! == "" || txtState.text! == "Select State" || txtCountry.text! == "Select Country" || txtCity.text! == "Select City" || txtZipcode.text! == ""{

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
            if (txtEmail.text!.count == 0 || txtEmail.text!.isEmpty || (self.txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                txtEmail.attributedPlaceholder = NSAttributedString(string: "Please enter email address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                txtEmail.layer.borderColor = UIColor.red.cgColor
                txtEmail.layer.borderWidth = 1.0
            }
            else{
                txtEmail.layer.borderColor = UIColor.black.cgColor
            }
            if (txtState.text!.count == 0 || txtState.text!.isEmpty || txtState.text! == "Select State" || (self.txtState.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                txtState.attributedPlaceholder = NSAttributedString(string: "Please select state", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                txtState.layer.borderColor = UIColor.red.cgColor
                txtState.layer.borderWidth = 1.0
            }
            else{
                txtState.layer.borderColor = UIColor.clear.cgColor
                 txtState.layer.borderWidth = 0.0
            }
            if (txtCity.text!.count == 0 || txtCity.text!.isEmpty || txtCity.text! == "Select City" || (self.txtCity.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                txtCity.attributedPlaceholder = NSAttributedString(string: "Please select city", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                txtCity.layer.borderColor = UIColor.red.cgColor
                txtCity.layer.borderWidth = 1.0
            }
            else{
                txtCity.layer.borderColor = UIColor.clear.cgColor
                txtCity.layer.borderWidth = 0.0
            }
            if (txtCountry.text!.count == 0 || txtCountry.text!.isEmpty  || txtCountry.text! == "Select Country" || (self.txtCountry.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                txtCountry.attributedPlaceholder = NSAttributedString(string: "Please select country", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                txtCountry.layer.borderColor = UIColor.red.cgColor
                txtCountry.layer.borderWidth = 1.0
            }
            else{
                txtCountry.layer.borderColor = UIColor.clear.cgColor
                txtCountry.layer.borderWidth = 0.0
            }
            if (txtZipcode.text!.count == 0 || txtZipcode.text!.isEmpty || (self.txtZipcode.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                txtZipcode.attributedPlaceholder = NSAttributedString(string: "Please enter zipcode", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                txtZipcode.layer.borderColor = UIColor.red.cgColor
                txtZipcode.layer.borderWidth = 1.0
            }else{
                txtZipcode.layer.borderColor = UIColor.black.cgColor
            }
            
            let alert = UIAlertController(title: "Alert", message: "Every field is mandatory", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if !(isValidEmail(testStr: txtEmail.text!)){
            txtEmail.text = ""
            txtEmail.attributedPlaceholder = NSAttributedString(string: "Please enter a valid email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtEmail.layer.borderColor = UIColor.red.cgColor
            txtEmail.layer.borderWidth = 1.0
            //txtEmailAddress.becomeFirstResponder()
        }
        else{
            if self.isUsernameCorrect == true && self.isEmailCorrect == true{
                print(txtState.text!)
                self.apiCallUpdateProfile()
            }else{
                
            }
        }
    }
    
    //MARK:- Email Validation Checking
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    //MARK:- Update Profile Api Call
    
    func apiCallUpdateProfile()
    {
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "update_profile"
        
        let newTodo: [String: Any] = ["fname": txtFirstName.text!,"lname": txtLastName.text!,"username": txtUsername.text!,"address": txtAddress.text!,"city": txtCity.text!,"state": txtState.text!,"country": txtCountry.text!,"zip_code": txtZipcode.text!,"login_token": login_token,"sex": gender]
        
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
                let alert = UIAlertController(title: "Your Local Beer", message: "Your profile has been updated successfully.", preferredStyle: UIAlertController.Style.alert)
                let currentAction = UIAlertAction(title: "Dismiss", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in })
                alert.addAction(currentAction)
                self.present(alert, animated: true, completion: nil)
                
                
                SVProgressHUD.dismiss()
        }
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
        } else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        for view in pickerView.subviews {
            if view.frame.size.height < 1 {
                var frame = view.frame
                frame.size.height = 2
                view.frame = frame
                view.backgroundColor = UIColor.white
            }
        }

        let label = UILabel()
        if tagText == 0{
            label.text = self.cityData[row] as? String //remember to change it to the real data
        }else if tagText == 1{
            label.text = self.stateData[row] as? String //remember to change it to the real data
        }else{
            label.text = self.country[row] as? String //remember to change it to the real data
        }
        
        label.font = UIFont(name: "Helvetica Neue", size: 25.0)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        return label
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
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
