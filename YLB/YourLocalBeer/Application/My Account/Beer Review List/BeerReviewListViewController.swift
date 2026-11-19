//
//  BeerReviewListViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 13/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
//import HTMLString


class BeerReviewListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BeerReviewTableViewCellDelegate {

    @IBOutlet weak var beerReviewTableView: UITableView!
    var fromBeerReview = Bool()
    var fromBarReview = Bool()
    var fromBottleReview = Bool()
    var fromBrewery = Bool()
    var fromMyBeer = Bool()
    var fromMyBar = Bool()
    var fromMyBottle = Bool()
    var logIndict = NSDictionary()
    var login_token = String()
    var dataArray = NSMutableArray()
    var pageNo = Int()
    var totalPageCount = Int()
    var beerId = String()
    var textarray = NSMutableArray()
    var ratingID = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
               overrideUserInterfaceStyle = .light
         } else {
               // Fallback on earlier versions
        }
        
        pageNo = 0
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        //print("UserDict: == \(logIndict)")
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        print(login_token)
        
        self.beerReviewTableView.rowHeight = UITableView.automaticDimension
        self.beerReviewTableView.estimatedRowHeight = 140;
        
        textarray = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        //print("UserDict: == \(logIndict)")
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        print(login_token)
        
        if fromMyBeer == true{
            self.apiCallMyBeer()
        }
        else if fromBeerReview == true{
            self.apiCallMyBeerReview()
        }
        else if fromMyBar == true{
            self.apiCallMyBar()
        }
        else if fromBarReview == true{
            self.apiCallMyBarReview()
        }
        else if fromBrewery == true{
            self.apiCallMyBrewery()
        }
        else if fromMyBottle == true{
            self.apiCallMyBottle()
        }
        else if fromBottleReview == true{
            self.apiCallMyBottleReview()
        }
    }
    
    //MARK:- My Bar Api Call
    
    func apiCallMyBar(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_bars"
        
        let newTodo: [String: Any] = ["login_token": login_token,"page_number":pageNo]
        
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
                let listPageArr = json["bars"] as! NSArray
                if json["total"] != nil
                {
                    self.totalPageCount = json["total"] as! Int
                }
                if listPageArr.count>0
                {
                    if self.pageNo > self.totalPageCount
                    {
                    }else
                    {
                        self.pageNo = self.pageNo + 1
                        let arrConcert = (json["bars"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.beerReviewTableView.delegate = self
                        self.beerReviewTableView.dataSource = self
                        self.beerReviewTableView.reloadData()
                    }
                }
                SVProgressHUD.dismiss()
        }
    }
    
    
    //MARK:- My Bar Review Api Call
    
    func apiCallMyBarReview(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_reviews"
        
        let newTodo: [String: Any] = ["login_token": login_token,"type": "bar","page_number":pageNo]
        
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
                let listPageArr = json["reviews"] as! NSArray
                if json["total"] != nil
                {
                    self.totalPageCount = json["total"] as! Int
                }
                if listPageArr.count>0
                {
                    if self.pageNo > self.totalPageCount
                    {
                    }else
                    {
                        self.pageNo = self.pageNo + 1
                        let arrConcert = (json["reviews"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.beerReviewTableView.delegate = self
                        self.beerReviewTableView.dataSource = self
                        self.beerReviewTableView.reloadData()
                    }
                }
                self.beerReviewTableView.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    
    //MARK:- My Brewery Api Call
    
    func apiCallMyBrewery(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_brewries"
        
        let newTodo: [String: Any] = ["login_token": login_token,"page_number":pageNo]
        
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
                let listPageArr = json["brewries"] as! NSArray
                if json["total"] != nil
                {
                    self.totalPageCount = json["total"] as! Int
                }
                if listPageArr.count>0
                {
                    if self.pageNo > self.totalPageCount
                    {
                    }else
                    {
                        self.pageNo = self.pageNo + 1
                        let arrConcert = (json["brewries"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.beerReviewTableView.delegate = self
                        self.beerReviewTableView.dataSource = self
                        self.beerReviewTableView.reloadData()
                    }
                }
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- My Bottle Api Call
    
    func apiCallMyBottle(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_bottleshop"
        
        let newTodo: [String: Any] = ["login_token": login_token,"page_number":pageNo]
        
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
                let listPageArr = json["bottleshops"] as! NSArray
                if json["total"] != nil
                {
                    self.totalPageCount = json["total"] as! Int
                }
                if listPageArr.count>0
                {
                    if self.pageNo > self.totalPageCount
                    {
                    }else
                    {
                        self.pageNo = self.pageNo + 1
                        let arrConcert = (json["bottleshops"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.beerReviewTableView.delegate = self
                        self.beerReviewTableView.dataSource = self
                        self.beerReviewTableView.reloadData()
                    }
                }
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- My Bottle Review Api Call
    
    func apiCallMyBottleReview(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_reviews"
        
        let newTodo: [String: Any] = ["login_token": login_token,"type": "bottleshop","page_number":pageNo]
        
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
                let listPageArr = json["reviews"] as! NSArray
                if json["total"] != nil
                {
                    self.totalPageCount = json["total"] as! Int
                }
                if listPageArr.count>0
                {
                    if self.pageNo > self.totalPageCount
                    {
                    }else
                    {
                        self.pageNo = self.pageNo + 1
                        let arrConcert = (json["reviews"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.beerReviewTableView.delegate = self
                        self.beerReviewTableView.dataSource = self
                        self.beerReviewTableView.reloadData()
                    }
                }
                self.beerReviewTableView.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- My Beer Api Call
    
    func apiCallMyBeer(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_beer"
        
        let newTodo: [String: Any] = ["login_token": login_token,"page_number":pageNo]
        
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
                let listPageArr = json["beers"] as! NSArray
                if json["total"] != nil
                {
                    self.totalPageCount = json["total"] as! Int
                }
                if listPageArr.count>0
                {
                    if self.pageNo > self.totalPageCount
                    {
                    }else
                    {
                        self.pageNo = self.pageNo + 1
                        let arrConcert = (json["beers"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.beerReviewTableView.delegate = self
                        self.beerReviewTableView.dataSource = self
                        self.beerReviewTableView.reloadData()
                    }
                }
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- My Beer Review Api Call
    
    func apiCallMyBeerReview(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_reviews"
        
        let newTodo: [String: Any] = ["login_token": login_token,"type": "beer","page_number":pageNo]
        
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
                let listPageArr = json["reviews"] as! NSArray
                if json["total"] != nil
                {
                    self.totalPageCount = json["total"] as! Int
                }
                if listPageArr.count>0
                {
                    if self.pageNo > self.totalPageCount
                    {
                    }else
                    {
                        self.pageNo = self.pageNo + 1
                        let arrConcert = (json["reviews"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.beerReviewTableView.delegate = self
                        self.beerReviewTableView.dataSource = self
                        self.beerReviewTableView.reloadData()
                    }
                }
                SVProgressHUD.dismiss()
        }
    }
    
    
    //MARK: - TableView Deleagte/DataSource
    @objc func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    @objc func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dataArray.count == 0){
            return 1
        }else{
            return dataArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(dataArray.count == 0){
            var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                
                cell = beerReviewTableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }else{
            let cell = beerReviewTableView.dequeueReusableCell(withIdentifier:"beerReviewCell", for: indexPath)as! BeerReviewTableViewCell
            if fromBrewery == true{
                //cell.lblRate.isHidden = true
                cell.lblComment.isHidden = true
                cell.lblStaticRate.isHidden = true
                cell.lblRate.isHidden = true
                let dic = self.dataArray[indexPath.row] as! NSDictionary
                print(dic)
                cell.beerName.text = dic["name"] as? String
                if let value = (dic["state"] as? String)
                {
                    //NOT NULL
                    cell.beerAddress.text = "\((dic["address"] as? String)!),\((dic["country"] as? String)!),\(value),\((dic["city"] as? String)!)"
                }
                else
                {
                    //NULL
                    cell.beerAddress.text = "\((dic["address"] as? String)!),\((dic["country"] as? String)!),\((dic["city"] as? String)!)"
                }
            }
            else if fromMyBeer == true || fromMyBar == true || fromMyBottle == true
            {
                cell.lblComment.isHidden = true
                let dic = self.dataArray[indexPath.row] as! NSDictionary
                print(dic)
                cell.btnDeleteOutlet.isHidden = true
                cell.beerName.text = dic["name"] as? String
                cell.beerAddress.text = dic["address"] as? String
                cell.lblRate.text = String((dic["overall"] as! NSNumber).floatValue)
            }
            else if fromBeerReview == true{
                let dic = self.dataArray[indexPath.row] as! NSDictionary
                print(dic)
                self.beerId = dic["beer_id"] as! String
                let beerDetails = dic["beer"] as! NSDictionary
                cell.beerName.text = beerDetails["name"] as? String
                cell.beerAddress.text = beerDetails["manufName"] as? String
                if ((dic["overall"] as? NSNumber)?.floatValue) == nil{
                    cell.lblRate.text = ""
                }else{
                    cell.lblRate.text = String((dic["overall"] as! NSNumber).floatValue)
                }
                
                if (dic["description"] as? String == nil){
                    
                }else{
                    let desstr = dic["description"] as? String
                    let snack = desstr?.removingHTMLEntities
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = .justified

                    let str = snack?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

                    let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraph]
                    let attrString = NSAttributedString(string:str!, attributes: attributes)
                    cell.lblComment.attributedText = attrString
                }
                
                
                //cell.lblComment.text = textarray[indexPath.row] as? String
                
                cell.lblComment.numberOfLines = 0
                cell.lblComment.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.lblComment.layer.masksToBounds = true
            }
            else if fromBarReview == true{
                let dic = self.dataArray[indexPath.row] as! NSDictionary
                print(dic)
                self.beerId = dic["restaurent_id"] as! String
                let barDetails = dic["bar"] as! NSDictionary
                cell.beerName.text = barDetails["name"] as? String
                cell.beerAddress.text = barDetails["address"] as? String
                cell.lblRate.text = String((dic["rating"] as! NSNumber).floatValue)
                if (dic["review"] is NSNull){
                    cell.lblComment.text = ""
                }else{
                    let desstr = dic["review"] as? String
                    let snack = desstr?.removingHTMLEntities
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = .justified

                    let str = snack?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

                    let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraph]
                    let attrString = NSAttributedString(string:str!, attributes: attributes)
                    cell.lblComment.attributedText = attrString
                }
                cell.lblComment.numberOfLines = 0
                cell.lblComment.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.lblComment.layer.masksToBounds = true
            }
            else if fromBottleReview == true{
                let dic = self.dataArray[indexPath.row] as! NSDictionary
                print(dic)
                self.beerId = dic["restaurent_id"] as! String
                let barDetails = dic["bottleshop"] as! NSDictionary
                cell.beerName.text = barDetails["name"] as? String
                cell.beerAddress.text = barDetails["address"] as? String
                cell.lblRate.text = String((dic["rating"] as! NSNumber).floatValue)
                
                if (dic["review"] is NSNull){
                            cell.lblComment.text = ""
                }else{
                    let desstr = dic["review"] as? String
                    let snack = desstr?.removingHTMLEntities
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = .justified
                    
                    let str = snack?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    
                    let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraph]
                    let attrString = NSAttributedString(string:str!, attributes: attributes)
                    cell.lblComment.attributedText = attrString
                    
                    //cell.lblComment.text = textarray[indexPath.row] as? String
                    
                    cell.lblComment.numberOfLines = 0
                    cell.lblComment.lineBreakMode = NSLineBreakMode.byWordWrapping
                    cell.lblComment.layer.masksToBounds = true
                }
            }
            cell.index = indexPath.row
            cell.section = indexPath.section
            cell.delegate = self
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    
    //MARK:- Custom Delegate Method
    
    func BeerReviewTableViewCell(_ obj: BeerReviewTableViewCell, edit index: Int, section:Int){
        if fromBeerReview == true{
            let BeerDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerDetail") as! BeerDetailViewController
            let dic = self.dataArray[index] as! NSDictionary
            print(dic)
            self.beerId = dic["beer_id"] as! String
            print(self.beerId)
            BeerDetailViewController.beerID = self.beerId
            BeerDetailViewController.fromEdit = true
            self.navigationController?.pushViewController(BeerDetailViewController, animated: true)
        }
        else if fromMyBeer == true{
            let EditBreweryViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditBrewery") as! EditBreweryViewController
            EditBreweryViewController.fromBeer = true
            self.navigationController?.pushViewController(EditBreweryViewController, animated: true)
        }
        else if fromBarReview == true{
            let BeerDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetailViewController
            let dic = self.dataArray[index] as! NSDictionary
            print(dic)
            self.beerId = dic["restaurent_id"] as! String
            print(self.beerId)
            BeerDetailViewController.barID = self.beerId
            BeerDetailViewController.fromEditBar = true
            self.navigationController?.pushViewController(BeerDetailViewController, animated: true)
        }
        else if fromMyBar == true{
            let EditBreweryViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditBrewery") as! EditBreweryViewController
            EditBreweryViewController.fromAddBar = true
            self.navigationController?.pushViewController(EditBreweryViewController, animated: true)
        }
        if fromBottleReview == true{
            let BeerDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BottleshopDetail") as! BottleshopDetailViewController
            let dic = self.dataArray[index] as! NSDictionary
            print(dic)
            self.beerId = dic["restaurent_id"] as! String
            print(self.beerId)
            BeerDetailViewController.bottleID = self.beerId
            BeerDetailViewController.fromEditBottle = true
            self.navigationController?.pushViewController(BeerDetailViewController, animated: true)
        }
        else if fromMyBottle == true{
            let EditBreweryViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditBrewery") as! EditBreweryViewController
            EditBreweryViewController.fromAddBottleshop = true
            self.navigationController?.pushViewController(EditBreweryViewController, animated: true)
        }
        else if fromBrewery == true{
            let BreweryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreweryDetail") as! BreweryDetailViewController
            let dic = self.dataArray[index] as! NSDictionary
            print(dic)
            self.beerId = dic["_id"] as! String
            print(self.beerId)
            BreweryDetailViewController.breweryID = self.beerId
            self.navigationController?.pushViewController(BreweryDetailViewController, animated: true)
        }
    }
    
    func BeerReviewTableViewCell(_ obj: BeerReviewTableViewCell, details index: Int, section:Int){
        if fromBeerReview == true{
            let BeerDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerDetail") as! BeerDetailViewController
            let dic = self.dataArray[index] as! NSDictionary
            self.beerId = dic["beer_id"] as! String
            BeerDetailViewController.beerID = self.beerId
            BeerDetailViewController.fromBeerReview = true
            self.navigationController?.pushViewController(BeerDetailViewController, animated: true)
        }
        else if fromBarReview == true{
            let RestaurantDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetailViewController
            let dic = self.dataArray[index] as! NSDictionary
            self.beerId = dic["restaurent_id"] as! String
            RestaurantDetailViewController.barID = self.beerId
            self.navigationController?.pushViewController(RestaurantDetailViewController, animated: true)
        }
        else if fromBottleReview == true{
            let BottleshopDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BottleshopDetail") as! BottleshopDetailViewController
            let dic = self.dataArray[index] as! NSDictionary
            self.beerId = dic["restaurent_id"] as! String
            BottleshopDetailViewController.bottleID = self.beerId
            self.navigationController?.pushViewController(BottleshopDetailViewController, animated: true)
        }
        else if fromBrewery == true{
            let BreweryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreweryDetail") as! BreweryDetailViewController
            let dic = self.dataArray[index] as! NSDictionary
            self.beerId = dic["_id"] as! String
            print(self.beerId)
            BreweryDetailViewController.breweryID = self.beerId
            self.navigationController?.pushViewController(BreweryDetailViewController, animated: true)
        }
    }
    
    func BeerReviewTableViewCell(_ obj: BeerReviewTableViewCell, delete index: Int, section:Int){
        if fromBeerReview == true{
            let dic = self.dataArray[index] as! NSDictionary
            print(dic)
            self.beerId = dic["beer_id"] as! String
            print(self.beerId)
            self.ratingID = dic["_id"] as! String
            self.deleteRating()
        }
        else if fromBarReview == true{
            let dic = self.dataArray[index] as! NSDictionary
            print(dic)
            self.beerId = dic["restaurent_id"] as! String
            print(self.beerId)
            self.ratingID = dic["_id"] as! String
            self.deleteRating()
        }
        else if fromBottleReview == true{
            let dic = self.dataArray[index] as! NSDictionary
            print(dic)
            self.beerId = dic["restaurent_id"] as! String
            print(self.beerId)
            self.ratingID = dic["_id"] as! String
            self.deleteRating()
        }
    }
    
    //MARK:- Delete Comment Api Call
    
    func deleteRating(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "delete_bar_review"
        
        let newTodo: [String: Any] = ["rev_id": self.ratingID,"login_token": login_token,"bar_id":self.beerId]
        
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
                self.ratingID = " "
                self.beerId = ""
                self.pageNo = 0
                self.dataArray = NSMutableArray()
                self.viewWillAppear(true)
                SVProgressHUD.dismiss()
                
        }
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
