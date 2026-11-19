//
//  LinkUntappdVC.swift
//  YourLocalBeer
//
//  Created by Arun Halder on 10/09/20.
//  Copyright © 2020 Abhishek Mullick. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class LinkUntappdVC: UIViewController, WKScriptMessageHandler {
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
        let todosEndpoint: String = WEB_URL + "untappd-ios-connect-url" //"https://www.beta.yourlocalbeer.com/untappd-ios-connect-url"
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
           
           
           let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
           logIndict1 = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
           login_token = "\(logIndict1 .value(forKey: "login_token")!)"
           print(login_token)
           if login_token.isEmpty{
           }
           else{
               self.linkYourAccount()
           }

       }
   }
    
    func linkYourAccount() {
    SVProgressHUD.show(withStatus: "It's working...")
    let todosEndpoint: String = BASE_URL + "untappd-connect"
    let Url = String(format: todosEndpoint)
    guard let serviceUrl = URL(string: Url) else { return }
    let parameterDictionary = ["login_token": login_token,"access_token":TokenService.instance.untappdAccessToken]
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

        
        let status = json["status"] as? Bool
        
        if status == false{
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.loadPage()
            }
            
            }
            else{
            
                DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "UntappdListVC") as! UntappdListVC

                self.navigationController?.pushViewController(VC, animated: true)

                }
            }

    }

    } catch {
    print(error)
    }
    }
    }.resume()
    
    }

}
