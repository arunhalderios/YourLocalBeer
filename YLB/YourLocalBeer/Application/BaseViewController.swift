//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class BaseViewController: UIViewController, SlideMenuDelegate, UINavigationControllerDelegate {
    var logIndict1 = NSDictionary()
    var loginType1 = String()
    var fileUrl1 = NSURL()
    var deviceID1 = String()
    var accessToken1 = String()
    var accessTokenData1 = String()
    var window: UIWindow?
    var currentViewController = String()
    var topViewController = UIViewController()
    var login_Token = String()
    
    
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict1 = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = true
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict1 = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        login_Token = "\(logIndict1 .value(forKey: "login_token")!)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        topViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            if currentViewController == "Home"{
                print("Home\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Home")
            }else{
                print("Dashboard\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Dashboard")
            }
            break
        case 1:
            if currentViewController == "Home"{
                print("Home\n", terminator: "")
                
                self.openViewControllerBasedOnIdentifier("Home")
            }else{
                print("Setting\n", terminator: "")
                self.openViewControllerBasedOnIdentifier("Setting")
            }
            break
//        case 2:
//            print("Setting\n", terminator: "")
//
//            //self.openViewControllerBasedOnIdentifier("Setting")
//
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let BeforeLoginView = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            let navi =  UINavigationController.init(rootViewController: BeforeLoginView)
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            self.window?.rootViewController = navi
//            self.window?.makeKeyAndVisible()
//
//            break
        case 2:
            print("Logout\n", terminator: "")
            
            let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
            logIndict1 = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
            print("UserDict: == \(logIndict1)")
            login_Token = "\(logIndict1 .value(forKey: "login_token")!)"
            print(login_Token)
            
            self.apiCallLogout()
            
            break
        default:
            print("default\n", terminator: "")
            break
        }
    }
    
    //MARK: - API Call
    func apiCallLogout(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = "http://18.217.242.170/api/logout"
        
        let newTodo: [String: Any] = ["login_token": login_Token]
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
                UserDefaults.standard.removeObject(forKey: "key_profile_info")
                UserDefaults.standard.set(false, forKey: "login")
                UserDefaults.standard.removeObject(forKey: "registerToken")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let BeforeLoginView = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navi =  UINavigationController.init(rootViewController: BeforeLoginView)
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = navi
                self.window?.makeKeyAndVisible()
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        if currentViewController == "Dashboard"{
            if strIdentifier == "Home"{
                for controller in self.navigationController!.viewControllers as Array
                {
                    if controller.isKind(of: HomeViewController.self)
                    {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break

                    }
                }
            }else{
                let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
                self.navigationController!.pushViewController(destViewController, animated: true)
            }
        }else if currentViewController == "Setting"{
            if strIdentifier == "Home"{
                for controller in self.navigationController!.viewControllers as Array
                {
                    if controller.isKind(of: HomeViewController.self)
                    {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break

                    }
                }
            }else{
                let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
                self.navigationController!.pushViewController(destViewController, animated: true)
            }
            //self.navigationController?.popToRootViewController(animated: true)
        } else{
            let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
       
        //let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        //let topViewController : UIViewController = self.navigationController!.topViewController!

//        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
//            print("Same VC")
//        } else {
//            self.navigationController!.pushViewController(destViewController, animated: true)
//        }
    }
    
    func addSlideMenuButton(_ viewController: String){
        currentViewController = viewController
        print(currentViewController)
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
        btnShowMenu.frame = CGRect(x: 290, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 25, height: 30), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 25, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 25, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            print(view.subviews.last!)
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width //-1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuOptionViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuOptionViewController") as! MenuOptionViewController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        print(currentViewController)
        menuVC.currentController = currentViewController
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
    }
    
    //MARK: - API Call
//    func apiCallLogout1(){
//        SVProgressHUD.show(withStatus: "It's working...")
//
//        let headers = [
//            "x-access-token": "\(accessToken1)"]
//        print(accessToken1)
//        if let outData = UserDefaults.standard.data(forKey: "device_id"){
//            deviceID1 = (NSKeyedUnarchiver.unarchiveObject(with: outData) as! NSString) as String
//        }else{
//            deviceID1 = ""
//        }
//
//        let myUrl = URL(string: LOGOUT_API);
//        var request = URLRequest(url:myUrl!)
//        request.httpMethod = "POST"
//        let postString = "deviceId=\(deviceID1)&accessToken=\(accessToken1)";
//        print("postString==>\(postString)")
//        request.httpBody = postString.data(using: String.Encoding.utf8);
//        request.allHTTPHeaderFields = headers
//
//        Alamofire.request(request)
//            .responseJSON { response in
//                guard let json = response.result.value as? [String: Any] else {
//                    print("didn't get todo object as JSON from API")
//                    //print("Error: \(response.result.error as! NSString)")
//                    SVProgressHUD.dismiss()
//                    return
//                }
//                print("JSON: \(json)")
//
//                if ((json["status"] as! String) .isEqual("success")){
//                    UserDefaults.standard.removeObject(forKey: "key_profile_info")
//                    UserDefaults.standard.set(false, forKey: "login")
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let BeforeLoginView = storyBoard.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
//                    let navi =  UINavigationController.init(rootViewController: BeforeLoginView)
//                    self.window = UIWindow(frame: UIScreen.main.bounds)
//                    self.window?.rootViewController = navi
//                    self.window?.makeKeyAndVisible()
//                } else{
//                    let  array: NSArray = ((json["errors"]! as! NSArray).mutableCopy() as? NSArray)!
//                    print(array)
//                    let dict: NSDictionary = (array[0] as? NSDictionary)!
//                    print(dict)
//                    let message = dict["msg"] as? String
//                    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert) //Replace
//
//                    // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
//                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                        (result : UIAlertAction) -> Void in
//                        print("OK")
//                    }
//                    alertController.addAction(okAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    SVProgressHUD.dismiss()
//                }
//                SVProgressHUD.dismiss()
//        }
//    }
}
