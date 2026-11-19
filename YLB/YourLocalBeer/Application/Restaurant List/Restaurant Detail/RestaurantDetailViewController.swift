//
//  RestaurantDetailViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 20/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import PopupDialog
import Alamofire
import SVProgressHUD
import SDWebImage
import HCSStarRatingView
import Toast_Swift
import JJFloatingActionButton

class RestaurantDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate,UITableViewDelegate,UITableViewDataSource,RestaurantDetailCollectionViewCellDelegate {

    //MARK:- Variable Declaration
    @IBOutlet weak var mainScrlView: UIScrollView!
    @IBOutlet weak var restaurantDetailPhotoCollectionView: UICollectionView!

    var ImagePicker = UIImagePickerController()
    var imageData:UIImage?
    var fromCamera = Bool()
    var cameraData : NSData?
    @IBOutlet weak var btnRestaurantReviewOutlet: UIButton!

    @IBOutlet weak var lblNoScore: UILabel!
    var toggleIsOn = Bool()
    var anonymousStatus = String()
    
    var BarName = String()
    var BarAddress = String()
    
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRestaurantAddress: UILabel!
    @IBOutlet weak var btnViewReview: UIButton!
    @IBOutlet weak var btnRateOutlet: UIButton!
    var barID = String()
    var addPhotoTapped = Bool()
    var logIndict = NSDictionary()
    var login_token = String()
    var dataArray = NSDictionary()
    var weekdays = NSMutableArray()
    var imageArray = NSMutableArray()
    var fileUrl = NSURL()
    @IBOutlet weak var tblBarDetail: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    var textarray = NSMutableArray()
    var mostRecentReview = NSMutableArray()
    var mostHelpfulReview = NSMutableArray()
    var mostRecentComment = NSMutableArray()
    var mostHelpfulComment = NSMutableArray()
    
    var ambienceValue = String()
    var qualityValue = String()
    var selectionValue = String()
    var staffValue = String()
    var foodValue = String()
    var value = String()
    var review_id = String()
    var review_comment = String()
    var ratingDic = NSMutableArray()
    var login_userID = String()
    var comment_userId = String()
    var likeList: [Int] = []
    var commentArray = NSMutableArray()
    @IBOutlet weak var viewRating: HCSStarRatingView!
    var fromBar = String()
    var fromEditBar = Bool()
    var quickRate = String()
    var Lat = Double()
    var Lng = Double()
    var locationManager:CLLocationManager!
    var userLat = Double()
    var userLng = Double()
    @IBOutlet weak var vwMiddle: UIView!
    @IBOutlet weak var vwHour: UIView!
    @IBOutlet weak var lblLocal: UILabel!
    @IBOutlet weak var lblGlobal: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRanking: UILabel!
    var bar_id = String()
    @IBOutlet weak var lblDesc: UILabel!
    var favouriteId = String()
    @IBOutlet weak var btnFavouriteOutlet: UIButton!
    @IBOutlet var lblType: UILabel!
    var imageName = String()
    var curr_index = NSInteger()
    var s = Bool()
    @IBOutlet var btnBackOutlet: UIButton!
    @IBOutlet var btnForwardOutlet: UIButton!
    var reportText = String()
    var reportTitle = String()
    fileprivate let actionButton = JJFloatingActionButton()
    
    
    
    //MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        login_userID = "\(logIndict .value(forKey: "user_id")!)"
        
        self.review_id = " "
        self.fromBar = "bar"
        
        self.lblLocal.layer.cornerRadius = 5
        self.lblLocal.clipsToBounds = true
        
        self.lblGlobal.layer.cornerRadius = 5
        self.lblGlobal.clipsToBounds = true
        
        
        btnViewReview.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        
        lblRestaurantName.text = BarName
        lblRestaurantAddress.text = BarAddress
        
        btnRateOutlet.layer.cornerRadius = 5
        self.tblBarDetail.rowHeight = UITableView.automaticDimension
        self.tblBarDetail.estimatedRowHeight = 50;
        
        actionButton.itemAnimationConfiguration = .circularSlideIn(withRadius: 120)
        actionButton.buttonAnimationConfiguration = .rotation(toAngle: .pi * 3 / 4)
        actionButton.buttonAnimationConfiguration.opening.duration = 0.8
        actionButton.buttonAnimationConfiguration.closing.duration = 0.6
        actionButton.buttonImage = UIImage(named: "four-grid")
        
