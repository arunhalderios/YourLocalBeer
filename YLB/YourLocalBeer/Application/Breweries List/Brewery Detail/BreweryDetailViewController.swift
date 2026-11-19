//
//  BreweryDetailViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import CoreLocation
import Toast_Swift
import PopupDialog
import JJFloatingActionButton

class BreweryDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,BreweryDetailCollectionViewCellDelegate {

    
    @IBOutlet weak var mainScrlView: UIScrollView!
    @IBOutlet weak var detailPhotoCollectionView: UICollectionView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTotalBeer: UILabel!

    var ImagePicker = UIImagePickerController()
    var imageData:UIImage?
    var fromCamera = Bool()
    var cameraData : NSData?

    @IBOutlet weak var vwDetail: UIView!
    @IBOutlet weak var vwOpeningStatus: UIView!
    @IBOutlet weak var btnBeerListingOutlet: UIButton!
    var BreweryName = String()
    var BreweryAddress = String()
    
    var breweryID = String()
    var dataArray = NSDictionary()
    var weekdays = NSMutableArray()
    
    @IBOutlet weak var tblBreweryDetail: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    var imageArray = NSMutableArray()
    var fileUrl = NSURL()
    var logIndict = NSDictionary()
    var login_token = String()
    var addPhotoTapped = Bool()
    var brewery_name = String()
    var brewery_id = String()
    var Lat = Double()
    var Lng = Double()
    var locationManager:CLLocationManager!
    var userLat = Double()
    var userLng = Double()
    @IBOutlet weak var lblTotalBeerRating: UILabel!
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnFavouriteOutlet: UIButton!
    var favouriteId = String()
    var imageName = String()
    var login_userID = String()
    var curr_index = NSInteger()
    var s = Bool()
    @IBOutlet var btnBackOutlet: UIButton!
    @IBOutlet var btnForwardOutlet: UIButton!
    var reportText = String()
    var reportTitle = String()
    fileprivate let actionButton = JJFloatingActionButton()
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

