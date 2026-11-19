//
//  DashboardViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/05/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import PopupDialog
import AMProgressBar

class DashboardViewController: UIViewController,CollapsibleTableViewHeaderDelegate,UITableViewDataSource,UITableViewDelegate {

    
    /*
     Points                         Level Name
     
     100 - 500                      NooB
     
     501 - 1,000                    Contributor
     
     1,001 - 2,500                  Padawan
     
     2,501 - 7,500                  Knight
     
     7,501 - 15,000                 Sentinel
     
     15,001 - 25,000                Master
     
     25,001 +                       Grand Master
     */
    
    
    
    
    var sections = sectionsData
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var btnEditOutlet: UIButton!
    @IBOutlet weak var mainScrlView: UIScrollView!

    @IBOutlet weak var tblActivity: UITableView!
    @IBOutlet weak var lblRewardPoint: UILabel!
    @IBOutlet weak var lblRewardName: UILabel!
    @IBOutlet weak var imgReward: UIImageView!
    var point = Int()
    var logIndict = NSDictionary()
    var login_token = String()
    var dataArray = NSMutableDictionary()
    var fileUrl = NSURL()
    var totalUserDict = [String: AnyObject]()
    var zip = String()
    @IBOutlet var currentPointImage: UIImageView!
    @IBOutlet var nextPointImage: UIImageView!
    
    @IBOutlet var vwUserProgress: UIView!
    @IBOutlet var vwProgress: AMProgressBar!
    @IBOutlet var lblStartPointRange: UILabel!
    @IBOutlet var lblEndPointRange: UILabel!
    @IBOutlet var vwTop: UIView!
    
    var logIndict1 = NSDictionary()
    var untappdAccessToken = String()
    
    
    
    
    
    
    //MARK:- view lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 13.0, *) {
               overrideUserInterfaceStyle = .light
         } else {
               // Fallback on earlier versions
        }
        
