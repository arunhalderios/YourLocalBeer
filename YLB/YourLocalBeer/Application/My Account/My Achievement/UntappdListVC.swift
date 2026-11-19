//
//  UntappdListVC.swift
//  YourLocalBeer
//
//  Created by Arun Halder on 26/08/20.
//  Copyright © 2020 Abhishek Mullick. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire


class UntappdListVC: UIViewController {
    var logIndict = NSDictionary()
    var login_Token = String()
    var dataArray = NSMutableArray()
    var activeData = NSMutableArray()
    var infoArray = NSMutableArray()

    var arr = [Int]()
    var arrResponse = [[String: Any]]()
    var nameArray = NSMutableArray()
    var image_URL = ""
    
    //refreshControl
    var refreshControl = UIRefreshControl()
    var pageIndexNo = 1
    
    var nextUrlStr = ""
    var previousUrlStr = ""
    var currentUrlStr = BASE_URL + "untappd-checkins"
    var currentPageNo:Int = 0
    
    



    
    
    @IBOutlet weak var profileImgVw: UIImageView!
    @IBOutlet weak var listTbleVw: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var coverImgVw:UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var uniqueLbl: UILabel!
    @IBOutlet weak var batchLbl: UILabel!
    @IBOutlet weak var friendsLbl: UILabel!
    @IBOutlet weak var noDataFoundLbl: UILabel!
    
    @IBOutlet weak var nextBtn:UIButton!
    @IBOutlet weak var previousBtn:UIButton!
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTbleVw.isHidden = true
        self.noDataFoundLbl.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = true
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        login_Token = "\(logIndict .value(forKey: "login_token")!)"
        print(login_Token)
        
        // configureTabAndView()
         //for refresh controller
         refreshControl.addTarget(self, action: #selector(UntappdListVC.refreshData), for: UIControl.Event.valueChanged)
         if #available(iOS 10.0, *){
             //tableView.refreshControl = refreshControl
            listTbleVw.refreshControl = refreshControl
         }else{
             //tableView.addSubview(refreshControl)
            listTbleVw.addSubview(refreshControl)
         }

        
        self.fetchUserInfo()
        self.fetchUntappdDetails()

    }
    

    
    func fetchUserInfo() {
    SVProgressHUD.show(withStatus: "It's working...")
    let todosEndpoint: String = BASE_URL + "untappd-account" //"https://www.beta.yourlocalbeer.com/api/untappd-account"
    let Url = String(format: todosEndpoint)
    guard let serviceUrl = URL(string: Url) else { return }
    let parameterDictionary = ["login_token": login_Token]
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
    print(json)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

    if let account = json["account"] as? [String:Any] {
        
        
            if let coverphoto = account["user_cover_photo"] as? String {
                print("coverphoto:\(coverphoto)")
                let url = URL(string: "\(coverphoto)")

                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.coverImgVw.image = UIImage(data: data!)
                    }
                }
            }
        
        //user_avatar
        
            if let avatarPic = account["user_avatar"] as? String {
                print("avatarPic:\(avatarPic)")
                let url = URL(string: "\(avatarPic)")

                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.profileImgVw.image = UIImage(data: data!)
                    }
                }
            }
        
            if let firstName = account["first_name"] as? String {
                print("firstName:\(firstName)")
                self.nameLbl.text = firstName
            }
             
            if let userName = account["user_name"] as? String {
                    print("userName:\(userName)")
                    self.userNameLbl.text = userName
                }
                if let location = account["location"] as? String {
                    print("location:\(location)")
                    self.addressLbl.text = location
                }


        

    if let totalStats = account["stats"] as? [String: Int] {
        
       // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            
        if let total = totalStats["total_checkins"] {
                print("total:\(total)")
                self.totalLbl.text = "\(total)"
            }
            
        if let unique = totalStats["total_beers"] {
                print("unique:\(unique)")
                self.uniqueLbl.text = "\(unique)"
            }
            
        if let badges = totalStats["total_badges"] {
                print("badges:\(badges)")
                self.batchLbl.text = "\(badges)"
            }
            
        if let totalFriends = totalStats["total_friends"] {
                print("totalFriends:\(totalFriends)")
                self.friendsLbl.text = "\(totalFriends)"
            }
        
        //}
        }
        }
       // SVProgressHUD.dismiss()
        }

    }

    } catch {
    print(error)
    }
    }
    }.resume()
    }
    
    
    @objc func refreshData(){
        self.pageIndexNo = 1
        self.fetchUntappdDetails()
    }
    
    
    func fetchUntappdDetails() {
        SVProgressHUD.show(withStatus: "It's working...")

        let todosEndpoint: String = BASE_URL + "untappd-checkins?page="+"\(self.pageIndexNo)"//"https://www.beta.yourlocalbeer.com/api/untappd-checkins?page=3"
        print("URL:\(todosEndpoint)")
    let Url = String(format: currentUrlStr)
    guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["login_token": login_Token]
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
        
    self.image_URL = json["image_url"] as! String
     print(self.image_URL)
        


    if let checkins = json["checkins"] as? [String:Any] {
//        self.currentPageNo = (checkins["current_page"] as? Int
//        print(self.currentPageNo)
        self.nextUrlStr = (checkins["next_page_url"] as? String) ?? ""
        print("Next Page:\(self.nextUrlStr)")
        self.previousUrlStr = (checkins["prev_page_url"] as? String) ?? ""
        print("Previous Page:\(self.previousUrlStr)")

        if let arr = checkins["data"] as? [[String: Any]], arr.count > 0 {
            self.arrResponse = arr
            print(self.arrResponse.count)
            print("Array:\(self.arrResponse)")
            
            DispatchQueue.main.async {
               self.listTbleVw.reloadData()
                self.listTbleVw.isHidden = false
                self.noDataFoundLbl.isHidden = true
            }
            

            
            
            //let style = ((arr[0])["beer"])?.value(forKey: "style")
            //print("style:\(style!)")
//            let name = ((arr[0]as! [String: AnyObject])["beer"])?.value(forKey: "name")
//            print("name:\(name!)")
//
//            let baHads = ((arr[0]as! [String: AnyObject])["beer"])?.value(forKey: "baHads")
//            print("baHads:\(baHads!)")

            
        }
    }
        SVProgressHUD.dismiss()

    }

    } catch {
    print(error)
        SVProgressHUD.dismiss()

    }
    }
    }.resume()
    
    }
    
}


