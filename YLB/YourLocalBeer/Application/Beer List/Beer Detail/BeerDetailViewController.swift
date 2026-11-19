//
//  BeerDetailViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView
import PopupDialog
import Alamofire
import SVProgressHUD
import SDWebImage
import CoreLocation
import UICircularProgressRing
import JJFloatingActionButton

class BeerDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,BeerDetailTableViewCellDelegate,CLLocationManagerDelegate,BeerDetailCollectionViewCellDelegate {

    //MARK:- Variable declaration
    
    @IBOutlet weak var mainScrlView: UIScrollView!
    @IBOutlet weak var beerDetailPhotoCollectionView: UICollectionView!

    var ImagePicker = UIImagePickerController()
    var imageData:UIImage?
    var fromCamera = Bool()
    var cameraData : NSData?
    var toggleIsOn = Bool()
    var anonymousStatus = String()
    
    @IBOutlet weak var tblCommentList: UITableView!
    @IBOutlet weak var vwMiddle: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnRateOutlet: UIButton!
    
    @IBOutlet weak var btnMostRecent: UIButton!
    @IBOutlet weak var btnMostHelpful: UIButton!
    var BeerName = String()
    var BreweryName = String()
    var Style = String()
    
    @IBOutlet weak var lblBeerName: UILabel!
    @IBOutlet weak var lblBreweryName: UILabel!
    @IBOutlet weak var lblStyle: UILabel!
    
    var beerID = String()
    var dataArray = NSDictionary()
    @IBOutlet weak var lblABV: UILabel!
    
    @IBOutlet weak var viewRating: HCSStarRatingView!
    var imageArray = NSMutableArray()
    var logIndict = NSDictionary()
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    var fileUrl = NSURL()
    var textarray = NSMutableArray()
    var mostRecentReview = NSMutableArray()
    var mostHelpfulReview = NSMutableArray()
    var mostRecentComment = NSMutableArray()
    var mostHelpfulComment = NSMutableArray()
    var isHelpful = Bool()
    var fromBarReview = Bool()
    var fromBeerReview = Bool()
    var login_token = String()
    var addPhotoTapped = Bool()
    
    var appearanceValue = String()
    var aromaValue = String()
    var mouthValue = String()
    var tasteValue = String()
    var overallValue = String()
    var drinkValue = String()
    var review_id = String()
    var review_comment = String()
    var ratingDic = NSMutableArray()
    var login_userID = String()
    var comment_userId = String()
    var likeList: [Int] = []
    var commentArray = NSMutableArray()
    var quickRate = String()
    var Lat = Double()
    var Lng = Double()
    var locationManager:CLLocationManager!
    var userLat = Double()
    var userLng = Double()
    @IBOutlet weak var lblNoScore: UILabel!
    var breweryID = String()
    @IBOutlet weak var lblLocal: UILabel!
    @IBOutlet weak var lblGlobal: UILabel!
    @IBOutlet weak var lblTotalRating: UILabel!
    var fromEdit = Bool()
    var beerId = String()
    @IBOutlet weak var lblDesc: UILabel!
    var progressRing = UICircularProgressRing()
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
        print(logIndict)
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        login_userID = String(logIndict["user_id"] as! Int)
        
        self.isHelpful = false
        self.fetchBeerDetail()
        self.review_id = " "
        
        self.lblLocal.layer.cornerRadius = 5
        self.lblLocal.clipsToBounds = true
        
        self.lblGlobal.layer.cornerRadius = 5
        self.lblGlobal.clipsToBounds = true
        
        self.addPhotoTapped = false
        
        // Do any additional setup after loading the view.
        
        btnRateOutlet.layer.cornerRadius = 5
        btnRateOutlet.layer.borderColor = UIColor.red.cgColor
        btnRateOutlet.layer.borderWidth = 1.0
        btnRateOutlet.layer.masksToBounds = true
        
        btnMostRecent.layer.cornerRadius = 5
        btnMostHelpful.layer.cornerRadius = 5
                
        self.tblCommentList.rowHeight = UITableView.automaticDimension
        self.tblCommentList.estimatedRowHeight = 180;
        
        lblBeerName.text = BeerName
        lblBreweryName.text = BreweryName
        lblStyle.text = Style
        
        actionButton.itemAnimationConfiguration = .circularSlideIn(withRadius: 120)
        actionButton.buttonAnimationConfiguration = .rotation(toAngle: .pi * 3 / 4)
        actionButton.buttonAnimationConfiguration.opening.duration = 0.8
        actionButton.buttonAnimationConfiguration.closing.duration = 0.6
        actionButton.buttonImage = UIImage(named: "four-grid")
        
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
               EditBreweryViewController.beerID = self.beerID
               EditBreweryViewController.fromBeer = true
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "magnifying-glass"), style:  UIBarButtonItem.Style.plain, target: self, action: #selector(BeerDetailViewController.barButtonClickAction))
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        
        login_token = "\(logIndict .value(forKey: "login_token")!)"
        login_userID = String(logIndict["user_id"] as! Int)
        
        if self.addPhotoTapped == true{
            self.navigationItem.setHidesBackButton(true, animated:false);
        }else{
            self.navigationItem.setHidesBackButton(false, animated:false)
        }
        
        self.determineMyCurrentLocation()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        //tableHeightConstraint.constant = tblCommentList.contentSize.height