//        self.tblActivity.clipsToBounds = true
//        self.tblActivity.layer.cornerRadius = 20
//        if #available(iOS 11.0, *) {
//            self.tblActivity.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        } else {
//            // Fallback on earlier versions
//        }
        
        //setGradientBackground()
                
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        //print("UserDict: == \(logIndict)")
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        print(login_token)
        
        // Do any additional setup after loading the view.
        userImage.layer.cornerRadius = self.userImage.frame.size.width/2
        userImage.clipsToBounds = true
        
        btnEditOutlet.layer.cornerRadius = 5.0
        btnEditOutlet.layer.borderWidth = 1.0
        btnEditOutlet.layer.borderColor = UIColor.lightGray.cgColor
        
        tblActivity.estimatedRowHeight = 44.0
        tblActivity.rowHeight = UITableView.automaticDimension
        
        tblActivity.frame = CGRect(x: tblActivity.frame.origin.x,y: tblActivity.frame.origin.y,width: tblActivity.frame.size.width,height: tblActivity.frame.size.height)
        mainScrlView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: tblActivity.contentSize.height)
        
        let footerView = UIView()
        //footerView.backgroundColor = UIColor(red: 241/255.0, green:
            //128/255.0, blue: 24/255.0, alpha: 1.0)
        footerView.backgroundColor = UIColor.clear
        footerView.frame = CGRect(x: 0, y: 0, width: self.tblActivity.frame.width, height:
            88)
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: self.tblActivity.frame.size.width, height: 44)
        button.setTitle("Contribution Points", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.setTitleColor(UIColor.black, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 160, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 10)
        button.backgroundColor = UIColor.clear
        footerView.addSubview(button)
        
        let untappdbutton = UIButton()
        untappdbutton.frame = CGRect(x: 0, y: 45, width: self.view.frame.size.width, height: 44)
        untappdbutton.setTitle("Uptappd Account", for: .normal)
        untappdbutton.titleLabel?.font = .systemFont(ofSize: 17)
        untappdbutton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        untappdbutton.setTitleColor(UIColor.white, for: .normal)
        untappdbutton.semanticContentAttribute = .forceRightToLeft
        untappdbutton.addTarget(self, action:#selector(self.untappdbuttonClicked), for: .touchUpInside)
        untappdbutton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 160, bottom: 0, right: 0)
        untappdbutton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 10)
        untappdbutton.backgroundColor = UIColor.red
        footerView.addSubview(untappdbutton)
        
        tblActivity.tableFooterView = footerView
    }
 
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds

        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @objc func buttonClicked() {
        let MyAchievementViewController = self.storyboard?.instantiateViewController(withIdentifier: "Achievement") as! MyAchievementViewController
        self.navigationController?.pushViewController(MyAchievementViewController, animated: true)
    }
    
    @objc func untappdbuttonClicked() {
        
        
            
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict1 = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        untappdAccessToken = "\(logIndict1 .value(forKey: "untappd_access_token")!)"
        print(untappdAccessToken)

        //if let _ = TokenService.instance.untappdAccessToken{
        if untappdAccessToken != "<null>"{
            //UntappdListVC
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "UntappdListVC") as! UntappdListVC

            self.navigationController?.pushViewController(VC, animated: true)
        }
        else{
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "LinkYourAccount") as! LinkYourAccount

            self.navigationController?.pushViewController(VC, animated: true)

        }
 
        
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LinkYourAccount") as! LinkYourAccount
//
//        self.navigationController?.pushViewController(VC, animated: true)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "My Profile"
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingTapped))
                
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        print("UserDict: == \(logIndict)")
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        print(login_token)
        
        self.apiCallUserDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func settingTapped(_ sender: UIButton){
        let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
        self.navigationController?.pushViewController(LoginViewController, animated: true)
    }
    
    //MARK:- UserDetail Api Call
    
    func apiCallUserDetails(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_account"
        
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
                                
                self.totalUserDict = (json["userDtls"] as AnyObject) as! [String : AnyObject]
                print(self.totalUserDict)

                //store dic data
                let data = NSKeyedArchiver.archivedData(withRootObject: self.totalUserDict)
                UserDefaults.standard.set(data, forKey: "key_profile_info")
                //show dic data
                let loginData = UserDefaults.standard.data(forKey: "key_profile_info")
                let logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData!) as! NSDictionary

                print(logIndict)
               
                self.dataArray = (json["userDtls"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                print(self.dataArray)
            
                if (self.dataArray.value(forKey: "zip_code") is NSNull) || self.dataArray["zip_code"] as! String == "<null>"{
                    self.zip = ""
                }else{
                    self.zip = self.dataArray["zip_code"] as! String
                }
//                if self.dataArray["zip_code"] as! String != "" || self.d\ataArray["zip_code"] as? String != nil || !(self.dataArray.value(forKey: "zip_code") is NSNull){
//               // if self.dataArray["zip_code"] as! String != ""{
//                    self.zip = self.dataArray["zip_code"] as! String
//                }else{
//
//                }
                self.userName.text = (self.dataArray["fname"] as! String) + (self.dataArray["lname"] as! String)
                self.userEmail.text = self.dataArray["email"] as? String
                self.lblRewardPoint.text = String(self.dataArray["point"] as! Int)
                self.lblRewardName.text = self.dataArray["user_level"] as? String
                
                if (self.dataArray.value(forKey: "address") is NSNull) || (self.dataArray["address"] as! String == "<null>"){
                    self.userAddress.text = ""
                }else{
                    if (self.dataArray.value(forKey: "state") is NSNull) &&  (self.dataArray.value(forKey: "city") is NSNull) &&  (self.dataArray.value(forKey: "country") is NSNull) {
                        self.userAddress.text = "\(self.dataArray["address"] as! String), \(self.zip)"
                    }else if self.dataArray["state"] as! String == "<null>" &&  self.dataArray["city"] as! String == "<null>" && self.dataArray["country"] as! String == "<null>" {
                        self.userAddress.text = "\(self.dataArray["address"] as! String), \(self.zip)"
                    }else{
                        self.userAddress.text = "\(self.dataArray["address"] as! String), \(self.dataArray["state"] as! String), \(self.dataArray["city"] as! String), \(self.dataArray["country"] as! String), \(self.zip)"
                    }
                }
               
                self.userAddress.numberOfLines = 0
                self.userAddress.lineBreakMode = NSLineBreakMode.byWordWrapping
                
                if (self.dataArray["profile_image"] is NSNull){
                    //            cell.imageVWCell.image = placeholderImage
                    self.userImage.image = UIImage(named: "User-2")
                }else{
                    let imageUrl = self.dataArray["profile_image"] as! String
                    let fullUrl = imageUrl
                    self.fileUrl = NSURL(string: fullUrl)!
                    
                    SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                        (receivedSize :Int, ExpectedSize :Int) in
                        
                    }, completed: {
                        (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                        self.userImage.image = image
                    })
                }
                
                if (self.dataArray["level_logo"] is NSNull){
                    //            cell.imageVWCell.image = placeholderImage
                    self.imgReward.image = UIImage(named: "no-image.png")
                }else{
                    let imageUrl = self.dataArray["level_logo"] as! String
                    let fullUrl = imageUrl
                    self.fileUrl = NSURL(string: fullUrl)!
                    
                    
                    
                    SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                        (receivedSize :Int, ExpectedSize :Int) in
                        
                    }, completed: {
                        (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                        self.imgReward.image = image
                        self.currentPointImage.image = image
                    })
                }
                
                let user_nxt_level = self.dataArray["user_nxt_level"] as? NSDictionary
                if (user_nxt_level!["level_logo"] is NSNull){
                    //            cell.imageVWCell.image = placeholderImage
                }else{
                    let imageUrl = user_nxt_level!["level_logo"] as! String
                    let fullUrl = imageUrl
                    self.fileUrl = NSURL(string: fullUrl)!
                    
                    self.nextPointImage.image = UIImage(named: "no-image.png")
                    
                    SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                        (receivedSize :Int, ExpectedSize :Int) in
                        
                    }, completed: {
                        (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                        self.nextPointImage.image = image
                    })
                }
                
                let maxRange = (self.dataArray["point"] as! Int) + (user_nxt_level!["required_point"] as! Int)
                let progressStatus = (((user_nxt_level!["required_point"] as! Int) * 100) / maxRange)
                let finalProgress = 100 - progressStatus
                let percentage: Double = (Double((CGFloat(finalProgress)) / 100))
                let doubleStr = String(format: "%.2f", percentage)
                guard let n = NumberFormatter().number(from: doubleStr) else { return }
                
                self.vwProgress.setProgress(progress: CGFloat(truncating: n), animated: true)
                
                let userCurrentLevel = self.dataArray["user_current_level"] as? NSDictionary
                
                self.lblEndPointRange.text = "(\((userCurrentLevel!["point_to"] as? Int)!))"
                self.lblStartPointRange.text = "(\((userCurrentLevel!["point_from"] as? Int)!))"
                self.userImage.contentMode = UIView.ContentMode.scaleAspectFill
                self.userImage.clipsToBounds = true
                SVProgressHUD.dismiss()
        }
    }
    
    
    //MARK:- Tableview Delegate/Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        print("Number of Section:\(sections.count)")
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].items.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsibleTableViewCell ??
            CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")
        
        let item: Item = sections[indexPath.section].items[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        cell.nameLabel.text = item.name
        cell.nameLabel.textColor = UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row clicked of index: \(indexPath.row) of section \(indexPath.section)")
        if indexPath.section == 0 && indexPath.row == 0{
            let BeerReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerReviewList") as! BeerReviewListViewController
            BeerReviewViewController.fromBeerReview = true
            self.navigationController?.pushViewController(BeerReviewViewController, animated: true)
        }
        else if indexPath.section == 0 && indexPath.row == 1{
            let PhotoListViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoList") as! PhotoListViewController
            PhotoListViewController.fromBeer = true
            self.navigationController?.pushViewController(PhotoListViewController, animated: true)
        }
        else if indexPath.section == 0 && indexPath.row == 2{
            let BeerReviewViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "BeerReviewList") as! BeerReviewListViewController
            BeerReviewViewController.fromMyBeer = true
            self.navigationController?.pushViewController(BeerReviewViewController, animated: true)
                
//                self.storyboard?.instantiateViewController(withIdentifier: "BeerReviewList") as! BeerReviewListViewController
//            BeerReviewViewController.fromMyBeer = true
//            self.navigationController?.pushViewController(BeerReviewViewController, animated: true)
        }
        else if indexPath.section == 2 && indexPath.row == 0{
            let BeerReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerReviewList") as! BeerReviewListViewController
            BeerReviewViewController.fromBarReview = true
            self.navigationController?.pushViewController(BeerReviewViewController, animated: true)
        }
        else if indexPath.section == 2 && indexPath.row == 1{
            let PhotoListViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoList") as! PhotoListViewController
            PhotoListViewController.fromBar = true
            self.navigationController?.pushViewController(PhotoListViewController, animated: true)
        }
        else if indexPath.section == 2 && indexPath.row == 2{
            let BeerReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerReviewList") as! BeerReviewListViewController
            BeerReviewViewController.fromMyBar = true
            self.navigationController?.pushViewController(BeerReviewViewController, animated: true)
        }
        else if indexPath.section == 3 && indexPath.row == 0{
            let BeerReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerReviewList") as! BeerReviewListViewController
            BeerReviewViewController.fromBottleReview = true
            self.navigationController?.pushViewController(BeerReviewViewController, animated: true)
        }
        else if indexPath.section == 3 && indexPath.row == 1{
            let PhotoListViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoList") as! PhotoListViewController
            PhotoListViewController.fromBottle = true
            self.navigationController?.pushViewController(PhotoListViewController, animated: true)
        }
        else if indexPath.section == 3 && indexPath.row == 2{
            let BeerReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerReviewList") as! BeerReviewListViewController
            BeerReviewViewController.fromMyBottle = true
            self.navigationController?.pushViewController(BeerReviewViewController, animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 0{
            let PhotoListViewController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoList") as! PhotoListViewController
            PhotoListViewController.fromBrewery = true
            self.navigationController?.pushViewController(PhotoListViewController, animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 1{
            let BeerReviewViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerReviewList") as! BeerReviewListViewController
            BeerReviewViewController.fromBrewery = true
            self.navigationController?.pushViewController(BeerReviewViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.titleLabel.textColor = UIColor.black
        header.arrowLabel.text = ">"
        header.arrowLabel.textColor = UIColor.black
        header.setCollapsed(sections[section].collapsed)

        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        print(sections[indexPath.section].collapsed)
        if sections[indexPath.section].collapsed == true{
            mainScrlView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.tblActivity.frame.origin.y + self.tblActivity.contentSize.height)
        }else{
            mainScrlView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.tblActivity.frame.origin.y + self.tblActivity.contentSize.height + 100)
        }
    }
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed

        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)

        tblActivity.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }

    //MARK:- Edit Button Action
    
    @IBAction func btnEditProfileDidTap(_ sender: Any) {
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


