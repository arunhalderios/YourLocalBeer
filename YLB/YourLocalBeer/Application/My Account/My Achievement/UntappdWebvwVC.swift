//
//  UntappdWebvwVC.swift
//  YourLocalBeer
//
//  Created by Arun Halder on 24/08/20.
//  Copyright © 2020 Abhishek Mullick. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
class TokenService{
    static let instance = TokenService()
    let defaults = UserDefaults.standard
    var untappdAccessToken:String?{
        get{
            return (defaults.value(forKey: "untappd_access_token") as? String)
        }set{
            defaults.set(newValue, forKey: "untappd_access_token")
        }
    }
}



class UntappdWebvwVC: UIViewController, WKScriptMessageHandler {
    private var wkWebView: WKWebView!
    
    var logIndict1 = NSDictionary()
    var login_token = String()
    var untappdAccessToken = String()
    
    var totalUserDict = [String: AnyObject]()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.setupWKWebview()
        self.loadPage()
    }

    private func setupWKWebview() {
        SVProgressHUD.show(withStatus: "It's working...")
        self.wkWebView = WKWebView(frame: self.view.bounds, configuration: self.getWKWebViewConfiguration())
        self.view.addSubview(self.wkWebView)
    }
    
    private func loadPage() {
        let todosEndpoint: String = WEB_URL + "untappd-ios-oauth-url" //"https://www.beta.yourlocalbeer.com/untappd-ios-oauth-url"
        let Url = String(format: todosEndpoint)
        let link = URL(string: Url)
        let request = URLRequest(url: link!)
        self.wkWebView.load(request)
        SVProgressHUD.dismiss()

    }
    
    private func getWKWebViewConfiguration() -> WKWebViewConfiguration {
        let userController = WKUserContentController()
        userController.add(self, name: "observer")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userController
        return configuration
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
         print(message.body)
        
        if let dic = message.body as? [String:Any]{
            print(dic["access_token"] as! String)
            
            let access_token = dic["access_token"] as! String
            
            TokenService.instance.untappdAccessToken = access_token
            
            if access_token.isEmpty{
            }
            else{
                self.untappdLogin()
            }
        }
    }
    
    
    func untappdLogin() {
    SVProgressHUD.show(withStatus: "It's working...")

    let deveiceID = (UIDevice.current.identifierForVendor?.uuidString)!
    let todosEndpoint: String = BASE_URL + "untappd-login"
    let Url = String(format: todosEndpoint)
    guard let serviceUrl = URL(string: Url) else { return }
    let parameterDictionary = ["deviceID": deveiceID,"access_token":TokenService.instance.untappdAccessToken]
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
    return
    }
    request.httpBody = httpBody

    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in


    if let data = data {
    do {
    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
        print("======================")
        print(json)
        print("======================")
        DispatchQueue.main.async {
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

    } catch {
    print(error)
    SVProgressHUD.dismiss()
    }
    }
    }.resume()
    
    }
}


