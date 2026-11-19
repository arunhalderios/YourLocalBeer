//
//  SettingViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/05/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
              overrideUserInterfaceStyle = .light
        } else {
              // Fallback on earlier versions
        }
        
        self.view.backgroundColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "left-arrow"), style:  UIBarButtonItemStyle.plain, target: self, action: #selector(SettingViewController.barButtonClickAction))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Setting"), style: .plain, target: self, action: #selector(SettingViewController.barSettingButtonClickAction))
        
        // Only execute the code if there's a navigation controller
        if self.navigationController == nil {
            return
        }
        
        // Create a navView to add to the navigation bar
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = "SETTINGS"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        // Add both the label and image view to the navView
        navView.addSubview(label)
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView
        
        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnChangePassDidTap(_ sender: Any) {
        let ChangePasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassword") as! ChangePasswordViewController
                self.navigationController?.pushViewController(ChangePasswordViewController, animated: true)
    }
    
    @IBAction func btnEditAccountDidTap(_ sender: Any) {
        let EditProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditProfile") as! EditProfileViewController
        self.navigationController?.pushViewController(EditProfileViewController, animated: true)
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
