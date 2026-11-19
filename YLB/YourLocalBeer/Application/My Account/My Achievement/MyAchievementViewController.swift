//
//  MyAchievementViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 17/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class MyAchievementViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var achievementCollectionView: UICollectionView!
    var logIndict = NSDictionary()
    var login_token = String()
    var dataArray = NSMutableArray()
    var activeData = NSMutableArray()
    var Str: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
               overrideUserInterfaceStyle = .light
         } else {
               // Fallback on earlier versions
        }
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        //print("UserDict: == \(logIndict)")
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        print(login_token)
        
        self.fetchUserAchievements()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logIndict)")
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        print(login_token)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- User Achievements Api Call
    
    func fetchUserAchievements(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_achivments"
        
        let newTodo: [String: Any] = ["login_token": login_token]
        
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
                self.dataArray = (json["achivments"] as! NSArray).mutableCopy() as! NSMutableArray
                self.achievementCollectionView.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Breweries Collection View Delegate/Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCell", for: indexPath) as! AchievementCollectionViewCell
        // Configure the cell
        let dic = self.dataArray[indexPath.row] as! NSDictionary
        print(dic)
        cell.lblAchievementName.text = dic["name"] as? String
        Str = dic["points"] as? String
        
        if (Str ?? "").isEmpty {
            cell.lblAchieveCount.text = "0"
            //cell.isHidden = true
        }else{
            cell.lblAchieveCount.text = dic["points"] as? String
        }
        
        cell.lblAchievementName.numberOfLines = 0
        cell.lblAchievementName.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.lblAchievementName.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: achievementCollectionView.frame.size.width/2-5, height:  achievementCollectionView.frame.size.height/3-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10.0, left: 0, bottom: 10.0, right: 0)
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