        actionButton.addItem(image: #imageLiteral(resourceName: "location-circular")) { item in
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
            let currentAction = UIAlertAction(title: "", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in })
            alert.addAction(currentAction)
            self.mapActionSheet()
            self.present(alert, animated: true, completion: nil)
        }

        actionButton.addItem(image: #imageLiteral(resourceName: "camera")) { item in
            self.addPhotoTapped = true
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
            let currentAction = UIAlertAction(title: "", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in })
            alert.addAction(currentAction)
            self.customActionSheet()
            self.present(alert, animated: true, completion: nil)
        }

        actionButton.addItem(image: #imageLiteral(resourceName: "editDetail")) { item in
           let alertController = UIAlertController(title: "Attention", message: "You are being redirected to the website to add/edit details", preferredStyle: UIAlertController.Style.alert) //Replace

           // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
           let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
               (result : UIAlertAction) -> Void in

           }
           let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
               (result : UIAlertAction) -> Void in
               let EditBreweryViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditBrewery") as! EditBreweryViewController
               EditBreweryViewController.barId = self.barID
               EditBreweryViewController.fromBar = true
               self.navigationController?.pushViewController(EditBreweryViewController, animated: true)
           }
           alertController.addAction(cancelAction)
           alertController.addAction(okAction)
           
           self.present(alertController, animated: true, completion: nil)
        }

        actionButton.addItem(image: #imageLiteral(resourceName: "report")) { item in
            self.openReport()
        }

        actionButton.display(inViewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "magnifying-glass"), style:  UIBarButtonItem.Style.plain, target: self, action: #selector(RestaurantDetailViewController.barButtonClickAction))
        
        self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: 900)
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        login_userID = "\(logIndict .value(forKey: "user_id")!)"
        
        if self.addPhotoTapped == true{
            self.navigationItem.setHidesBackButton(true, animated:false);
        }else{
            self.navigationItem.setHidesBackButton(false, animated:false)
        }
        self.fetchBarDetail()
        self.determineMyCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Search Button Action
    @objc func barButtonClickAction() {
        print("Button click...")
        let SearchViewController = self.storyboard?.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        self.navigationController?.pushViewController(SearchViewController, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
//        tableHeightConstraint.constant = tblBarDetail.contentSize.height
//        super.updateViewConstraints()
//        self.tblBarDetail.frame = CGRect(x: self.tblBarDetail.frame.origin.x, y: self.tblBarDetail.frame.origin.y, width: self.tblBarDetail.frame.size.width, height: self.tblBarDetail.contentSize.height)
//        mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.restaurantDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + vwHour.frame.size.height + self.tblBarDetail.contentSize.height + 50)
    }
    
    func determineMyCurrentLocation() {
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                if #available(iOS 10.0, *) {
                    let alertController = UIAlertController(title: "Location Service Disabled",
                                                            message: "Location services are not enabled",
                                                            preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    
                    
                    let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    alertController.addAction(openAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // Fallback on earlier versions
                }
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager = CLLocationManager()
                //                        locationManager.delegate = self
                //                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                //                        locationManager.requestAlwaysAuthorization()
                
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.startUpdatingLocation()
                    //locationManager.startUpdatingHeading()
                }
            @unknown default:
                fatalError()
            }
        }else{
            let alertController = UIAlertController(title: "Location Service Disabled",
                                                    message: "Location services are not enabled",
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    } else {
                        //Fallback on earlier versions
                    }
                }
            }
            alertController.addAction(openAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        self.userLat = userLocation.coordinate.latitude
        self.userLng = userLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    //MARK:- Fetch Detail Api Call
    
    func fetchBarDetail(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "bar_details"
        
        let newTodo: [String: Any] = ["bar_id": barID,"login_token": login_token]
        
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
                self.dataArray = (json["details"] as! NSDictionary).mutableCopy() as! NSDictionary
                
                self.bar_id = (self.dataArray["_id"] as? String)!
                self.weekdays = (self.dataArray["hour_oparation"] as! NSArray ).mutableCopy() as! NSMutableArray
                
                self.lblRestaurantName.text = self.dataArray["name"] as? String
                
                self.lblRating.text = "\(String(describing: self.dataArray["hads"] as! Int)) Ratings"
                
                self.lblRanking.text = String("#\(self.dataArray["position"] as! Int) of \(self.dataArray["total_in_city"] as! Int) in \(self.dataArray["city"] as! String)")
                
                if (self.dataArray["favorite"] as? String) == nil || (self.dataArray["favorite"] as? String)!.isEmpty {
                    self.btnFavouriteOutlet.setImage(UIImage(named: "favourite"), for: .normal)
                }else{
                    self.favouriteId = (self.dataArray["favorite"] as? String)!
                    self.btnFavouriteOutlet.setImage(UIImage(named: "favouited"), for: .normal)
                }
                
                if ((self.dataArray["local_rating"] as? NSNumber)?.floatValue) == nil{
                    self.lblLocal.text = String(format: "  Local: %.1f", 0.0)
                }else{
                    self.lblLocal.text = String(format: "  Local: %.1f", ((self.dataArray["local_rating"] as! NSNumber).floatValue))
                }
                
                if ((self.dataArray["avgRate"] as? NSNumber)?.floatValue) == nil{
                    self.lblGlobal.text = String(format: "  Global: %.1f", 0.0)
                }else{
                    self.lblGlobal.text = String(format: "  Global: %.1f", ((self.dataArray["avgRate"] as! NSNumber).floatValue))
                }
                
                if let estabValue = (self.dataArray["establishment"] as? String){
                    self.lblType.text = "Type : \(estabValue)"
                }else{
                    self.lblType.text = "Type : N/A"
                }
                
                if (self.dataArray["state"] as? String) != nil && (self.dataArray["city"] as? String) != nil{
                    self.lblRestaurantAddress.text = "\((self.dataArray["address"] as? String)!),\((self.dataArray["city"] as? String)!),\((self.dataArray["state"] as? String)!),\((self.dataArray["country"] as? String)!)"
                }else if (self.dataArray["state"] as? String) == nil{
                    self.lblRestaurantAddress.text = "\((self.dataArray["address"] as? String)!),\((self.dataArray["city"] as? String)!),\((self.dataArray["country"] as? String)!)"
                }else{
                    self.lblRestaurantAddress.text = "\((self.dataArray["address"] as? String)!),\((self.dataArray["state"] as? String)!),\((self.dataArray["country"] as? String)!)"
                }
                
                if (self.dataArray["resturant_description"] as? String) != nil
                {
                    self.lblDesc.text = "Venue Details: \((self.dataArray["resturant_description"] as? String)!)"
                    
                    self.tblBarDetail.frame = CGRect(x: self.tblBarDetail.frame.origin.x, y: self.tblBarDetail.frame.origin.y, width: self.tblBarDetail.frame.size.width, height: self.tblBarDetail.contentSize.height)
                    
                    
                    self.vwMiddle.frame = CGRect(x: self.vwMiddle.frame.origin.x, y: self.vwMiddle.frame.origin.y, width: self.vwMiddle.frame.size.width, height: self.vwMiddle.frame.size.height)
                    
                    self.vwHour.frame = CGRect(x: self.vwHour.frame.origin.x, y: self.vwMiddle.frame.origin.y + self.vwMiddle.frame.size.height, width: self.vwHour.frame.size.width, height: self.vwHour.frame.size.height)
                    
                    
                    self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.restaurantDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + self.vwHour.frame.size.height + self.tblBarDetail.contentSize.height + 50)
                }
                else
                {
                    self.lblDesc.text = "Venue Details:"
                    
                    self.tblBarDetail.frame = CGRect(x: self.tblBarDetail.frame.origin.x, y: self.tblBarDetail.frame.origin.y, width: self.tblBarDetail.frame.size.width, height: self.tblBarDetail.contentSize.height)
                    
                    
                    self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.restaurantDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + self.vwHour.frame.size.height + self.tblBarDetail.contentSize.height + 50)
                }
                
                self.imageArray = (self.dataArray["resturant_images"] as! NSArray).mutableCopy() as! NSMutableArray
                self.imageArray = ((self.imageArray.reverseObjectEnumerator().allObjects) as NSArray).mutableCopy() as! NSMutableArray
                
            
                self.mostRecentReview = (self.dataArray["reviews"] as! NSArray).mutableCopy() as! NSMutableArray
                
                if self.mostRecentReview.count == 0 && self.mostHelpfulReview.count == 0{
                    self.btnViewReview.isHidden = true
                }else{
                    self.btnViewReview.isHidden = false
                }
                
                self.ratingDic = (self.dataArray["my_rating"] as! NSArray).mutableCopy() as! NSMutableArray
                
                let color = self.dataArray["color"] as? String
                
                if color == "G"{
                    self.viewRating.isHidden = false
                    self.lblNoScore.isHidden = true
                    self.viewRating.value = CGFloat(Float((self.dataArray["avgRate"] as! NSNumber).floatValue))
                }else if color == "Y"{
                    self.viewRating.isHidden = false
                    self.lblNoScore.isHidden = true
                    self.viewRating.value = CGFloat(Float((self.dataArray["avgRate"] as! NSNumber).floatValue))
                }else if color == "R"{
                    self.lblNoScore.isHidden = false
                    self.viewRating.isHidden = true
                    self.lblNoScore.backgroundColor = UIColor.red
                    self.lblNoScore.text = "No score yet"
                }
                
                let locdic = self.dataArray["location"] as! NSDictionary
                let coordinates = locdic["coordinates"] as! NSArray
                self.Lng = coordinates[0] as! double_t
                self.Lat = coordinates[1] as! double_t
                
                if self.fromEditBar == true{
                    self.openReview()
                }
                
                if self.ratingDic.count == 0{
                    self.review_id = " "
                    self.btnRateOutlet.isHidden = false
                }
                else{
                    self.btnRateOutlet.isHidden = true
                }
                
                self.restaurantDetailPhotoCollectionView.reloadData()
                self.tblBarDetail.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK: - TableView Deleagte/DataSource
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.weekdays.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblBarDetail.dequeueReusableCell(withIdentifier:"WeekDays", for: indexPath)as! BarWeekdaysTableViewCell
        
        let dic = self.weekdays[indexPath.row] as! NSDictionary
        
        cell.lblDaysName.text = dic["day_name"] as? String
        let status = dic["oprning_status"] as? String
        if status == "CLOSED"{
            cell.lblStatus.text = dic["oprning_status"] as? String
        }else if status == "OPEN"{
            if ((!(dic["from_time"] as? String)!.isEmpty) && (!(dic["to_time"] as? String)!.isEmpty)){
                cell.lblStatus.text = "\((dic["from_time"] as? String)!) - \((dic["to_time"] as? String)!)"
            }else{
                cell.lblStatus.text = "N/A"
            }
        }else{
            cell.lblStatus.text = "N/A"
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableHeightConstraint.constant = tblBarDetail.contentSize.height
        super.updateViewConstraints()
        
        self.tblBarDetail.frame = CGRect(x: self.tblBarDetail.frame.origin.x, y: self.tblBarDetail.frame.origin.y, width: self.tblBarDetail.frame.size.width, height: self.tblBarDetail.contentSize.height)
        
        self.vwMiddle.frame = CGRect(x: self.vwMiddle.frame.origin.x, y: self.vwMiddle.frame.origin.y, width: self.vwMiddle.frame.size.width, height: self.vwMiddle.frame.size.height)
        
        self.vwHour.frame = CGRect(x: self.vwHour.frame.origin.x, y: self.vwMiddle.frame.origin.y + self.vwMiddle.frame.size.height, width: self.vwHour.frame.size.width, height: self.vwHour.frame.size.height)
        
        self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.restaurantDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + self.vwHour.frame.size.height + self.tblBarDetail.contentSize.height + 50)
    }
    
    //MARK:- OPEN CAMERA METHODS
    func customActionSheet() {
        let myActionSheet = UIAlertController()
        let galleryAction = UIAlertAction(title: "OPEN GALLERY", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cmaeraAction = UIAlertAction(title: "TAKE PHOTO", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openCamera()
        })
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        myActionSheet.addAction(galleryAction)
        myActionSheet.addAction(cmaeraAction)
        myActionSheet.addAction(cancelAction)
        
        if let popoverController = myActionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        self.addPhotoTapped = true
        self.fromCamera = true
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            self.ImagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.ImagePicker.delegate = self
            self.ImagePicker.allowsEditing = true
            self.present(self.ImagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Camera is not supported", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        self.addPhotoTapped = true
        ImagePicker.delegate = self
        ImagePicker.allowsEditing = true
        ImagePicker.sourceType = .photoLibrary
        present(ImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if self.fromCamera == true{
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                imageData = pickedImage
                cameraData = imageData!.pngData() as NSData?
                UIImageWriteToSavedPhotosAlbum(imageData!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }else{
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                imageData = pickedImage
                cameraData = imageData!.pngData() as NSData?
            }
        }
        self.addPhotoTapped = false
        picker.dismiss(animated: true, completion: nil)
        self.openImageView()
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            // we got back an error!
            //            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            //            ac.addAction(UIAlertAction(title: "OK", style: .default))
            //            present(ac, animated: true)
        } else {
            //            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            //            ac.addAction(UIAlertAction(title: "OK", style: .default))
            //            present(ac, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: 20, height: 20))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //MARK:- Bottleshop Collection View Delegate/Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imageArray.count > 0{
            return self.imageArray.count
        }
        else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.imageArray.count == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantDetailCell", for: indexPath) as! RestaurantDetailCollectionViewCell
            cell.btnCameraOutlet.isHidden = false
            cell.btnCameraOutlet.isUserInteractionEnabled = true
            cell.btnDeleteOutlet.isHidden = true
            //cell.imgBrewery.image = UIImage(named: "no-image.jpg")
            cell.delegate = self
            cell.index = indexPath.row
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantDetailCell", for: indexPath) as! RestaurantDetailCollectionViewCell
            // Configure the cell
            let dic = self.imageArray[indexPath.row] as! NSDictionary
            if (self.imageArray.count == 0){
                cell.btnDeleteOutlet.isHidden = true
                cell.barImage.image = UIImage(named: "no-image.jpg")
            }else{
            if let id = dic["user_id"] as? NSNumber {
                if self.login_userID == id.stringValue{
                    cell.btnDeleteOutlet.isHidden = false
                    cell.btnCameraOutlet.isHidden = true
                    cell.btnCameraOutlet.isUserInteractionEnabled = false
                    let imageUrl = dic["name"] as! String
                    let fullUrl = imageUrl
                    self.fileUrl = NSURL(string: fullUrl)!
                    
                    cell.barImage.image = UIImage(named: "no-image.jpg")
                    
                    SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                        (receivedSize :Int, ExpectedSize :Int) in
                        
                    }, completed: {
                        (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                        cell.barImage.image = image
                    })
                }else{
                    cell.btnDeleteOutlet.isHidden = true
                    cell.btnCameraOutlet.isHidden = true
                    cell.btnCameraOutlet.isUserInteractionEnabled = false
                    let imageUrl = dic["name"] as! String
                    let fullUrl = imageUrl
                    self.fileUrl = NSURL(string: fullUrl)!
                    
                    cell.barImage.image = UIImage(named: "no-image.jpg")
                    
                    SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                        (receivedSize :Int, ExpectedSize :Int) in
                        
                    }, completed: {
                        (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                        cell.barImage.image = image
                    })
                }
            }else if let id = dic["user_id"] as? String {
                if self.login_userID == id{
                    cell.btnDeleteOutlet.isHidden = false
                    cell.btnCameraOutlet.isHidden = true
                    cell.btnCameraOutlet.isUserInteractionEnabled = false
                    let imageUrl = dic["name"] as! String
                    let fullUrl = imageUrl
                    self.fileUrl = NSURL(string: fullUrl)!
                    
                    cell.barImage.image = UIImage(named: "no-image.jpg")
                    
                    SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                        (receivedSize :Int, ExpectedSize :Int) in
                        
                    }, completed: {
                        (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                        cell.barImage.image = image
                    })
                }else{
                    cell.btnDeleteOutlet.isHidden = true
                    cell.btnCameraOutlet.isHidden = true
                    cell.btnCameraOutlet.isUserInteractionEnabled = false
                    let imageUrl = dic["name"] as! String
                    let fullUrl = imageUrl
                    self.fileUrl = NSURL(string: fullUrl)!
                    
                    cell.barImage.image = UIImage(named: "no-image.jpg")
                    
                    SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                        (receivedSize :Int, ExpectedSize :Int) in
                        
                    }, completed: {
                        (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                        cell.barImage.image = image
                    })
                }
            }
        }
        cell.delegate = self
        cell.index = indexPath.row
        return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == restaurantDetailPhotoCollectionView{
            return CGSize(width: restaurantDetailPhotoCollectionView.frame.size.width , height:  restaurantDetailPhotoCollectionView.frame.size.height)
        }
        return CGSize(width: 1 , height:  1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //MARK:- Custom Delegate/Datasource
    
    func RestaurantDetailCollectionViewCell(_ obj: RestaurantDetailCollectionViewCell, camera index: Int){
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.customActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
    func RestaurantDetailCollectionViewCell(_ obj: RestaurantDetailCollectionViewCell, delete index: Int){
        let alertController = UIAlertController(title: "Do you want to delete the image?", message: nil, preferredStyle: UIAlertController.Style.alert) //Replace
                            
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            let dic = self.imageArray[index] as! NSDictionary
            let fullName    = dic["name"] as? String
            let fullNameArr = fullName!.components(separatedBy: "resturants/")
            self.imageName = fullNameArr[1]
            
            if let id = dic["user_id"] as? NSNumber {
                if self.login_userID == id.stringValue{
                    self.deleteImage()
                }
            }
            else if let id = dic["user_id"] as? String {
                if self.login_userID == id{
                    self.deleteImage()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel) {
        (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if self.imageArray.count == 0{
            btnForwardOutlet.isHidden = true
            btnBackOutlet.isHidden = true
        }else{
            if self.imageArray.count == 1 {
                btnForwardOutlet.isHidden = true
                btnBackOutlet.isHidden = true
            }
            else if curr_index == self.imageArray.count - 1 {
                btnForwardOutlet.isHidden = true
                btnBackOutlet.isHidden = false
            }
            else if curr_index == 0 {
                btnBackOutlet.isHidden = true
                btnForwardOutlet.isHidden = false
            }
            else {
                curr_index = indexPath.row
                btnForwardOutlet.isHidden = false
                btnBackOutlet.isHidden = false
            }
        }
    }
    
    //MARK:- Button Previous Action
    @IBAction func btnPreviousDidTap(_ sender: Any) {
        print(curr_index)
        s = curr_index > 0;
        print(s)
        if(s){
            curr_index = curr_index - 1
            let indexPath = IndexPath(row: curr_index, section: 0)
            restaurantDetailPhotoCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }
    }
    
    //MARK:- Button Forward Action
    @IBAction func btnForwardDidTap(_ sender: Any) {
       s = curr_index < (self.imageArray.count - 1)
       print(s)
       if(s){
           curr_index = curr_index + 1
           let indexPath = IndexPath(row: curr_index, section: 0)
           restaurantDetailPhotoCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
       }
    }
    
    //MARK:- Api call for image delete
    
    func deleteImage(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "delete-bar-photos"
        
        let newTodo: [String: Any] = ["container_id": barID,"login_token": login_token,"img_name": self.imageName]
        
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
                self.fetchBarDetail()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Give Review Api Call
    
    func giveReview(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        let todosEndpoint: String = BASE_URL + "bar_review"
        
        let newTodo: [String: Any] = ["restaurent_id": barID,"login_token": login_token,"ambience": self.ambienceValue,"quality": self.qualityValue,"selection": self.selectionValue,"staffservice": self.staffValue,"food": self.foodValue,"value": self.value,"rev_id": self.review_id,"description":self.review_comment,"anonymous":self.anonymousStatus,"quickRating":self.quickRate]
        
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    //print("Error: \(response.result.error as! NSString)")
                    SVProgressHUD.dismiss()
                    return
                }
                
               if let id = json["reward_point"] as? NSNumber {
                   self.view.makeToast("Congratulations!! You have just earned \(id.stringValue) points", duration: 3.0, position: .bottom)
                   self.comment_userId = id.stringValue
                }
                else if let id = json["reward_point"] as? String {
                   self.view.makeToast("Congratulations!! You have just earned \(id) points", duration: 3.0, position: .bottom)
                }
                self.fetchBarDetail()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Brewery Image Upload
    
    func uploadImage(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "Uploading photo...")
        
        let imgData = self.imageData!.jpegData(compressionQuality: 0.5)!
        
        let parameters: Parameters = [
            "login_token" : "\(login_token)",
            "image_of": "restaurant",
            "container_id": "\(barID)"
        ]
        let myUrl = URL(string: BASE_URL + "add_photos");
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key,value) in parameters {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(imgData, withName: "image_file", fileName: "image_file.jpeg", mimeType: "image/jpeg")
        }, to: myUrl!, method: .post,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    guard let json = response.result.value as? [String: Any] else {
                        print(response)
                        print("didn't get todo object as JSON from API")
                        //print("Error: \(response.result.error as! NSString)")
                        SVProgressHUD.dismiss()
                        return
                    }
                    
                    print("JSON: \(json)")
                    
                    if (((json["status"] as! NSNumber).intValue) == 1){
                        let alert = UIAlertController(title: "Your Local Beer", message: "Your image has been uploaded successfully.", preferredStyle: UIAlertController.Style.alert)
                        let currentAction = UIAlertAction(title: "Dismiss", style: .default, handler: {
                            (alert: UIAlertAction!) -> Void in })
                        alert.addAction(currentAction)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Your Local Beer", message: "Failed to upload your image.", preferredStyle: UIAlertController.Style.alert)
                        let currentAction = UIAlertAction(title: "Dismiss", style: .default, handler: {
                            (alert: UIAlertAction!) -> Void in })
                        alert.addAction(currentAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    if let id = json["reward_point"] as? NSNumber {
                       self.view.makeToast("Congratulations!! You have just earned \(id.stringValue) points", duration: 3.0, position: .bottom)
                       self.comment_userId = id.stringValue
                    }
                    else if let id = json["reward_point"] as? String {
                       self.view.makeToast("Congratulations!! You have just earned \(id) points", duration: 3.0, position: .bottom)
                    }
                    self.actionButton.close()
                    self.fetchBarDetail()
                    SVProgressHUD.dismiss()
                }
            case .failure(let encodingError):
                print("error:\(encodingError)")
                SVProgressHUD.dismiss()
            }
        })
    }
    
    @IBAction func btnRestaurantReviewToggle(_ sender: Any) {
        toggleIsOn = !toggleIsOn;
        if(toggleIsOn){
            //do anything else you want to do.
            self.btnRestaurantReviewOutlet.setImage(UIImage(named:"checked.png"), for:.normal);
            self.anonymousStatus = "Y"
        }
        else {
            //do anything you want to do.
            self.btnRestaurantReviewOutlet.setImage(UIImage(named:"unchecked.png"), for:.normal);
            self.anonymousStatus = "N"
        }
    }
    
    //MARK:- OPEN MAP METHODS
    func mapActionSheet() {
        let myActionSheet = UIAlertController()
        let googleAction = UIAlertAction(title: "Google Maps", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGoogleMap()
        })
        let appleAction = UIAlertAction(title: "Apple Maps", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openAppleMap()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        myActionSheet.addAction(googleAction)
        myActionSheet.addAction(appleAction)
        myActionSheet.addAction(cancelAction)
        
        if let popoverController = myActionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func openGoogleMap() {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            let url = URL(string:"comgooglemaps://?saddr=\(self.userLat),\(self.userLng)&daddr=\(Lat),\(Lng)&directionsmode=driving")
            UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
                let url = URL(string:"http://maps.apple.com/?daddr=\(Lat),\(Lng)&saddr=\(self.userLat),\(self.userLng)")
                UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                NSLog("Can't use Apple Maps");
            }
            NSLog("Can't use Google Maps");
        }
    }
    
    func openAppleMap() {
        if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
            let url = URL(string:"http://maps.apple.com/?daddr=\(Lat),\(Lng)&saddr=\(self.userLat),\(self.userLng)")
            UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            NSLog("Can't use Apple Maps");
        }
    }
    
    //MARK:- Rate button action
    @IBAction func btnRateDidTap(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.rateActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- OPEN RATE METHODS
    func rateActionSheet() {
        let myActionSheet = UIAlertController()
        myActionSheet.view.layer.cornerRadius = 25
        
        let googleAction = UIAlertAction(title: "Quick Rate", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openRateView()
        })
        let appleAction = UIAlertAction(title: "Review", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openReview()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        myActionSheet.addAction(googleAction)
        myActionSheet.addAction(appleAction)
        myActionSheet.addAction(cancelAction)
        
        if let popoverController = myActionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    func openRateView(){
        
        // Create a custom view controller
        let rateVC = RateViewController(nibName: "RateViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: rateVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //self.label.text = "You canceled the rating dialog"
            //rateVC.textFieldShouldReturn(rateVC.commentTextField)
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "SAVE", height: 60) {
            //self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
            print(rateVC.lblAppearanceValue.text!)
            
            self.quickRate = rateVC.lblAppearanceValue.text!
            self.anonymousStatus = rateVC.anonymousStatus
            
            self.giveReview()
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    func openReview(){
        // Create a custom view controller
        let rateVC = BottleshopRateViewController(nibName: "BottleshopRateViewController", bundle: nil)
        rateVC.fromBottleBeer = self.fromBar
        
        // Create the dialog
        let popup = PopupDialog(viewController: rateVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //self.label.text = "You canceled the rating dialog"
            //rateVC.textFieldShouldReturn(rateVC.commentTextField)
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "SAVE", height: 60) {
            //self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
            print(rateVC.lblAmbienceValue.text!)
            print(rateVC.lblQualityValue.text!)
            print(rateVC.lblSelectionValue.text!)
            print(rateVC.lblStaffValue.text!)
            print(rateVC.lblFoodValue.text!)
            print(rateVC.lblValue.text!)
            print(rateVC.anonymousStatus)
            
            self.ambienceValue = rateVC.lblAmbienceValue.text!
            self.qualityValue = rateVC.lblQualityValue.text!
            self.selectionValue = rateVC.lblSelectionValue.text!
            self.staffValue = rateVC.lblStaffValue.text!
            self.foodValue = rateVC.lblFoodValue.text!
            self.value = rateVC.lblValue.text!
            self.review_comment = rateVC.txtComment.text!
            self.anonymousStatus = rateVC.anonymousStatus
            
            self.giveReview()
        }
        
        if (self.ratingDic.count == 0){
            
        }else{
            let dic = self.ratingDic[0] as! NSDictionary
            print(dic)
            
            self.review_id = (dic["_id"] as? String)!
            
            if dic["ambience"] as? String != nil{
                rateVC.lblAmbienceValue.text = (dic["ambience"] as? String)!
                rateVC.ambienceView.value = CGFloat(Float(dic["ambience"] as! String)!)
            }
            if dic["quality"] as? String != nil{
                rateVC.lblQualityValue.text = (dic["quality"] as? String)!
                rateVC.qualityView.value = CGFloat(Float(dic["quality"] as! String)!)
            }
            if dic["selection"] as? String != nil{
                rateVC.lblSelectionValue.text = (dic["selection"] as? String)!
                rateVC.selectionView.value = CGFloat(Float(dic["selection"] as! String)!)
            }
            if dic["staffservice"] as? String != nil{
                rateVC.lblStaffValue.text = (dic["staffservice"] as? String)!
                rateVC.staffView.value = CGFloat(Float(dic["staffservice"] as! String)!)
            }
            if dic["food"] as? String != nil{
                rateVC.lblFoodValue.text = (dic["food"] as? String)!
                rateVC.foodView.value = CGFloat(Float(dic["food"] as! String)!)
            }
            if dic["value"] as? String != nil{
                rateVC.lblValue.text = (dic["value"] as? String)!
                rateVC.valueView.value = CGFloat(Float(dic["value"] as! String)!)
            }
            if dic["review"] as? String != nil{
                let desstr = dic["review"] as? String
                let snack = desstr?.removingHTMLEntities
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified
                
                let str = snack?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraph]
                let attrString = NSAttributedString(string:str!, attributes: attributes)
                rateVC.txtComment.attributedText = attrString
            }
            
            if self.fromEditBar == true{
                rateVC.lblStaticReviewText.text = "Edit Review"
            }
            else{
                rateVC.lblStaticReviewText.text = "Add Review"
            }
            
            self.fromEditBar = false
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    //MARK:- View Review Button Action
    
    @IBAction func btnViewReview(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Application", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PopOver") as! PopOverViewController
        controller.reviews = self.mostRecentReview
        controller.fromBottleBeer = self.fromBar
        let navController = UINavigationController(rootViewController: controller) // Creating a navigation controller with VC1 at the root of the navigation stack.
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    //MARK:- Address Button Action
    @IBAction func btnAddressDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.mapActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Favourite Button Action
    @IBAction func btnFavouriteDidTap(_ sender: Any) {
        if (self.dataArray["favorite"] as? String) == nil || (self.dataArray["favorite"] as? String)!.isEmpty{
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.clear)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show(withStatus: "It's working...")
            let todosEndpoint: String = BASE_URL + "save-search"
            
            let newTodo: [String: Any] = ["login_token": login_token,"category": "bar","place_id": barID]
            
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
                    self.view.makeToast("Saved", duration: 3.0, position: .bottom)
                    self.fetchBarDetail()
                    SVProgressHUD.dismiss()
            }
            
        }else{
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.clear)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show(withStatus: "It's working...")
            let todosEndpoint: String = BASE_URL + "delete-search"
            
            let newTodo: [String: Any] = ["login_token": login_token,"search_id": self.favouriteId,"place_id":""]
            
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
                    self.view.makeToast("Removed from Saved Places", duration: 3.0, position: .bottom)
                    self.fetchBarDetail()
                    SVProgressHUD.dismiss()
                    
            }
        }
    }
    
    //MARK:- Report Method
    
    func openReport(){
        // Create a custom view controller
        let reportVC = ReportViewController(nibName: "ReportViewController", bundle: nil)
                
        // Create the dialog
        let popup = PopupDialog(viewController: reportVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //self.label.text = "You canceled the rating dialog"
            //reviewVC.textFieldShouldReturn(reviewVC.commentTextField)
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "REPORT", height: 60) {
            //self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
            //self.label.text = ratingVC.commentTextField.text
            //print(reviewVC.commentTextField.text!)
            self.reportText = reportVC.txtReportText.text!
            self.reportTitle = reportVC.txtHeader.text!
            
            if(reportVC.txtReportText.text!.count == 0 || (reportVC.txtReportText.text?.trimmingCharacters(in: .whitespaces).isEmpty)!){
                let alertController = UIAlertController(title: "Error", message: "Cannot report without valid reason", preferredStyle: UIAlertController.Style.alert) //Replace
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    (result : UIAlertAction) -> Void in
                    self.openReport()
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                self.apiCallToReport()
            }
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    //MARK:- Api Call to Report
        
    func apiCallToReport(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "report"
        
        let newTodo: [String: Any] = ["login_token": login_token,"category": "bar","field_id": self.barID,"description": self.reportText,"title": self.reportTitle]
        
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
                self.view.makeToast(json["message"] as? String, duration: 3.0, position: .bottom)
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Image Upload View
    
    func openImageView(){
        // Create a custom view controller
        let imageVC = ImageUploadViewController(nibName: "ImageUploadViewController", bundle: nil)
                
        // Create the dialog
        let popup = PopupDialog(viewController: imageVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //self.label.text = "You canceled the rating dialog"
            //reviewVC.textFieldShouldReturn(reviewVC.commentTextField)
            self.actionButton.close()
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "UPLOAD", height: 60) {
            //self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
            //self.label.text = ratingVC.commentTextField.text
            //print(reviewVC.commentTextField.text!)
            self.uploadImage()
        }
        
        imageVC.vwUploadedImage.image = self.imageData
        imageVC.vwUploadedImage.contentMode = .scaleAspectFill
        imageVC.vwUploadedImage.clipsToBounds = true
        
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