         if #available(iOS 13.0, *) {
               overrideUserInterfaceStyle = .light
         } else {
               // Fallback on earlier versions
         }

        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        
        login_token = "\(logIndict["login_token"]!)"
        login_userID = "\(logIndict .value(forKey: "user_id")!)"
        
        actionButton.itemAnimationConfiguration = .circularSlideIn(withRadius: 120)
        actionButton.buttonAnimationConfiguration = .rotation(toAngle: .pi * 3 / 4)
        actionButton.buttonAnimationConfiguration.opening.duration = 0.8
        actionButton.buttonAnimationConfiguration.closing.duration = 0.6
        actionButton.buttonImage = UIImage(named: "four-grid")
        
        actionButton.addItem(image: #imageLiteral(resourceName: "location-circular")) { item in
            item.backgroundColor = UIColor.blue
            item.buttonColor = .white
            item.buttonImageColor = .red

            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0.4)
            item.layer.shadowRadius = CGFloat(2)
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
            let currentAction = UIAlertAction(title: "", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in })
            alert.addAction(currentAction)
            self.mapActionSheet()
            self.present(alert, animated: true, completion: nil)
        }

        actionButton.addItem(image: #imageLiteral(resourceName: "camera")) { item in
            item.buttonColor = .white
            item.buttonImageColor = .red
            self.addPhotoTapped = true
            let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
            let currentAction = UIAlertAction(title: "", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in })
            alert.addAction(currentAction)
            self.customActionSheet()
            self.present(alert, animated: true, completion: nil)
        }

        actionButton.addItem(image: #imageLiteral(resourceName: "editDetail")) { item in
            item.buttonColor = .white
            item.buttonImageColor = .red
           let alertController = UIAlertController(title: "Attention", message: "You are being redirected to the website to add/edit details", preferredStyle: UIAlertController.Style.alert) //Replace

           // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
           let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
               (result : UIAlertAction) -> Void in

           }
           let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
               (result : UIAlertAction) -> Void in
               let EditBreweryViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditBrewery") as! EditBreweryViewController
               EditBreweryViewController.breweryId = self.brewery_id
               EditBreweryViewController.fromBrewery = true
               self.navigationController?.pushViewController(EditBreweryViewController, animated: true)
           }
           alertController.addAction(cancelAction)
           alertController.addAction(okAction)
           
           self.present(alertController, animated: true, completion: nil)
        }

        actionButton.addItem(image: #imageLiteral(resourceName: "report")) { item in
            item.buttonColor = .white
            item.buttonImageColor = .red
            self.openReport()
        }

        actionButton.display(inViewController: self)
        
        // Do any additional setup after loading the view.
        
        btnBeerListingOutlet.layer.cornerRadius = 5
        
        lblName.text = BreweryName
        lblAddress.text = BreweryAddress
        
        self.tblBreweryDetail.rowHeight = UITableView.automaticDimension
        self.tblBreweryDetail.estimatedRowHeight = 50;
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "magnifying-glass"), style:  UIBarButtonItem.Style.plain, target: self, action: #selector(BreweryDetailViewController.barButtonClickAction))
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        
        login_token = "\(logIndict["login_token"]!)"
        login_userID = "\(logIndict .value(forKey: "user_id")!)"
        
        if self.addPhotoTapped == true{
            self.navigationItem.setHidesBackButton(true, animated:false);
        }else{
            self.navigationItem.setHidesBackButton(false, animated:false)
        }
        self.fetchBreweryDetail()
        self.determineMyCurrentLocation()
    }
    
    override func viewWillLayoutSubviews() {
//        tableHeightConstraint.constant = tblBreweryDetail.contentSize.height
//        super.updateViewConstraints()
//        self.tblBreweryDetail.frame = CGRect(x: self.tblBreweryDetail.frame.origin.x, y: self.tblBreweryDetail.frame.origin.y, width: self.tblBreweryDetail.frame.size.width, height: self.tblBreweryDetail.contentSize.height)
//        mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.detailPhotoCollectionView.frame.size.height + self.vwDetail.frame.size.height + vwOpeningStatus.frame.size.height + self.tblBreweryDetail.contentSize.height + 50)
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
                        locationManager = CLLocationManager()
                        locationManager.delegate = self
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
                        if CLLocationManager.locationServicesEnabled() {
                            locationManager.startUpdatingLocation()
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
        
        manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.userLat = userLocation.coordinate.latitude
        self.userLng = userLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    @IBAction func btnWebsiteLinkDidTap(_ sender: Any) {
    }
    
    //MARK:- Fetch Detail Api Call
    
    func fetchBreweryDetail(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "brewery_details"
        
        let newTodo: [String: Any] = ["brewery_id": breweryID,"login_token": login_token]
        
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
                self.dataArray = (json["brewery"] as! NSDictionary).mutableCopy() as! NSDictionary
                
                if (self.dataArray["favorite"] as? String) == nil || (self.dataArray["favorite"] as? String)!.isEmpty {
                    self.btnFavouriteOutlet.setImage(UIImage(named: "favourite"), for: .normal)
                }else{
                    self.favouriteId = (self.dataArray["favorite"] as? String)!
                    self.btnFavouriteOutlet.setImage(UIImage(named: "favouited"), for: .normal)
                }
                
                self.weekdays = (self.dataArray["week_days"] as! NSArray ).mutableCopy() as! NSMutableArray
                
                self.brewery_name = (self.dataArray["name"] as? String)!
                self.brewery_id = (self.dataArray["_id"] as? String)!
                
                self.lblName.text = self.dataArray["name"] as? String
                
                self.lblTotalBeerRating.text = "\(String(describing: self.dataArray["totalRating"] as! Int)) Beer Ratings"
                
                self.lblRank.text = String("#\(self.dataArray["position"] as! Int) of \(self.dataArray["totalCities"] as! Int) in \(self.dataArray["city"] as! String)")
                
                if let estabValue = (self.dataArray["establishment_type"] as? String){
                    self.lblType.text = "Type : \(estabValue)"
                }else{
                    self.lblType.text = "Type : "
                }
                
                if (self.dataArray["state"] as? String) != nil && (self.dataArray["city"] as? String) != nil{
                    self.lblAddress.text = "\((self.dataArray["address"] as? String)!),\((self.dataArray["city"] as? String)!),\((self.dataArray["state"] as? String)!),\((self.dataArray["country"] as? String)!)"
                }else if (self.dataArray["state"] as? String) == nil{
                    self.lblAddress.text = "\((self.dataArray["address"] as? String)!),\((self.dataArray["city"] as? String)!),\((self.dataArray["country"] as? String)!)"
                }else{
                    self.lblAddress.text = "\((self.dataArray["address"] as? String)!),\((self.dataArray["state"] as? String)!),\((self.dataArray["country"] as? String)!)"
                }
                
                if (self.dataArray["description"] as? String) != nil
                {
                    self.lblDesc.text = "Venue Details: \((self.dataArray["description"] as? String)!)"
                    
                    self.tblBreweryDetail.frame = CGRect(x: self.tblBreweryDetail.frame.origin.x, y: self.tblBreweryDetail.frame.origin.y, width: self.tblBreweryDetail.frame.size.width, height: self.tblBreweryDetail.contentSize.height)
                    
                    
                    self.vwDetail.frame = CGRect(x: self.vwDetail.frame.origin.x, y: self.vwDetail.frame.origin.y, width: self.vwDetail.frame.size.width, height: self.vwDetail.frame.size.height)
                    
                    self.vwOpeningStatus.frame = CGRect(x: self.vwOpeningStatus.frame.origin.x, y: self.vwDetail.frame.origin.y + self.vwDetail.frame.size.height, width: self.vwOpeningStatus.frame.size.width, height: self.vwOpeningStatus.frame.size.height)
                    
                    
                    self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.detailPhotoCollectionView.frame.size.height + self.vwDetail.frame.size.height + self.vwOpeningStatus.frame.size.height + self.tblBreweryDetail.contentSize.height + 50)
                }
                else
                {
                    self.lblDesc.text = "Venue Details:"
                    
                    self.tblBreweryDetail.frame = CGRect(x: self.tblBreweryDetail.frame.origin.x, y: self.tblBreweryDetail.frame.origin.y, width: self.tblBreweryDetail.frame.size.width, height: self.tblBreweryDetail.contentSize.height)
                    
                    self.mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.detailPhotoCollectionView.frame.size.height + self.vwDetail.frame.size.height + self.vwOpeningStatus.frame.size.height + self.tblBreweryDetail.contentSize.height + 50)
                }
                
                self.lblTotalBeer.text = "Total No. of Beers : \((self.dataArray["totalBeer"] as? NSNumber)!)"
                
                self.imageArray = (self.dataArray["brewary_photos"] as! NSArray).mutableCopy() as! NSMutableArray
                self.imageArray = ((self.imageArray.reverseObjectEnumerator().allObjects) as NSArray).mutableCopy() as! NSMutableArray
                
                let locdic = self.dataArray["location"] as! NSDictionary
                let coordinates = locdic["coordinates"] as! NSArray
                self.Lng = coordinates[0] as! double_t
                self.Lat = coordinates[1] as! double_t
                
                self.detailPhotoCollectionView.reloadData()
                self.tblBreweryDetail.reloadData()
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
        let cell = tblBreweryDetail.dequeueReusableCell(withIdentifier:"WeekDays", for: indexPath)as! WeekDaysTableViewCell
        
        let dic = self.weekdays[indexPath.row] as! NSDictionary
        print(dic)
        
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
        self.viewWillLayoutSubviews()
        
        tableHeightConstraint.constant = tblBreweryDetail.contentSize.height
        super.updateViewConstraints()
        
        self.vwDetail.frame = CGRect(x: self.vwDetail.frame.origin.x, y: self.vwDetail.frame.origin.y, width: self.vwDetail.frame.size.width, height: self.vwDetail.frame.size.height)
        
        self.vwOpeningStatus.frame = CGRect(x: self.vwOpeningStatus.frame.origin.x, y: self.vwDetail.frame.origin.y + self.vwDetail.frame.size.height, width: self.vwOpeningStatus.frame.size.width, height: self.vwOpeningStatus.frame.size.height)
        
        
        self.tblBreweryDetail.frame = CGRect(x: self.tblBreweryDetail.frame.origin.x, y: self.tblBreweryDetail.frame.origin.y, width: self.tblBreweryDetail.frame.size.width, height: self.tblBreweryDetail.contentSize.height)
        
        mainScrlView.contentSize = CGSize(width: self.mainScrlView.frame.size.width, height: self.detailPhotoCollectionView.frame.size.height + self.vwDetail.frame.size.height + vwOpeningStatus.frame.size.height + self.tblBreweryDetail.contentSize.height + 50)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreweryDetailCell", for: indexPath) as! BreweryDetailCollectionViewCell
            cell.btnCameraOutlet.isHidden = false
            cell.btnCameraOutlet.isUserInteractionEnabled = true
            cell.btnDeleteOutlet.isHidden = true
            cell.imgBrewery.image = UIImage(named: "no-image.jpg")
            cell.delegate = self
            cell.index = indexPath.row
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreweryDetailCell", for: indexPath) as! BreweryDetailCollectionViewCell
            // Configure the cell
            let dic = self.imageArray[indexPath.row] as! NSDictionary
                        
            if (self.imageArray.count == 0){
                cell.btnDeleteOutlet.isHidden = true
                cell.imgBrewery.image = UIImage(named: "no-image.jpg")
            }else{
                if let id = dic["user_id"] as? NSNumber {
                    if self.login_userID == id.stringValue{
                        cell.btnDeleteOutlet.isHidden = false
                        cell.btnCameraOutlet.isHidden = true
                        cell.btnCameraOutlet.isUserInteractionEnabled = false
                        let imageUrl = dic["name"] as! String
                        let fullUrl = imageUrl
                        self.fileUrl = NSURL(string: fullUrl)!
                        
                        cell.imgBrewery.image = UIImage(named: "no-image.jpg")
                        
                        SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                            (receivedSize :Int, ExpectedSize :Int) in
                            
                        }, completed: {
                            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                            cell.imgBrewery.image = image
                        })
                    }else{
                        cell.btnDeleteOutlet.isHidden = true
                        cell.btnCameraOutlet.isHidden = true
                        cell.btnCameraOutlet.isUserInteractionEnabled = false
                        let imageUrl = dic["name"] as! String
                        let fullUrl = imageUrl
                        self.fileUrl = NSURL(string: fullUrl)!
                        
                        cell.imgBrewery.image = UIImage(named: "no-image.jpg")
                        
                        SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                            (receivedSize :Int, ExpectedSize :Int) in
                            
                        }, completed: {
                            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                            cell.imgBrewery.image = image
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
                        
                        cell.imgBrewery.image = UIImage(named: "no-image.jpg")
                        
                        SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                            (receivedSize :Int, ExpectedSize :Int) in
                            
                        }, completed: {
                            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                            cell.imgBrewery.image = image
                        })
                    }else{
                        cell.btnDeleteOutlet.isHidden = true
                        cell.btnCameraOutlet.isHidden = true
                        cell.btnCameraOutlet.isUserInteractionEnabled = false
                        let imageUrl = dic["name"] as! String
                        let fullUrl = imageUrl
                        self.fileUrl = NSURL(string: fullUrl)!
                        
                        cell.imgBrewery.image = UIImage(named: "no-image.jpg")
                        
                        SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                            (receivedSize :Int, ExpectedSize :Int) in
                            
                        }, completed: {
                            (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                            cell.imgBrewery.image = image
                        })
                    }
                }
            }
            cell.delegate = self
            cell.index = indexPath.row
            return cell
        }
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == detailPhotoCollectionView{
            return CGSize(width: detailPhotoCollectionView.frame.size.width , height:  detailPhotoCollectionView.frame.size.height)
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
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageArray.count != 0{
            let dic = self.imageArray[indexPath.row] as! NSDictionary
            let imageUrl = dic["name"] as! String
            let fullUrl = imageUrl
            self.fileUrl = NSURL(string: fullUrl)!
            
            // Create a custom view controller
            let imageVC = ImageEnlargeView(nibName: "ImageEnlargeView", bundle: nil)
                    
            // Create the dialog
            let popup = PopupDialog(viewController: imageVC,
                                    buttonAlignment: .horizontal,
                                    transitionStyle: .bounceDown,
                                    tapGestureDismissal: true,
                                    panGestureDismissal: false)
            
            SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                (receivedSize :Int, ExpectedSize :Int) in
                
            }, completed: {
                (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                imageVC.imgEnlargeView.image = image
                imageVC.imgEnlargeView.contentMode = .scaleAspectFit
                //imageVC.imgEnlargeView.clipsToBounds = true
            })
            
            // Present dialog
            present(popup, animated: true, completion: nil)
        }
    }
 
    // Use to back from full mode
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    */
    
    //MARK:- Custom Delegate/Datasource
    
    func BreweryDetailCollectionViewCell(_ obj: BreweryDetailCollectionViewCell, camera index: Int){
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.customActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
    func BreweryDetailCollectionViewCell(_ obj: BreweryDetailCollectionViewCell, delete index: Int){
       
        let alertController = UIAlertController(title: "Do you want to delete the image?", message: nil, preferredStyle: UIAlertController.Style.alert) //Replace
                            
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            let dic = self.imageArray[index] as! NSDictionary
            let fullName    = dic["name"] as? String
            let fullNameArr = fullName!.components(separatedBy: "breweries/")
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
            detailPhotoCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }
    }
    
    //MARK:- Button Forward Action
    @IBAction func btnForwardDidTap(_ sender: Any) {
        s = curr_index < (self.imageArray.count - 1)
        print(s)
        if(s){
            curr_index = curr_index + 1
            let indexPath = IndexPath(row: curr_index, section: 0)
            detailPhotoCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    
    
    
    
    //MARK:- Api call for image delete
    
    func deleteImage(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "delete-brewery-photos"
        
        let newTodo: [String: Any] = ["container_id": breweryID,"login_token": login_token,"img_name": self.imageName]
        
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
                self.fetchBreweryDetail()
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
            "image_of": "brewery",
            "container_id": "\(breweryID)"
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
                    }
                    else if let id = json["reward_point"] as? String {
                       self.view.makeToast("Congratulations!! You have just earned \(id) points", duration: 3.0, position: .bottom)
                    }
                    self.actionButton.close()
                    self.fetchBreweryDetail()
                    SVProgressHUD.dismiss()
            }
            case .failure(let encodingError):
                print("error:\(encodingError)")
                SVProgressHUD.dismiss()
            }
        })
    }
    
    //MARK:- Beer List Button Action
    
    @IBAction func btnBeerListDidTap(_ sender: Any) {
        let BeerListViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerList") as! BeerListViewController
        BeerListViewController.breweryName = self.brewery_name
        BeerListViewController.breweryID = self.brewery_id
        self.navigationController?.pushViewController(BeerListViewController, animated: true)
    }
    
    //MARK:- Direction Button Action
    
    @IBAction func btnDirectionDidTap(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.mapActionSheet()
        self.present(alert, animated: true, completion: nil)
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
    
    @IBAction func btnAddressDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        let currentAction = UIAlertAction(title: "", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in })
        alert.addAction(currentAction)
        self.mapActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Favourite Button Action
    @IBAction func btnSaveDidTap(_ sender: Any) {
        if (self.dataArray["favorite"] as? String) == nil || (self.dataArray["favorite"] as? String)!.isEmpty{
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.clear)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show(withStatus: "It's working...")
            let todosEndpoint: String = BASE_URL + "save-search"
            
            let newTodo: [String: Any] = ["login_token": login_token,"category": "brewery","place_id": breweryID]
            
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
                    self.fetchBreweryDetail()
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
                    self.fetchBreweryDetail()
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
        
        let newTodo: [String: Any] = ["login_token": login_token,"category": "brewery","field_id": self.breweryID,"description": self.reportText,"title": self.reportTitle]
        
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