extension UntappdListVC : UITableViewDelegate,UITableViewDataSource{
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrResponse.count > 0{
            return arrResponse.count
        }
        else{
            return 0
        }
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = listTbleVw.dequeueReusableCell(withIdentifier: "UntappdTbleVwCell", for: indexPath) as! UntappdTbleVwCell
        
        if arrResponse.count > 0{
                        
            let item = arrResponse[indexPath.row]
            print(item)
            print(item["rating_score"] as? String? as Any)
            
            if let ratingScore = item["rating_score"] as? Float{
                cell.ratingLbl.text = "\(ratingScore)"
            }
            
            
            if let beerItem = item["beer"] as? [String: Any] {
                print("===========================BEER ITEM===========================")
                print("beerItem:\(beerItem)")
                cell.nameLbl.text = beerItem["name"] as? String
//                cell.ratingLbl.text = String(format: "%.2f", beerItem["baRating"] as! Float64)
                cell.brandLbl.text = beerItem["style"] as? String
                cell.companyLbl.text = beerItem["brewery"] as? String
                
              //  let remainingPart =  beerItem["beer_images"]?.value(forKey: "name") as? String
                
                let bt = beerItem["beer_images"] as? [[String: Any]]
                print(bt!)
                let remainingPart = bt?[0]["name"] as? String
                print("remainingPart:\(String(describing: remainingPart))")
                print("image_URL:\(image_URL)")
                if let imgName = remainingPart{
                let imageUrl = image_URL  + imgName
                print("ImageUrl:\(imageUrl)")
                if let url = URL(string: imageUrl){
                    cell.imgVw.sd_setImage(with:url)
                }
            }
            }
        }
        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerDetail") as! BeerDetailViewController
        
        let item = arrResponse[indexPath.row]
        if let beerItem = item["beer"] as? [String: Any] {

            HomeViewController.beerID = (beerItem["_id"] as? String)!
            HomeViewController.BeerName = (beerItem["name"] as? String)!
            HomeViewController.BreweryName = (beerItem["brewery"] as? String)!
            HomeViewController.Style = (beerItem["style"] as? String)!
        }
        //HomeViewController.fromBeer = true
        self.navigationController?.pushViewController(HomeViewController, animated: true)
    }
    

    
    @IBAction func nextBtn(_sender: UIButton){
        
        currentUrlStr = nextUrlStr
        self.fetchUntappdDetails()
    }
    
    @IBAction func previousBtn(_sender: UIButton){
        
        currentUrlStr = previousUrlStr
        self.fetchUntappdDetails()
    }

}


extension UIView {
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
    
    
}
