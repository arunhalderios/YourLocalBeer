//
//  ViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 17/05/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import Google
import GoogleSignIn
import Alamofire
import SVProgressHUD

class ViewController: UIViewController,UITextFieldDelegate,GIDSignInDelegate {
    
    // Facebook login permissions
    // Add extra permissions you need
    // Remove permissions you don't need
    //private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]
    
    @IBOutlet weak var btnLoginOutlet: UIButton!
    @IBOutlet weak var btnAccountCreateOutlet: UIButton!
    @IBOutlet weak var btnFacebookOutlet: UIButton!
    @IBOutlet weak var btnGoogleOutlet: UIButton!
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
    var deviceID = String()
    
    @IBOutlet weak var vwFacebook: UIView!
    @IBOutlet weak var vwGoogle: UIView!
    @IBOutlet weak var vwFacebookImage: UIImageView!
    @IBOutlet weak var vwGoogleImage: UIImageView!
    
    var countryData = String()
    var usercityData = String()
    var userstateData = String()
    var locationManager = CLLocationManager()
    var geoCoder = CLGeocoder()
    //var placeMark = CLPlacemark()
    var addressString : String = ""
    var Latitude = Double()
    var Longitude = Double()
    var country = String()
    var city = String()
    var state = String()
    var isLocationEnabled = Bool()
    var fromDenyLocation = Bool()
    var totalUserDict = [String: AnyObject]()
    
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        GIDSignIn.sharedInstance().delegate = self
        
        btnLoginOutlet.layer.cornerRadius = 5.0
        btnLoginOutlet.clipsToBounds = true
        
        btnAccountCreateOutlet.layer.cornerRadius = 5.0
        btnAccountCreateOutlet.clipsToBounds = true
        
        btnFacebookOutlet.layer.cornerRadius = 5.0
        btnFacebookOutlet.clipsToBounds = true
        
        btnGoogleOutlet.layer.cornerRadius = 5.0
        btnGoogleOutlet.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        btnLoginOutlet.alpha = 0.0
        btnAccountCreateOutlet.alpha = 0.0
        btnFacebookOutlet.alpha = 0.0
        btnGoogleOutlet.alpha = 0.0
        vwFacebookImage.alpha = 0.0
        vwGoogleImage.alpha = 0.0
        deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
        
       // UIApplication.shared.statusBarView?.backgroundColor = .clear

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.btnLoginOutlet.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.btnAccountCreateOutlet.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveEaseOut, animations: {
            self.btnFacebookOutlet.alpha = 1
            self.vwFacebookImage.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.9, options: .curveEaseOut, animations: {
            self.btnGoogleOutlet.alpha = 1
            self.vwGoogleImage.alpha = 1
        }, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Login Button Action
    @IBAction func btnLoginDidTap(_ sender: Any) {
        let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        self.navigationController?.pushViewController(LoginViewController, animated: true)
    }
    
    //MARK:- Register Button Action
    @IBAction func btnRegisterDidTap(_ sender: Any) {
        let RegistrationViewController = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! RegistrationViewController
        RegistrationViewController.fromDenyLocation = fromDenyLocation
        self.navigationController?.pushViewController(RegistrationViewController, animated: true)
    }
    
    //MARK:- Google Button Action
    @IBAction func btnGoogleDidTap(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
//        let signIn = GIDSignIn.sharedInstance()
//        signIn?.shouldFetchBasicProfile = true
//        signIn?.clientID = "90504974966-a4omaqmg2p0ii1jll0c35de7h9k42u18.apps.googleusercontent.com"
//        signIn?.scopes = ["profile", "email"]
//        signIn?.delegate = self
//        signIn?.uiDelegate = self
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
            
            // Perform any operations on signed in user here.
            userId = user.userID                  // For client-side use only!
            idToken = user.authentication.idToken // Safe to send to the server
            name = user.profile.name
            //let givenName = user.profile.givenName
            //let familyName = user.profile.familyName
            googleemail = user.profile.email

            GIDSignIn.sharedInstance().signOut()
            
            // ...
        } else {

        }
    }
    
    //MARK:- Facebook Button Action
    @IBAction func btnFacebookLoginDidTap(_ sender: Any) {
       
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
    
    
    //MARK:- UNTAPPD Button Action
    @IBAction func untappdBtnDidTap(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Application", bundle:nil)
        let VC = storyBoard.instantiateViewController(withIdentifier: "UntappdWebvwVC") as! UntappdWebvwVC
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    //MARK:- Forgot Password Button Action
    @IBAction func btnForgotPasswordDidTap(_ sender: Any) {
        self.showAlert()
    }
    
    //MARK:- Textfield Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Forgot Password", message: "Please enter your registered email id for the reset link.", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(_ textField: UITextField?) -> Void in
            textField?.placeholder = "Email"
            textField?.addTarget(self, action: #selector(LoginViewController.alertTextFieldDidChange(_:)), for: .editingChanged)
        })
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction?) -> Void in
            let login: UITextField? = alertController.textFields?.first
            self.email = (login?.text!)!
            if self.forgotPasswordEmailvalidityChecking() == false {
                return
            }else{

            }
            
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
    
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

