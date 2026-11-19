//
//  ChangePasswordViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 15/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ChangePasswordViewController: UIViewController,UITextFieldDelegate {

    //MARK:- Variable Declaration
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtRePass: UITextField!
    @IBOutlet weak var btnSubmitOutlet: UIButton!
    var fromOtp = Bool()
    var userData = String()
    var window: UIWindow?
    @IBOutlet weak var btnNewPassOutlet: UIButton!
    @IBOutlet weak var btnRetypePassOutlet: UIButton!
    var iconClick = true
    var iconClick1 = true
    
    
    
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        let userData2 = UserDefaults.standard.integer(forKey: "userID")
        userData = String(userData2)
        print("UserDict: == \(userData)")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Submit button action
    @IBAction func btnSubmitDidTap(_ sender: Any) {
       if (txtNewPass.text!.count == 0 || (self.txtNewPass.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
        let alert = UIAlertController(title: "Alert", message: "Please enter the new password", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
       }else if (txtRePass.text!.count == 0 || (self.txtRePass.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
        let alert = UIAlertController(title: "Alert", message: "Please re-enter the password", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
       }else if txtNewPass.text! != txtRePass.text!{
        let alert = UIAlertController(title: "Alert", message: "Password mismatch", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
       }else{
            if fromOtp == true{
                self.apiCallUpdatePassword()
            }
        }
    }
    
    //MARK:- Update Password Api call
    
    func apiCallUpdatePassword(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "forgot_password_change_new"
        
        let newTodo: [String: Any] = ["user_id": userData, "password": txtNewPass.text!]
        
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
                    
                    let alertController = UIAlertController(title: "Success", message: json["message"] as? String, preferredStyle: UIAlertController.Style.alert) //Replace
                    
                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        (result : UIAlertAction) -> Void in
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let LoginViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                        let navController = UINavigationController(rootViewController: LoginViewController)
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = navController
                        self.window?.makeKeyAndVisible()
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
    
    //MARK:- New Password visibility Action
    @IBAction func btnNewPassDidTap(_ sender: Any) {
        if(iconClick == true) {
            txtNewPass.isSecureTextEntry = false
            btnNewPassOutlet.setImage(UIImage(named: "visibility-off.png"), for: .normal)
        } else {
            txtNewPass.isSecureTextEntry = true
            btnNewPassOutlet.setImage(UIImage(named: "visibility.png"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    //MARK:- Retype Password visibility Action
    @IBAction func btnRetypePassDidTap(_ sender: Any) {
        if(iconClick1 == true) {
            txtRePass.isSecureTextEntry = false
            btnRetypePassOutlet.setImage(UIImage(named: "visibility-off.png"), for: .normal)
        } else {
            txtRePass.isSecureTextEntry = true
            btnRetypePassOutlet.setImage(UIImage(named: "visibility.png"), for: .normal)
        }
        iconClick1 = !iconClick1
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
