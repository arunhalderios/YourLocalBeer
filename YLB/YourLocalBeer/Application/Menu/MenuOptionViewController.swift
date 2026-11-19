//
//  MenuOptionViewController.swift
//  LeakIt
//
//  Created by Techno-MAC on 07/02/18.
//  Copyright © 2018 Techno-MAC. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SVProgressHUD

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuOptionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate {

    
    var arrayMenuOptions = [Dictionary<String,String>]()
    var delegate : SlideMenuDelegate?
    
    @IBOutlet weak var tblMenuOptions: UITableView!
    var logIndict = NSDictionary()
    var loginType = String()
    var fileUrl = NSURL()
    var deviceID = String()
    var accessToken = String()
    var accessTokenData = String()
    var currentController = String()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    //var btnMenu : UIButton!
    var btnMenu = UIButton()
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        print(currentController)
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logIndict)")
//
//       loginType = "\(logIndict .value(forKey: "loginType")!)"
//       print(loginType)
//
//        let userData = UserDefaults.standard.object(forKey: "key_accessToken_info")
//        accessTokenData = NSKeyedUnarchiver.unarchiveObject(with: userData as! Data) as! String
//        print("UserDict: == \(accessTokenData)")
//
//        accessToken = accessTokenData
//
//        print(accessToken)
         // tblMenuOptions.tableFooterView = UIView()
        
//        if loginType == "F"{
//            arrayMenuOptions.append(["title":"Profile", "icon":"User-2"])
//            arrayMenuOptions.append(["title":"Dashboard", "icon":"Dashboard"])
//            arrayMenuOptions.append(["title":"Logout", "icon":"Logout"])
//            
//            tblMenuOptions.reloadData()
//        }else{
//            arrayMenuOptions.append(["title":"Profile", "icon":"User-2"])
//            arrayMenuOptions.append(["title":"Dashboard", "icon":"Dashboard"])
//            arrayMenuOptions.append(["title":"Setting", "icon":"Setting"])
//            arrayMenuOptions.append(["title":"Logout", "icon":"Logout"])
//            
//            tblMenuOptions.reloadData()
//        }
    
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logIndict)")
        
        
        if loginType == "F"{
            if currentController == "MyAccount"{
                arrayMenuOptions = [
                    ["title": "Home", "icon": "Home"],
                    ["title": "Dashboard", "icon": "Dashboard"],
                    ["title": "Setting", "icon": "Setting"],
                    ["title": "Logout", "icon": "logout"]
                ]
            }else if currentController == "Dashboard"{
                arrayMenuOptions = [
                    ["title": "Profile", "icon": "User-2"],
                    ["title": "Home", "icon": "Home"],
                    ["title": "Setting", "icon": "Setting"],
                    ["title": "Logout", "icon": "logout"]
                ]
            }else{
                arrayMenuOptions = [
                    ["title": "Profile", "icon": "User-2"],
                    ["title": "Dashboard", "icon": "Dashboard"],
                    ["title": "Setting", "icon": "Setting"],
                    ["title": "Logout", "icon": "logout"]
                ]
            }
            
            tblMenuOptions.reloadData()
        }else{
             if currentController == "MyAccount"{
                arrayMenuOptions = [
                    ["title": "Home", "icon": "Home"],
                    ["title": "Dashboard", "icon": "Dashboard"],
                    ["title": "Setting", "icon": "Setting"],
                    ["title": "Logout", "icon": "logout"]
                ]
             }else if currentController == "Dashboard"{
                arrayMenuOptions = [
                    ["title": "Profile", "icon": "User-2"],
                    ["title": "Home", "icon": "Home"],
                    ["title": "Setting", "icon": "Setting"],
                    ["title": "Logout", "icon": "logout"]
                ]
             }else{
                arrayMenuOptions = [
                    ["title": "Profile", "icon": "User-2"],
                    ["title": "Setting", "icon": "Setting"],
                    ["title": "Logout", "icon": "logout"]
                ]
            }
            
            tblMenuOptions.reloadData()
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.clear
        
        cell.vwImage.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        cell.lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        if indexPath.row == 0{
            if currentController == "MyAccount"{
                
            }else{
                if ((logIndict["profilePicture"] as? String) != nil)
                {
                    if (logIndict["profilePicture"] is NSNull || logIndict["profilePicture"] == nil){
                        cell.vwImage.image = UIImage(named: "User-2")
                    }else{
                        let imageUrl = "\(logIndict .value(forKey: "profilePicture")!)"
                        if imageUrl .isEmpty{
                            cell.vwImage.image = UIImage(named: "User-2")
                        }else{
                            let fullUrl = "http://www.leakitapp.com/uploads/profilePicture/\(imageUrl)"
                            fileUrl = NSURL(string: fullUrl)!
                            
                            print("IUmageURL: === \(fullUrl)")
                            cell.vwImage.image = UIImage(named: "User-2")
                            
                            
                            SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                                (receivedSize :Int, ExpectedSize :Int) in
                                
                            }, completed: {
                                (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                                cell.vwImage.image = image
                                cell.vwImage.contentMode = .scaleAspectFill
                            })
                        }
                        
                    }
                }else{
                    cell.vwImage.image = UIImage(named: "User-2")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        
        //let revealViewController : SWRevealViewController = self.revealViewController()
        
        //let cell : MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        /*
        if indexPath.row == 0{
//            let storyboard:UIStoryboard = UIStoryboard(name: "Application",  bundle: nil)
//            let destViewController = storyboard.instantiateViewController(withIdentifier: "MyAccount") as! MyAccountViewController
//
//            let newFrontViewController =  UINavigationController.init(rootViewController: destViewController)
//            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            
            //self.performSegue(withIdentifier: "segueToMyAccount", sender: self)
            
            
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Application", bundle: nil)
            let MyAccountViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "MyAccount") as! MyAccountViewController
            self.navigationController?.pushViewController(MyAccountViewController, animated: true)
        }
         if indexPath.row == 1{
//            let storyboard:UIStoryboard = UIStoryboard(name: "Application",  bundle: nil)
//            let DashboardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
//
//            let newFrontViewController =  UINavigationController.init(rootViewController: DashboardViewController)
//            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            
            self.performSegue(withIdentifier: "segueToDashboard", sender: self)
        }
        if indexPath.row == 2{
//            let storyboard:UIStoryboard = UIStoryboard(name: "Application",  bundle: nil)
//            let destViewController = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
//
//            let newFrontViewController =  UINavigationController.init(rootViewController: destViewController)
//            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
            self.performSegue(withIdentifier: "segueToSetting", sender: self)
        }
       
         if indexPath.row == 3{
            self.apiCallLogout()
        }
 */
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        //return CGFloat(self.cellHeight)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
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
