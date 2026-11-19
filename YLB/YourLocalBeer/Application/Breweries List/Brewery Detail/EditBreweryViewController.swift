//
//  EditBreweryViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import SafariServices

class EditBreweryViewController: UIViewController, WKUIDelegate, WKNavigationDelegate,SFSafariViewControllerDelegate {

    //MARK:- Variable Declaration
    var fromBeer = Bool()
    var fromAddBeer = Bool()
    var fromBottle = Bool()
    var fromAddBottleshop = Bool()
    var fromAddBar = Bool()
    var fromBar = Bool()
    var breweryId = String()
    var fromBrewery = Bool()
    var logIndict = NSDictionary()
    var login_token = String()
    
    var bottleId = String()
    var barId = String()
    var beerID = String()
    var breweryID = String()
    
    var editWebView: WKWebView!
    
    //MARK:- View Lifecycle
    
    override func loadView() {
       editWebView = WKWebView()
       editWebView.navigationDelegate = self
       view = editWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
              overrideUserInterfaceStyle = .light
        } else {
              // Fallback on earlier versions
        }
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logIndict)")
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        // Do any additional setup after loading the view.
    }

    //MARK:- Safari View Controller
    func showTutorial(_ which: String) {
        if let url = URL(string: which) {
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
            } else {
                // Fallback on earlier versions
            }
            
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                let vc = SFSafariViewController(url: url, configuration: config)
                present(vc, animated: true)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logIndict)")
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        
        if fromBeer == true{
            let myURL = URL(string: WEB_URL+"app-login?token=\(login_token)&path=\(WEB_URL)user/edit-beer/\(beerID)")!
            print(myURL)
            let myRequest = URLRequest(url: myURL)
            print(myRequest)
            editWebView.load(myRequest)
        }else if fromAddBeer == true{
            let myURL = URL(string: WEB_URL+"app-login?token=\(login_token)&path=\(WEB_URL)user/add-beer/\(breweryID)")
            print(myURL!)
            let myRequest = URLRequest(url: myURL!)
            editWebView.load(myRequest)
        }else if fromBottle == true{
            let myURL = URL(string: WEB_URL+"app-login?token=\(login_token)&path=\(WEB_URL)user/edit-bar/\(bottleId)")!
            print(myURL)
            let myRequest = URLRequest(url: myURL)
            print(myRequest)
            editWebView.load(myRequest)
        }else if fromAddBottleshop == true{
            //editWebView.loadRequest(URLRequest(url: URL(string: "https://www.google.com")!))
        }else if fromAddBar == true{
            //editWebView.loadRequest(URLRequest(url: URL(string: "https://www.google.com")!))
        }else if fromBrewery == true{
            let myURL = URL(string: WEB_URL+"app-login?token=\(login_token)&path=\(WEB_URL)user/edit-brewery/\(breweryId)")!
            print(myURL)
            let myRequest = URLRequest(url: myURL)
            print(myRequest)
            editWebView.load(myRequest)
        }
        else{
            let myURL = URL(string: WEB_URL+"app-login?token=\(login_token)&path=\(WEB_URL)user/edit-bar/\(barId)")!
            print(myURL)
            let myRequest = URLRequest(url: myURL)
            print(myRequest)
            editWebView.load(myRequest)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- WKNavigationDelegate
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
        SVProgressHUD.show(withStatus: "Loading")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        SVProgressHUD.dismiss()
    }
    
    //MARK:- UIWebViewDelegate
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let contentSize = webView.scrollView.contentSize
        let webViewSize = webView.bounds.size
        let scaleFactor = webViewSize.width / contentSize.width
        
        webView.scrollView.minimumZoomScale = scaleFactor
        webView.scrollView.maximumZoomScale = scaleFactor
        webView.scrollView.zoomScale = scaleFactor
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

extension WKWebView {
    func loadPage(address url: URL) { load(URLRequest(url: url)) }
    func loadPage(address urlString: String) {
        guard let url = URL(string: urlString) else { return }
        loadPage(address: url)
    }
}
