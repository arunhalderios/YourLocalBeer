//
//  PhotoListViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 13/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SDWebImage

class PhotoListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,PhotoListCollectionViewCellDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    var fromBeer = Bool()
    var fromBar = Bool()
    var fromBottle = Bool()
    var fromBrewery = Bool()
    
    var breweryImage = NSMutableArray()
    var beerImage = NSMutableArray()
    var barImage = NSMutableArray()
    var bottleImage = NSMutableArray()
    var logIndict = NSDictionary()
    var login_token = String()
    var dataArray = NSMutableArray()
    var pageNo = Int()
    var totalPageCount = Int()
    var fileUrl = NSURL()
    var brewery_id = String()
    var beer_id = String()
    var bottle_id = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        if fromBeer == true{
            self.apiCallMyBeerPhoto()
        }
        else if fromBar == true{
            self.apiCallMyBarPhoto()
        }
        else if fromBrewery == true{
            self.apiCallMyBreweryPhoto()
        }
        else if fromBottle == true{
            self.apiCallMyBottlePhoto()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        //print("UserDict: == \(logIndict)")
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        print(login_token)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Beer Photo Api Call
    
    func apiCallMyBeerPhoto(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_photos"
        
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
                let listPageArr = json["photos"] as! NSArray
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
                        let arrConcert = (json["photos"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.photoCollectionView.delegate = self
                        self.photoCollectionView.dataSource = self
                        self.photoCollectionView.reloadData()
                    }
                }
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Bar Photo Api Call
    
    func apiCallMyBarPhoto(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_photos"
        
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
                let listPageArr = json["photos"] as! NSArray
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
                        let arrConcert = (json["photos"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.photoCollectionView.delegate = self
                        self.photoCollectionView.dataSource = self
                        self.photoCollectionView.reloadData()
                    }
                }
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Brewery Photo Api Call
    
    func apiCallMyBreweryPhoto(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_photos"
        
        let newTodo: [String: Any] = ["login_token": login_token,"type": "brewery","page_number":pageNo]
        
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
                let listPageArr = json["photos"] as! NSArray
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
                        let arrConcert = (json["photos"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.photoCollectionView.delegate = self
                        self.photoCollectionView.dataSource = self
                        self.photoCollectionView.reloadData()
                    }
                }
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Bottle Photo Api Call
    
    func apiCallMyBottlePhoto(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_photos"
        
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
                let listPageArr = json["photos"] as! NSArray
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
                        let arrConcert = (json["photos"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.photoCollectionView.delegate = self
                        self.photoCollectionView.dataSource = self
                        self.photoCollectionView.reloadData()
                    }
                }
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
        if fromBrewery == true{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoListCollectionViewCell
            // Configure the cell
            
            let dic = self.dataArray[indexPath.row] as! NSDictionary
            print(dic)
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 1
            cell.layer.shadowOffset = CGSize(width: -1, height: 1)
            let borderColor: UIColor = UIColor.lightGray
            cell.layer.borderColor = borderColor.cgColor
            
            if (dic["img_name"] is NSNull){
                //            cell.imageVWCell.image = placeholderImage
            }else{
                let imageUrl = dic["img_name"] as! String
                let fullUrl = imageUrl
                self.fileUrl = NSURL(string: fullUrl)!
                
                cell.photoImage.image = UIImage(named: "placeholder.png")
                
                SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                    (receivedSize :Int, ExpectedSize :Int) in
                    
                }, completed: {
                    (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                    cell.photoImage.image = image
                })
            }
            cell.delegate = self
            let beerDetails = dic["brewery"] as! NSDictionary
            self.brewery_id = (beerDetails["id"] as? String)!
            cell.lblName.text = beerDetails["name"] as? String
            cell.lblName.numberOfLines = 0
            cell.lblName.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.lblName.layer.masksToBounds = true
            cell.index = indexPath.row
            return cell
        }else if fromBar == true{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoListCollectionViewCell
            // Configure the cell
            let dic = self.dataArray[indexPath.row] as! NSDictionary
            print(dic)
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 1
            cell.layer.shadowOffset = CGSize(width: -1, height: 1)
            let borderColor: UIColor = UIColor.lightGray
            cell.layer.borderColor = borderColor.cgColor
            
            if (dic["img_name"] is NSNull){
                //            cell.imageVWCell.image = placeholderImage
            }else{
                let imageUrl = dic["img_name"] as! String
                let fullUrl = imageUrl
                self.fileUrl = NSURL(string: fullUrl)!
                
                cell.photoImage.image = UIImage(named: "placeholder.png")
                
                SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                    (receivedSize :Int, ExpectedSize :Int) in
                    
                }, completed: {
                    (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                    cell.photoImage.image = image
                })
            }
            cell.delegate = self
            let beerDetails = dic["beer"] as! NSDictionary
            cell.lblName.text = beerDetails["name"] as? String
            cell.lblName.numberOfLines = 0
            cell.lblName.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.lblName.layer.masksToBounds = true
            cell.index = indexPath.row
            return cell
        }else if fromBeer == true{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoListCollectionViewCell
            // Configure the cell
            let dic = self.dataArray[indexPath.row] as! NSDictionary
            print(dic)
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 1
            cell.layer.shadowOffset = CGSize(width: -1, height: 1)
            let borderColor: UIColor = UIColor.lightGray
            cell.layer.borderColor = borderColor.cgColor
            
            if (dic["img_name"] is NSNull){
                //            cell.imageVWCell.image = placeholderImage
            }else{
                let imageUrl = dic["img_name"] as! String
                let fullUrl = imageUrl
                self.fileUrl = NSURL(string: fullUrl)!
                
                cell.photoImage.image = UIImage(named: "placeholder.png")
                
                SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                    (receivedSize :Int, ExpectedSize :Int) in
                    
                }, completed: {
                    (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                    cell.photoImage.image = image
                    cell.photoImage.clipsToBounds = true
                    cell.photoImage.contentMode = .scaleAspectFill
                })
            }
            cell.delegate = self
            let beerDetails = dic["beer"] as! NSDictionary
            self.beer_id = (beerDetails["id"] as? String)!
            cell.lblName.text = beerDetails["name"] as? String
            cell.lblName.numberOfLines = 0
            cell.lblName.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.lblName.layer.masksToBounds = true
            cell.index = indexPath.row
            return cell
        }else if fromBottle == true{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoListCollectionViewCell
            // Configure the cell
            let dic = self.dataArray[indexPath.row] as! NSDictionary
            print(dic)
            let beerDetails = dic["bottleshop"] as! NSDictionary
            self.bottle_id = (beerDetails["id"] as? String)!
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 1
            cell.layer.shadowOffset = CGSize(width: -1, height: 1)
            let borderColor: UIColor = UIColor.lightGray
            cell.layer.borderColor = borderColor.cgColor
            
            if (dic["img_name"] is NSNull){
                //            cell.imageVWCell.image = placeholderImage
            }else{
                let imageUrl = dic["img_name"] as! String
                let fullUrl = imageUrl
                self.fileUrl = NSURL(string: fullUrl)!
                
                cell.photoImage.image = UIImage(named: "placeholder.png")
                
                SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                    (receivedSize :Int, ExpectedSize :Int) in
                    
                }, completed: {
                    (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                    cell.photoImage.image = image
                })
            }
            cell.delegate = self
            cell.lblName.text = beerDetails["name"] as? String
            cell.lblName.numberOfLines = 0
            cell.lblName.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.lblName.layer.masksToBounds = true
            cell.index = indexPath.row
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //return CGSize(width: photoCollectionView.frame.size.width/2-8 , height:  photoCollectionView.frame.size.height/2-5)
        return CGSize(width: photoCollectionView.frame.size.width/2-8 , height:  photoCollectionView.frame.size.height/2-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    //MARK:- Collectionview Delegate 
    func PhotoListCollectionViewCell(_ obj: PhotoListCollectionViewCell, more index: Int){
        if fromBeer == true{
            let BeerDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerDetail") as! BeerDetailViewController
            BeerDetailViewController.beerID = self.beer_id
            self.navigationController?.pushViewController(BeerDetailViewController, animated: true)
        }
        else if fromBar == true{
            let BarDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetailViewController
            self.navigationController?.pushViewController(BarDetailViewController, animated: true)
        }
        else if fromBottle == true{
            let BeerDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BottleshopDetail") as! BottleshopDetailViewController
            BeerDetailViewController.bottleID = self.bottle_id
            self.navigationController?.pushViewController(BeerDetailViewController, animated: true)
        }
        else if fromBrewery == true{
            let BreweryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreweryDetail") as! BreweryDetailViewController
            BreweryDetailViewController.breweryID = self.brewery_id
            self.navigationController?.pushViewController(BreweryDetailViewController, animated: true)
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