//        super.updateViewConstraints()
//        self.tblCommentList.frame = CGRect(x: self.tblCommentList.frame.origin.x, y: self.tblCommentList.frame.origin.y, width: self.tblCommentList.frame.size.width, height: self.tblCommentList.contentSize.height)
//
//        //self.vwMiddle.frame = CGRect(x: self.vwMiddle.frame.origin.x, y: self.vwMiddle.frame.origin.y, width: self.vwMiddle.frame.size.width, height: self.lblDesc.frame.size.height)
//
//        mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.beerDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + vwBottom.frame.size.height + self.tblCommentList.contentSize.height + 50)
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
                //      print("Access")
                locationManager = CLLocationManager()
                //                        locationManager.delegate = self
                //                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                //                        locationManager.requestAlwaysAuthorization()
                
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.startUpdatingLocation()
                    //locationManager.startUpdatingHeading()
                }
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
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.userLat = userLocation.coordinate.latitude
        self.userLng = userLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    //MARK:- Fetch Detail Api Call
    
    func fetchBeerDetail(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "beer_details"
        
        let newTodo: [String: Any] = ["beer_id": beerID,"login_token": login_token]
        
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
                self.dataArray = (json["details"] as! NSDictionary).mutableCopy() as! NSDictionary
                
                if (self.dataArray["beer_description"] as? String) != nil{
                //if (self.dataArray["beer_description"] as? String)!.isEmpty{
                    self.lblDesc.text = "Commercial Description: \((self.dataArray["beer_description"] as? String)!)"
                    
                    self.tblCommentList.frame = CGRect(x: self.tblCommentList.frame.origin.x, y: self.tblCommentList.frame.origin.y, width: self.tblCommentList.frame.size.width, height: self.tblCommentList.contentSize.height)
                    
                    self.vwMiddle.frame = CGRect(x: self.vwMiddle.frame.origin.x, y: self.vwMiddle.frame.origin.y, width: self.vwMiddle.frame.size.width, height: self.vwMiddle.frame.size.height)
                    
                    self.vwBottom.frame = CGRect(x: self.vwBottom.frame.origin.x, y: self.vwMiddle.frame.origin.y + self.vwMiddle.frame.size.height, width: self.vwBottom.frame.size.width, height: self.vwBottom.frame.size.height)
                    
                    
//                    self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.beerDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + self.vwBottom.frame.size.height + self.tblCommentList.contentSize.height + 50)
                    
                }else{
//                    self.lblDesc.text = "Commercial Description: According to most sources, Lorum Ipsum can be traced back to a text composed by Cicero in 45 BC. Allegedly, a Latin scholar established the origin of the text by compiling all the instances of the unusual word 'consectetur' he could find and eventually recognized it as a passage from 'De finibus bonorum et malorum' (On the extremes of Good and Evil) by Cicero, a book that was very popular in the Middle Ages: Neque porro quisquam est, qui dolorem ipsum, quia dolor sit, amet, consectetur, adipisci velit...  (Approximately: Nor is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain...). A typical Lorem Ipsum text goes like this: Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim ....It seems that only fragments of the original text remain in the Lorem Ipsum texts used today. One may speculate that over the course of time certain letters were added or deleted at various positions within the text. This might also explain why one can now find slightly different versions. Due to the age of the Lorem Ipsum text there are no copyright issues to contend with."
                    
                    self.lblDesc.text = "Commercial Description:"
                    
                    self.tblCommentList.frame = CGRect(x: self.tblCommentList.frame.origin.x, y: self.tblCommentList.frame.origin.y, width: self.tblCommentList.frame.size.width, height: self.tblCommentList.contentSize.height)
                    
//                    self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.beerDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + self.vwBottom.frame.size.height + self.tblCommentList.contentSize.height + 50)
                }
                
                
                self.beerId = (self.dataArray["_id"] as? String)!
                self.breweryID = (self.dataArray["manufId"] as? String)!
                self.lblBeerName.text = self.dataArray["name"] as? String
                self.lblBreweryName.text = self.dataArray["brewery"] as? String
                
                let boldText  = "Style: "
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]
                let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
                
                let normalText = self.dataArray["style"] as? String
                let normalString = NSMutableAttributedString(string:normalText!)
                
                attributedString.append(normalString)
                
                self.lblStyle.attributedText = attributedString
                
                let boldText1  = "Alcohol by volume (ABV): "
                let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]
                let attributedString1 = NSMutableAttributedString(string:boldText1, attributes:attrs1)
                
                if ((self.dataArray["abv"] as? NSNumber)?.floatValue) == nil{
                    let normalText1 = "\((self.dataArray["abv"] as? String)!)%"
                    let normalString1 = NSMutableAttributedString(string:normalText1)
                    
                    attributedString1.append(normalString1)
                }else{
                    let normalText1 = "\((self.dataArray["abv"] as! NSNumber).floatValue)%"
                    let normalString1 = NSMutableAttributedString(string:String(normalText1))
                    
                    attributedString1.append(normalString1)
                }
                
                self.lblABV.attributedText = attributedString1
                
                self.lblTotalRating.text = String("\(self.dataArray["baHads"] as! Int) Ratings")
                
                if ((self.dataArray["local_rating"] as? NSNumber)?.floatValue) == nil{
                    self.lblLocal.text = String(format: "  Local: %.1f", 0.0)
                }else{
                    self.lblLocal.text = String(format: "  Local: %.1f", ((self.dataArray["local_rating"] as! NSNumber).floatValue))
                }
                
                if ((self.dataArray["baRating"] as? NSNumber)?.floatValue) == nil{
                    self.lblGlobal.text = String(format: "  Global: %.1f", 0.0)
                }else{
                    self.lblGlobal.text = String(format: "  Global: %.1f", ((self.dataArray["baRating"] as! NSNumber).floatValue))
                }
                
                self.imageArray = (self.dataArray["beer_images"] as! NSArray).mutableCopy() as! NSMutableArray
                self.mostRecentReview = (self.dataArray["most_recent_reviews"] as! NSArray).mutableCopy() as! NSMutableArray
                self.mostHelpfulReview = (self.dataArray["most_helpful_reviews"] as! NSArray).mutableCopy() as! NSMutableArray
                
                if self.mostRecentReview.count == 0 && self.mostHelpfulReview.count == 0{
                    self.vwBottom.isHidden = true
                    self.tblCommentList.isHidden = true
                    self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.beerDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + self.vwBottom.frame.size.height + 50)
                }else{
                    self.vwBottom.isHidden = false
                    self.tblCommentList.isHidden = false
                    self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.beerDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + self.vwBottom.frame.size.height + self.tblCommentList.contentSize.height + 50)
                }
                
                
                let hads = Int("\(self.dataArray["baHads"]!)")
                
                if hads! >= 10{
                    self.lblNoScore.isHidden = true
                    self.viewRating.isHidden = false
                    self.viewRating.value = CGFloat(Float((self.dataArray["baRating"] as! NSNumber).floatValue))
                }else if hads! > 0{
                    self.lblNoScore.isHidden = true
                    self.viewRating.isHidden = false
                    self.viewRating.value = CGFloat(Float((self.dataArray["baRating"] as! NSNumber).floatValue))
                }else{
                    self.lblNoScore.isHidden = false
                    self.viewRating.isHidden = true
                    self.lblNoScore.backgroundColor = UIColor.red
                    self.lblNoScore.text = "No score yet"
                }
                
                self.ratingDic = (self.dataArray["my_rating"] as! NSArray).mutableCopy() as! NSMutableArray
                print(self.ratingDic)
                
                if self.ratingDic.count > 0{
                    let dic = self.ratingDic[0] as! NSDictionary
                    print(dic)
                    
                    if self.ratingDic.count == 0{
                        self.review_id = " "
                        self.btnRateOutlet.isHidden = false
                    }
                    else{
                        self.btnRateOutlet.isHidden = true
                    }
                    
                    if self.fromEdit == true{
                        self.review_id = (dic["_id"] as? String)!
                        print(self.review_id)
                        self.openReview()
                        
                    }else{
                        
                    }
                }
                
                self.beerDetailPhotoCollectionView.reloadData()
                self.tblCommentList.reloadData()
                SVProgressHUD.dismiss()
        }
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
            //  self.userImageView.image = resizeImage(pickedImage, newWidth: 200)
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
    
    
    //MARK:- Breweries Collection View Delegate/Datasource
    
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerDetailCell", for: indexPath) as! BeerDetailCollectionViewCell
            cell.btnCameraOutlet.isHidden = false
            cell.btnCameraOutlet.isUserInteractionEnabled = true
            cell.btnDeleteOutlet.isHidden = true
            cell.beerImgView.image = UIImage(named: "no-image.jpg")
            cell.delegate = self
            cell.index = indexPath.row
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerDetailCell", for: indexPath) as! BeerDetailCollectionViewCell
            // Configure the cell
            let dic = self.imageArray[indexPath.row] as! NSDictionary

            if (self.imageArray.count == 0){
                cell.btnDeleteOutlet.isHidden = true
                cell.beerImgView.image = UIImage(named: "no-image.jpg")
            }else{
                if let id = dic["user_id"] as? NSNumber {
                    if self.login_userID == id.stringValue{
                        cell.btnDeleteOutlet.isHidden = false
                        cell.btnCameraOutlet.isHidden = true
                        cell.btnCameraOutlet.isUserInteractionEnabled = false
                        let imageUrl = dic["name"] as! String
                        let fullUrl = imageUrl
                        self.fileUrl = NSURL(string: fullUrl)!
                        
                        cell.beerImgView.image = UIImage(named: "no-image.jpg")
                        
                        SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                            (receivedSize :Int, ExpectedSize :Int) in
                            
                        }, completed: {
                            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                            cell.beerImgView.image = image
                        })
                    }else{
                        cell.btnDeleteOutlet.isHidden = true
                        cell.btnCameraOutlet.isHidden = true
                        cell.btnCameraOutlet.isUserInteractionEnabled = false
                        let imageUrl = dic["name"] as! String
                        let fullUrl = imageUrl
                        self.fileUrl = NSURL(string: fullUrl)!
                        
                        cell.beerImgView.image = UIImage(named: "no-image.jpg")
                        
                        SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                            (receivedSize :Int, ExpectedSize :Int) in
                            
                        }, completed: {
                            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                            cell.beerImgView.image = image
                        })
                    }
                }
                else if let id = dic["user_id"] as? String {
                    if self.login_userID == id{
                        cell.btnDeleteOutlet.isHidden = false
                        cell.btnCameraOutlet.isHidden = true
                        cell.btnCameraOutlet.isUserInteractionEnabled = false
                        let imageUrl = dic["name"] as! String
                        let fullUrl = imageUrl
                        self.fileUrl = NSURL(string: fullUrl)!
                        
                        cell.beerImgView.image = UIImage(named: "no-image.jpg")
                        
                        SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                            (receivedSize :Int, ExpectedSize :Int) in
                            
                        }, completed: {
                            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                            cell.beerImgView.image = image
                        })
                    }else{
                        cell.btnDeleteOutlet.isHidden = true
                        cell.btnCameraOutlet.isHidden = true
                        cell.btnCameraOutlet.isUserInteractionEnabled = false
                        let imageUrl = dic["name"] as! String
                        let fullUrl = imageUrl
                        self.fileUrl = NSURL(string: fullUrl)!
                        
                        cell.beerImgView.image = UIImage(named: "no-image.jpg")
                        
                        SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                            (receivedSize :Int, ExpectedSize :Int) in
                            
                        }, completed: {
                            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                            cell.beerImgView.image = image
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
        if collectionView == beerDetailPhotoCollectionView{
            return CGSize(width: beerDetailPhotoCollectionView.frame.size.width , height:  beerDetailPhotoCollectionView.frame.size.height)
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
    
    
    //MARK:- Custom Delegate/Datasource
    
    func BeerDetailCollectionViewCell(_ obj: BeerDetailCollectionViewCell, camera index: Int){
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.customActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
    func BeerDetailCollectionViewCell(_ obj: BeerDetailCollectionViewCell, delete index: Int){
       
        let alertController = UIAlertController(title: "Do you want to delete the image?", message: nil, preferredStyle: UIAlertController.Style.alert) //Replace
                            
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            let dic = self.imageArray[index] as! NSDictionary
            let fullName    = dic["name"] as? String
            let fullNameArr = fullName!.components(separatedBy: "beers/")
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
    
    //MARK:- Button Previous Action
    @IBAction func btnPreviousDidTap(_ sender: Any) {
        print(curr_index)
        s = curr_index > 0;
        print(s)
        if(s){
            curr_index = curr_index - 1
            let indexPath = IndexPath(row: curr_index, section: 0)
            beerDetailPhotoCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }
    }
    
    //MARK:- Button Forward Action
    @IBAction func btnForwardDidTap(_ sender: Any) {
       s = curr_index < (self.imageArray.count - 1)
       print(s)
       if(s){
           curr_index = curr_index + 1
           let indexPath = IndexPath(row: curr_index, section: 0)
           beerDetailPhotoCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
       }
    }
    
    //MARK:- Api call for image delete
    
    func deleteImage(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "delete-beer-photos"
        
        let newTodo: [String: Any] = ["container_id": beerID,"login_token": login_token,"img_name": self.imageName]
        
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
                self.fetchBeerDetail()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Upload Button Action
    
    @IBAction func btnUploadDidTap(_ sender: Any) {
        self.uploadImage()
        self.addPhotoTapped = false
        if self.addPhotoTapped == true{
            self.navigationItem.setHidesBackButton(true, animated:false);
        }else{
            self.navigationItem.setHidesBackButton(false, animated:false)
        }
    }
    
    //MARK:- Cancel Upload Button Action
    @IBAction func btnCancelDidTap(_ sender: Any) {
        self.addPhotoTapped = false
        if self.addPhotoTapped == true{
            self.navigationItem.setHidesBackButton(true, animated:false);
        }else{
            self.navigationItem.setHidesBackButton(false, animated:false)
        }
    }

    //MARK:- Brewery Image Upload
    
    func uploadImage(){
//        SVProgressHUD.setDefaultMaskType(.custom)
//        SVProgressHUD.setBackgroundColor(UIColor.clear)
//        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "Uploading photo...")
        
        let imgData = self.imageData!.jpegData(compressionQuality: 0.5)!
        
        let parameters: Parameters = [
            "login_token" : "\(login_token)",
            "image_of": "beer",
            "container_id": "\(beerID)"
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
                    //print("Upload Progress: \(progress.fractionCompleted)")
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
                    }
                    else if let id = json["reward_point"] as? String {
                       self.view.makeToast("Congratulations!! You have just earned \(id) points", duration: 3.0, position: .bottom)
                    }
                    
                    self.actionButton.close()
                    self.fetchBeerDetail()
                    SVProgressHUD.dismiss()
                }
            case .failure(let encodingError):
                print("error:\(encodingError)")
                SVProgressHUD.dismiss()
            }
        })
    }
    
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
            print(rateVC.anonymousStatus)
            
            self.quickRate = rateVC.lblAppearanceValue.text!
            
            self.giveReview()
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    func openReview(){
        // Create a custom view controller
        let rateVC = RateNReviewViewController(nibName: "RateNReviewViewController", bundle: nil)
        
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
            
            
            print(self.review_id)
            print(rateVC.lblAppearanceValue.text!)
            print(rateVC.lblAromaValue.text!)
            print(rateVC.lblMouthfeelValue.text!)
            print(rateVC.lblTasteValue.text!)
            print(rateVC.lblDrinkValue.text!)
            print(rateVC.lblOverallValue.text!)
            
            self.appearanceValue = rateVC.lblAppearanceValue.text!
            self.aromaValue = rateVC.lblAromaValue.text!
            self.mouthValue = rateVC.lblMouthfeelValue.text!
            self.tasteValue = rateVC.lblTasteValue.text!
            self.drinkValue = rateVC.lblDrinkValue.text!
            self.overallValue = rateVC.lblOverallValue.text!
            self.review_comment = rateVC.txtComment.text!
            
            self.giveReview()
        }
        
        if (self.ratingDic.count == 0){
            
        }else{
            let dic = self.ratingDic[0] as! NSDictionary
            print(dic)
            
            if ((dic["appearance"] as? NSNumber)?.floatValue) != nil{
                rateVC.lblAppearanceValue.text = "\(((dic["appearance"] as? NSNumber)?.floatValue)!)"
                rateVC.appearanceView.value = CGFloat((dic["appearance"] as? NSNumber)!.floatValue)
            }
            if ((dic["aroma"] as? NSNumber)?.floatValue) != nil{
                rateVC.lblAromaValue.text = "\(((dic["aroma"] as? NSNumber)?.floatValue)!)"
                rateVC.aromaView.value = CGFloat((dic["aroma"] as? NSNumber)!.floatValue)
            }
            if ((dic["mouthfeel"] as? NSNumber)?.floatValue) != nil{
                rateVC.lblMouthfeelValue.text = "\(((dic["mouthfeel"] as? NSNumber)?.floatValue)!)"
                rateVC.mouthfeelView.value = CGFloat((dic["mouthfeel"] as? NSNumber)!.floatValue)
            }
            if ((dic["taste"] as? NSNumber)?.floatValue) != nil{
                rateVC.lblTasteValue.text = "\(((dic["taste"] as? NSNumber)?.floatValue)!)"
                rateVC.tasteView.value = CGFloat((dic["taste"] as? NSNumber)!.floatValue)
            }
            if ((dic["drinkability"] as? NSNumber)?.floatValue) != nil{
                rateVC.lblDrinkValue.text = "\(((dic["drinkability"] as? NSNumber)?.floatValue)!)"
                rateVC.drinkView.value = CGFloat((dic["drinkability"] as? NSNumber)!.floatValue)
            }
            if ((dic["overall"] as? NSNumber)?.floatValue) != nil{
                rateVC.lblOverallValue.text = "\(((dic["overall"] as? NSNumber)?.floatValue)!)"
                rateVC.OverallView.value = CGFloat((dic["overall"] as? NSNumber)!.floatValue)
            }

            if dic["description"] as? String != nil{
                let desstr = dic["description"] as? String
                let snack = desstr?.removingHTMLEntities
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified

                let str = snack?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

                let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraph]
                let attrString = NSAttributedString(string:str!, attributes: attributes)
                rateVC.txtComment.attributedText = attrString
            }
            
            if self.fromEdit == true{
                rateVC.lblStaticReviewText.text = "Edit Review"
            }
            else{
                rateVC.lblStaticReviewText.text = "Add Review"
            }
            
            self.fromEdit = false
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    //MARK:- Give Review Api Call
    
    func giveReview(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "beer_review"
        
        
        let newTodo: [String: Any] = ["beer_id": beerID,"login_token": login_token,"appearance": self.appearanceValue,"aroma": self.aromaValue,"mouthfeel": self.mouthValue,"taste": self.tasteValue,"drinkability": self.drinkValue,"overall": self.overallValue,"review_id": self.review_id,"description":self.review_comment,"quickRate":self.quickRate]
        
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
                if let id = json["reward_point"] as? NSNumber {
                   self.view.makeToast("Congratulations!! You have just earned \(id.stringValue) points", duration: 3.0, position: .bottom)
                }
                else if let id = json["reward_point"] as? String {
                   self.view.makeToast("Congratulations!! You have just earned \(id) points", duration: 3.0, position: .bottom)
                }
                self.fetchBeerDetail()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK: - TableView Deleagte/DataSource
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblCommentList{
            if self.isHelpful == true
            {
                if mostHelpfulReview.count == 0{
                    return 1
                }else{
                    return mostHelpfulReview.count
                }
            }else if self.isHelpful == false
            {
                if mostRecentReview.count == 0{
                    return 1
                }else{
                    return self.mostRecentReview.count
                }
            }
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (self.mostRecentReview.count == 0) {
            var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                
                cell = tblCommentList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }else if self.isHelpful == true{
//            print(self.mostHelpfulReview.count)
            if (self.mostHelpfulReview.count == 0){
                var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                    
                    cell = tblCommentList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
                }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }else{
                let cell = tblCommentList.dequeueReusableCell(withIdentifier:"BeerCommentCell", for: indexPath)as! BeerDetailTableViewCell
                
                let dic = self.mostHelpfulReview[indexPath.row] as! NSDictionary
                print(dic)
                
                if let id = dic["user_id"] as? NSNumber {
                    self.comment_userId = id.stringValue
                }
                else if let id = dic["user_id"] as? String {
                    self.comment_userId = id
                }
                
//                self.comment_userId = (dic["user_id"] as? String)!
                cell.lblAppearance.text = String((dic["appearance"] as! NSNumber).floatValue)
                cell.lblAroma.text = String((dic["aroma"] as! NSNumber).floatValue)
                cell.lblMouthfeel.text = String((dic["mouthfeel"] as! NSNumber).floatValue)
                cell.lblTaste.text = String((dic["taste"] as! NSNumber).floatValue)
                cell.lblDrinkability.text = String((dic["drinkability"] as! NSNumber).floatValue)
                cell.lblOverall.text = String((dic["overall"] as! NSNumber).floatValue)
                cell.lblUsername.text = dic["user_name"] as? String
                
                let string1 = "\(dic["created_at"]!)"
                
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM d, yyyy h:mm a"
                
                if let date = dateFormatterGet.date(from: string1) {
                    print(dateFormatterPrint.string(from: date))
                    cell.lblTime.text = dateFormatterPrint.string(from: date)
                } else {
                    print("There was an error decoding the string")
                }
                
                if (dic["user_image"] is NSNull){
                    //            cell.imageVWCell.image = placeholderImage
                }else{
                    let imageUrl = dic["user_image"] as! String
                    let fullUrl = imageUrl
                    self.fileUrl = NSURL(string: fullUrl)!
                    
                    cell.imgUser.image = UIImage(named: "User-2")
                    
                    SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                        (receivedSize :Int, ExpectedSize :Int) in
                        
                    }, completed: {
                        (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                        cell.imgUser.image = image
                    })
                }
                cell.imgUser.clipsToBounds = true
                
                self.mostRecentComment = (dic["comments"] as! NSArray).mutableCopy() as! NSMutableArray
                print(self.mostRecentComment.count)
                
                self.likeList = ((dic["likes"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Int]
                
                if dic["likes"] != nil{
                    self.likeList = ((dic["likes"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Int]
                    print(self.likeList)
                    if self.likeList.count == 0{
                        cell.imgLike.image = UIImage(named: "thumbs-up")
                    }else{
                        if self.likeList.contains(Int(login_userID)!){
                            cell.imgLike.image = UIImage(named: "thumbs-fill")
                        }else{
                            cell.imgLike.image = UIImage(named: "thumbs-up")
                        }
                    }
                }else{
                    cell.imgLike.image = UIImage(named: "thumbs-up")
                }
                
                if self.mostRecentComment.count == 0{
                    
                }else{
                    cell.btnCommentOutlet.setTitle("COMMENT(\(self.mostRecentComment.count))", for: .normal)
                    
                }
                
                if login_userID == comment_userId{
                    cell.btnDeleteOutlet.isHidden = false
                }else{
                    cell.btnDeleteOutlet.isHidden = true
                }
                
                if dic["description"] as? String != nil{
                    let desstr = dic["description"] as? String
                    let snack = desstr?.removingHTMLEntities
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.alignment = .justified

                    let str = snack?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

                    let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraph]
                    let attrString = NSAttributedString(string:str!, attributes: attributes)
                    cell.lblComment.attributedText = attrString

                    cell.lblComment.numberOfLines = 0
                    cell.lblComment.lineBreakMode = NSLineBreakMode.byWordWrapping
                    cell.lblComment.layer.masksToBounds = true
                }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.index = indexPath.row
                cell.section = indexPath.section
                cell.delegate = self
                return cell
            }
        }
        else{
                let cell = tblCommentList.dequeueReusableCell(withIdentifier:"BeerCommentCell", for: indexPath)as! BeerDetailTableViewCell
                
                let dic = self.mostRecentReview[indexPath.row] as! NSDictionary
                print(dic)
            
                if let id = dic["user_id"] as? NSNumber {
                    self.comment_userId = id.stringValue
                }
                else if let id = dic["user_id"] as? String {
                    self.comment_userId = id
                }
                cell.lblAppearance.text = String((dic["appearance"] as! NSNumber).floatValue)
                cell.lblAroma.text = String((dic["aroma"] as! NSNumber).floatValue)
                cell.lblMouthfeel.text = String((dic["mouthfeel"] as! NSNumber).floatValue)
                cell.lblTaste.text = String((dic["taste"] as! NSNumber).floatValue)
                cell.lblDrinkability.text = String((dic["drinkability"] as! NSNumber).floatValue)
                cell.lblOverall.text = String((dic["overall"] as! NSNumber).floatValue)
                cell.lblUsername.text = dic["user_name"] as? String
            
                self.mostRecentComment = (dic["comments"] as! NSArray).mutableCopy() as! NSMutableArray
                print(self.mostRecentComment.count)
                        
                if dic["likes"] != nil{
                    self.likeList = ((dic["likes"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Int]
                    print(self.likeList)
                    if self.likeList.count == 0{
                        cell.imgLike.image = UIImage(named: "thumbs-up")
                    }else{
                        if self.likeList.contains(Int(login_userID)!){
                            cell.imgLike.image = UIImage(named: "thumbs-fill")
                        }else{
                            cell.imgLike.image = UIImage(named: "thumbs-up")
                        }
                    }
                }else{
                    cell.imgLike.image = UIImage(named: "thumbs-up")
                }
            
            
                if self.mostRecentComment.count == 0{
                    
                }else{
                    cell.btnCommentOutlet.setTitle("COMMENT(\(self.mostRecentComment.count))", for: .normal)
                    
                }
            
                if login_userID == comment_userId{
                    cell.btnDeleteOutlet.isHidden = false
                }else{
                    cell.btnDeleteOutlet.isHidden = true
                }
            
                let string1 = "\(dic["created_at"]!)"
            
            
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM d, yyyy h:mm a"
            
                if let date = dateFormatterGet.date(from: string1) {
                    print(dateFormatterPrint.string(from: date))
                    cell.lblTime.text = dateFormatterPrint.string(from: date)
                } else {
                    print("There was an error decoding the string")
                }
            
            if (dic["user_image"] is NSNull){
                //            cell.imageVWCell.image = placeholderImage
            }else{
                let imageUrl = dic["user_image"] as! String
                let fullUrl = imageUrl
                self.fileUrl = NSURL(string: fullUrl)!
                
                cell.imgUser.image = UIImage(named: "User-2")
                
                SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                    (receivedSize :Int, ExpectedSize :Int) in
                    
                }, completed: {
                    (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                    cell.imgUser.image = image
                })
            }
            cell.imgUser.clipsToBounds = true
            
            if dic["description"] as? String != nil{
                let desstr = dic["description"] as? String
                let snack = desstr?.removingHTMLEntities
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified
                
                let str = snack?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraph]
                let attrString = NSAttributedString(string:str!, attributes: attributes)
                cell.lblComment.attributedText = attrString

                cell.lblComment.numberOfLines = 0
                cell.lblComment.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.lblComment.layer.masksToBounds = true
            }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.index = indexPath.row
                cell.section = indexPath.section
                cell.delegate = self
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
        tableHeightConstraint.constant = tblCommentList.contentSize.height
        super.updateViewConstraints()
        
        self.vwMiddle.frame = CGRect(x: self.vwMiddle.frame.origin.x, y: self.vwMiddle.frame.origin.y, width: self.vwMiddle.frame.size.width, height: self.vwMiddle.frame.size.height)
        
        self.vwBottom.frame = CGRect(x: self.vwBottom.frame.origin.x, y: self.vwMiddle.frame.origin.y + self.vwMiddle.frame.size.height, width: self.vwBottom.frame.size.width, height: self.vwBottom.frame.size.height)
        
        self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.beerDetailPhotoCollectionView.frame.size.height + self.vwMiddle.frame.size.height + self.vwBottom.frame.size.height + self.tblCommentList.contentSize.height + 100)
    }
    
    //MARK:- Custom Delegate Method
    
    func BeerDetailTableViewCell(_ obj: BeerDetailTableViewCell, like index: Int, section:Int){
        print("Like tapped")
        if self.isHelpful == true{
            let dic = self.mostHelpfulReview[index] as! NSDictionary
            print(dic)
            
            self.review_id = (dic["_id"] as? String)!
        }else{
            let dic = self.mostRecentReview[index] as! NSDictionary
            print(dic)
            
            self.review_id = (dic["_id"] as? String)!
        }
        self.likeReview()
    }
    
    func BeerDetailTableViewCell(_ obj: BeerDetailTableViewCell, comment index: Int, section:Int){
        print("Comment tapped")
        if self.isHelpful == true{
            let dic = self.mostHelpfulReview[index] as! NSDictionary
            print(dic)
            
            self.commentArray = (dic["comments"] as! NSArray).mutableCopy() as! NSMutableArray
            
            self.review_id = (dic["_id"] as? String)!
        }else{
            let dic = self.mostRecentReview[index] as! NSDictionary
            print(dic)
            
            self.commentArray = (dic["comments"] as! NSArray).mutableCopy() as! NSMutableArray
            
            self.review_id = (dic["_id"] as? String)!
        }
        let CommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        CommentViewController.revewID = self.review_id
        self.navigationController?.pushViewController(CommentViewController, animated: true)
    }
    
    func BeerDetailTableViewCell(_ obj: BeerDetailTableViewCell, delete index: Int, section:Int){
        print("Delete tapped")
        if self.isHelpful == true{
            let dic = self.mostHelpfulReview[index] as! NSDictionary
            print(dic)
            
            self.review_id = (dic["_id"] as? String)!
            let alertController = UIAlertController(title: "Your Local Beer",
                                                    message: "Are you sure you want to delete your review?",
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: {(_ action: UIAlertAction?) -> Void in
            })
            
            let openAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.deleteReview()
            }
            alertController.addAction(openAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            let dic = self.mostRecentReview[index] as! NSDictionary
            print(dic)
            
            self.review_id = (dic["_id"] as? String)!
            let alertController = UIAlertController(title: "Your Local Beer",
                                                    message: "Are you sure you want to delete your review?",
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: {(_ action: UIAlertAction?) -> Void in
            })
            
            
            let openAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.deleteReview()
            }
            alertController.addAction(openAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //MARK:- Like Review Api Call
    
    func likeReview(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "like_beer_review"
        
        let newTodo: [String: Any] = ["review_id": self.review_id,"login_token": login_token]
        
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
                self.review_id = " "
                self.fetchBeerDetail()
                SVProgressHUD.dismiss()
        }
    }
    
    
    
    
    
    //MARK:- Delete Comment Api Call
    
    func deleteReview(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "delete_beer_review"
        
        let newTodo: [String: Any] = ["review_id": self.review_id,"login_token": login_token]
        
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
                self.review_id = " "
                self.fetchBeerDetail()
                SVProgressHUD.dismiss()
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
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {
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
    
    //MARK:- Button Action
    
    @IBAction func btnMostRecentDidTap(_ sender: Any) {
         self.btnMostRecent.backgroundColor = UIColor(red: 241/255.0, green: 128/255.0, blue: 24/255.0, alpha: 1.0)
        self.btnMostHelpful.backgroundColor = UIColor(red: 195/255.0, green: 195/255.0, blue: 195/255.0, alpha: 1.0)
        self.isHelpful = false
        tblCommentList.reloadData()
    }
    
    @IBAction func btnMostHelpfulDidTap(_ sender: Any) {
        self.btnMostRecent.backgroundColor = UIColor(red: 195/255.0, green: 195/255.0, blue: 195/255.0, alpha: 1.0)
        self.btnMostHelpful.backgroundColor = UIColor(red: 241/255.0, green: 128/255.0, blue: 24/255.0, alpha: 1.0)
        self.isHelpful = true
        tblCommentList.reloadData()
    }
    
    @IBAction func btnBreweryDetailDidTap(_ sender: Any) {
        let BreweryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreweryDetail") as! BreweryDetailViewController
        BreweryDetailViewController.breweryID = self.breweryID
        self.navigationController?.pushViewController(BreweryDetailViewController, animated: true)
    }
    
    //MARK:- Button Method
    
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
            
            let newTodo: [String: Any] = ["login_token": login_token,"category": "beer","field_id": self.beerID,"description": self.reportText,"title": self.reportTitle]
            
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
