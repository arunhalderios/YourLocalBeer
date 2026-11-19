//
//  LinkYourAccount.swift
//  YourLocalBeer
//
//  Created by Arun Halder on 09/09/20.
//  Copyright © 2020 Abhishek Mullick. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class LinkYourAccount: UIViewController {
    
    @IBOutlet  weak var  HiUsername: UILabel!
    
    
    var logIndict1 = NSDictionary()
    var login_token = String()
    var untappdAccessToken = String()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = true
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict1 = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        login_token = "\(logIndict1 .value(forKey: "login_token")!)"
        untappdAccessToken = "\(logIndict1 .value(forKey: "untappd_access_token")!)"
        print(login_token)
        print(untappdAccessToken)

    }
    
    
    @IBAction func linkYourAccount(_sender: UIButton){
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LinkUntappdVC") as! LinkUntappdVC

        self.navigationController?.pushViewController(VC, animated: true)

    }


}
