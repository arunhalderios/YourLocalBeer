//
//  OTPViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 17/11/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class OTPViewController: UIViewController {

    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    
    @IBOutlet weak var btnVerifyOutlet: UIButton!
    var registered_token = String()
    var stringValue = String()
    var fromForgetPassword = Bool()
    var userID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        tf1.layer.cornerRadius = 5
        tf1.layer.masksToBounds = true
        tf2.layer.cornerRadius = 5
        tf2.layer.masksToBounds = true
        tf3.layer.cornerRadius = 5
        tf3.layer.masksToBounds = true
        tf4.layer.cornerRadius = 5
        tf4.layer.masksToBounds = true
        
        btnVerifyOutlet.layer.shadowColor = UIColor.darkGray.cgColor
        btnVerifyOutlet.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        btnVerifyOutlet.layer.shadowOpacity = 1.0
        btnVerifyOutlet.layer.shadowRadius = 1.0
        btnVerifyOutlet.layer.cornerRadius = 20
        btnVerifyOutlet.layer.masksToBounds = false
        
        tf1.addTarget(self, action: #selector(self.textFieldDidChange(textfield:)), for: UIControl.Event.editingChanged)
        tf2.addTarget(self, action: #selector(self.textFieldDidChange(textfield:)), for: UIControl.Event.editingChanged)
        tf3.addTarget(self, action: #selector(self.textFieldDidChange(textfield:)), for: UIControl.Event.editingChanged)
        tf4.addTarget(self, action: #selector(self.textFieldDidChange(textfield:)), for: UIControl.Event.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tf1.becomeFirstResponder()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func textFieldDidChange(textfield: UITextField) {
        let text = textfield.text
        
        if text?.utf16.count == 1{
            switch textfield{
            case tf1:
                tf2.becomeFirstResponder()
            case tf2:
                tf3.becomeFirstResponder()
            case tf3:
                tf4.becomeFirstResponder()
            case tf4:
                tf4.resignFirstResponder()
                stringValue = self.tf1.text! + self.tf2.text! + self.tf3.text! + self.tf4.text! // "\(x)\(l)"
                if fromForgetPassword == true{
                    self.apiCallPasswordOtpValidation()
                }else{
                    self.apiCallOtpValidation()
                }
            default:
                break
            }
        }
        else{
            
        }
    }
    
    //MARK: - API Call
    func apiCallOtpValidation(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "check_registration_otp"
        
        let newTodo: [String: Any] = ["otp_code": stringValue, "otp_token": registered_token]
                
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                
                if ((json["status"]  as! Int) == 1){
                    let alertController = UIAlertController(title: "Success", message: json["message"] as? String, preferredStyle: UIAlertController.Style.alert) //Replace
                    
                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let HomeViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
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
    
    //MARK: - Password API Call
    func apiCallPasswordOtpValidation(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "forgot_password_check_otp"
        
        let newTodo: [String: Any] = ["otp_code": stringValue, "otp_token": registered_token]
                
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    SVProgressHUD.dismiss()
                    return
                }
                
                if ((json["status"]  as! Int) == 1){
                    self.userID = String(json["user_id"] as! Int)
                    UserDefaults.standard.set(self.userID, forKey: "userID")
                    
                    let alertController = UIAlertController(title: "Success", message: json["message"] as? String, preferredStyle: UIAlertController.Style.alert) //Replace
                    
                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Application", bundle:nil)
                        let HomeViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePassword") as! ChangePasswordViewController
                        HomeViewController.fromOtp = true
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
                
    //MARK:- Back button action
    
    @IBAction func btnBackDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
