//
//  LoginViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 17/05/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import Google
import Alamofire
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate,GIDSignInDelegate {
    
    //MARK:- Variable Declaration
    var window: UIWindow?
    
    @IBOutlet weak var btnLoginOutlet: UIButton!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    var email = String()
    var loginManager = LoginManager()
    var fbID = String()
    var userFullName = String()
    var profilePicture = String()
    var dob = String()
    var gender = String()
    var fbEmail = String()
    var first_name = String()
    var last_name = String()
    
    var userID = String()
    var userId = String()
    var idToken = String()
    var name = String()
    var googleemail = String()
    var totalUserDict = [String: AnyObject]()
    var deviceID = String()
    var registered_token = String()
    var otp_string = String()
    var fromForgetPassword = Bool()
    var iconClick = true
    @IBOutlet weak var btnPasswordOutlet: UIButton!
    
    
    
    
    //MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        txtEmailAddress.layer.borderColor = UIColor.white.cgColor
        txtEmailAddress.layer.borderWidth = 1.0
        
        txtPassword.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.borderWidth = 1.0
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        btnLoginOutlet.layer.cornerRadius = 5.0
        btnLoginOutlet.clipsToBounds = true
        self.navigationController?.navigationBar.isHidden = true
        deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            userId = (user?.userID)!
            // For client-side use only!
            idToken = (user?.authentication.idToken)!
            // Safe to send to the server
            name = (user?.profile.name)!
            googleemail = (user?.profile.email)!
            GIDSignIn.sharedInstance().signOut()
        } else {

        }
        
    }
    
    //MARK:- Visibility Button Action
    @IBAction func btnShowDidTap(_ sender: Any) {
        if(iconClick == true) {
            txtPassword.isSecureTextEntry = false
            btnPasswordOutlet.setImage(UIImage(named: "vision-off"), for: .normal)
        } else {
            txtPassword.isSecureTextEntry = true
            btnPasswordOutlet.setImage(UIImage(named: "vision"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    
    //MARK:- Forgot Button Action
    @IBAction func btnForgotPasswordDidTap(_ sender: Any) {
        self.showAlert()
    }
    
    //MARK:- Facebook Button Action
    @IBAction func btnFacebookDidTap(_ sender: Any) {
        
       let loginManager = LoginManager()
        loginManager.logIn(permissions: [ .publicProfile,.email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                self.removeFbData()
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    self.getFBUserData()
        }
      }
    }
    
    ///MARK: Facebook Delegate Methods
    func removeFbData() {
        
        //Remove FB Data
        let fbManager = LoginManager()
        fbManager.logOut()
        AccessToken.current = nil
    }
    
    func getFBUserData(){
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields" :"id, name, first_name, last_name, picture, email, gender, about, birthday"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
            } else {
                let dict = result as! [String : AnyObject]
                print(dict)
                self.fbID = (dict["id"] as? String)!
                if ((dict["email"] as? String) != nil)
                {
                    self.fbEmail = (dict["email"] as? String)!
                }
                else{
                    self.fbEmail = ""
                }
                self.first_name = (dict["first_name"] as? String)!
                self.last_name = (dict["last_name"] as? String)!
                
                self.userFullName = (dict["name"] as? String)!
                self.profilePicture = "http://graph.facebook.com/\(self.userID)/picture?type=large"
                
                if ((dict["gender"] as? String) != nil){
                    self.gender = (dict["gender"] as? String)!
                    if self.gender == "male"
                    {
                        self.gender = "Male"
                    }
                    else
                    {
                        self.gender = "Female"
                    }
                }else{
                    self.gender = ""
                }
                
                if ((dict["birthday"] as? String) != nil)
                {
                    let string1 = (dict["birthday"] as? String)!
                    
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat = "mm/dd/yyyy"
                    let showDate = inputFormatter.date(from: string1)
                    inputFormatter.dateFormat = "yyyy-mm-dd"
                    let resultString = inputFormatter.string(from: showDate!)
                    
                    self.dob = resultString
                }else{
                    self.dob = ""
                }
            }
            if self.fbEmail == ""{
                let alertController = UIAlertController(title: "Please provide a valid email address.", message: "", preferredStyle: UIAlertController.Style.alert) //Replace
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: false, completion: nil)
            }else{
                self.fbLogin()
            }
        })
    }
        
    //MARK:- Facebook Login
    func fbLogin(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL+"fb-login"
        
        let newTodo: [String: Any] = ["email": self.fbEmail,"first_name": self.first_name,"last_name": self.last_name,"socialId": self.fbID,"deviceID": self.deviceID]
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
                    
                 UserDefaults.standard.set(true, forKey: "login")
                 self.totalUserDict = (json["userDtls"] as AnyObject) as! [String : AnyObject]

                 //store dic data
                 let data = NSKeyedArchiver.archivedData(withRootObject: self.totalUserDict)
                 UserDefaults.standard.set(data, forKey: "key_profile_info")
                 
                 //show dic data
                 let loginData = UserDefaults.standard.data(forKey: "key_profile_info")
                 let logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData!) as! NSDictionary
                 
                 let storyBoard : UIStoryboard = UIStoryboard(name: "Application", bundle:nil)
                 let HomeViewController = storyBoard.instantiateViewController(withIdentifier: "Category") as! CategoryViewController
                 self.navigationController?.pushViewController(HomeViewController, animated: true)

                 SVProgressHUD.dismiss()
                }else{
                    let alertController = UIAlertController(title: "Error", message: json["msg"] as? String, preferredStyle: UIAlertController.Style.alert) //Replace

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
    
    //MARK:- Google Button Action
    @IBAction func btnGoogleDidTap(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    

    
    
    //MARK:- Login Button Action
    @IBAction func btnLoginDidTap(_ sender: Any) {
        if txtEmailAddress.text! == "" && txtPassword.text! == ""{
            txtEmailAddress.attributedPlaceholder = NSAttributedString(string: "Please enter a valid email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtPassword.attributedPlaceholder = NSAttributedString(string: "Please enter Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            let alert = UIAlertController(title: "Alert", message: "Every field is mandatory", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if (txtEmailAddress.text!.count == 0 || (self.txtEmailAddress.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtEmailAddress.becomeFirstResponder()
            txtEmailAddress.attributedPlaceholder = NSAttributedString(string: "Please enter a valid email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }else{
            
        }
        if (txtPassword.text!.count == 0 || (self.txtPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
            txtPassword.becomeFirstResponder()
            txtPassword.attributedPlaceholder = NSAttributedString(string: "Please enter Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }else if !(isValidEmail(testStr: txtEmailAddress.text!)){
            txtEmailAddress.text = ""
            txtEmailAddress.attributedPlaceholder = NSAttributedString(string: "Please enter a valid email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            txtEmailAddress.becomeFirstResponder()
        }else{
            self.apiCallLogin()
            //            let storyBoard : UIStoryboard = UIStoryboard(name: "Application", bundle:nil)
            //            let HomeViewController = storyBoard.instantiateViewController(withIdentifier: "Category") as! CategoryViewController
            //            self.navigationController?.pushViewController(HomeViewController, animated: true)
        }
    }
    
    //MARK: - API Call
    func apiCallLogin(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL+"login"

        let newTodo: [String: Any] = ["username": txtEmailAddress.text!, "password": txtPassword.text!,"deviceID":deviceID]
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
                
                if ((json["status"]  as! Int) == 1){
                    UserDefaults.standard.set(true, forKey: "login")
                    
                    self.totalUserDict = (json["userDtls"] as AnyObject) as! [String : AnyObject]
                    
                    //store dic data
                    let data = NSKeyedArchiver.archivedData(withRootObject: self.totalUserDict)
                    UserDefaults.standard.set(data, forKey: "key_profile_info")
                    
                    //show dic data
                    let loginData = UserDefaults.standard.data(forKey: "key_profile_info")
                    let logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData!) as! NSDictionary
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Application", bundle:nil)
                    let HomeViewController = storyBoard.instantiateViewController(withIdentifier: "Category") as! CategoryViewController
                    self.navigationController?.pushViewController(HomeViewController, animated: true)
                    SVProgressHUD.dismiss()
                }else{
                    
                    let alertController = UIAlertController(title: "Error", message: "Login with valid credentials", preferredStyle: UIAlertController.Style.alert) //Replace
                    
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
    
    //MARK:- Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Email Validation Checking
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK:- Alert Textfield
    
    func showAlert() {
        let alertController = UIAlertController(title: "Forgot Password", message: "Please enter you registered phone number for the verification code.", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField?) -> Void in
            textField?.placeholder = "Mobile Number"
            textField?.addTarget(self, action: #selector(LoginViewController.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField?.keyboardType = .phonePad
        })
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            let login: UITextField? = alertController.textFields?.first
            self.email = (login?.text!)!
            self.forgetPassword()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction?) -> Void in
        })
        okAction.isEnabled = false
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true) {() -> Void in }
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField?) {
        let alertController = presentedViewController as? UIAlertController
        if alertController != nil {
            let login: UITextField? = alertController?.textFields?.first
            let okAction: UIAlertAction? = alertController?.actions.first
            okAction?.isEnabled = (login?.text?.count ?? 0) > 2
        }
    }
    
    //MARK:- Forgot Password Email Validation Checking
    func forgotPasswordEmailvalidityChecking() -> Bool {
        let validEmail: Bool = nsStringIsValidEmail(email)
        if validEmail == false {
            let alertController = UIAlertController(title: "Please provide a valid email address.", message: "", preferredStyle: UIAlertController.Style.alert) //Replace
            
            // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
                self.showAlert()
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func nsStringIsValidEmail(_ emailString: String?) -> Bool {
        let stricterFilter = false
        let stricterFilterString = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let laxString = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let emailRegex = stricterFilter ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailString)
    }
    
    //MARK:- Forgot Password Api Call
    
    func forgetPassword(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "forgot_password_request_otp"
        
        let newTodo: [String: Any] = ["phone": self.email]
                
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                //In this instance IsAuthenticated = 1 in Api response (1 means true and 0 means false).It is displaying as 1 and 0 but actually it is boolean value
                
                if ((json["status"]  as! Int) == 1){
                    self.fromForgetPassword = true
                    self.registered_token = json["otp_token"] as! String
                    UserDefaults.standard.set(self.registered_token, forKey: "registerToken")
                    
                    self.otp_string = String(json["otp"] as! Int)
                    let constring = (json["message"] as! String) + "\n Otp: \(self.otp_string)"
                    
                    
                    let alertController = UIAlertController(title: "Success", message: constring, preferredStyle: UIAlertController.Style.alert) //Replace
                    
                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let HomeViewController = storyBoard.instantiateViewController(withIdentifier: "OTP") as! OTPViewController
                        HomeViewController.registered_token = self.registered_token
                        HomeViewController.fromForgetPassword = self.fromForgetPassword
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
