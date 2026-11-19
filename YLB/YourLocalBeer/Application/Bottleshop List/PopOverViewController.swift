import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD


class PopOverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,PopUpTableViewCellDelegate {
    
    //MARK:- Variable Declaration
    @IBOutlet weak var Popupview: UIView!
    @IBOutlet weak var tableView: UITableView!
    var reviews = NSMutableArray()
    var login_userID = String()
    var likeList: [Int] = []
    var mostRecentComment = NSMutableArray()
    var comment_userId = String()
    var fileUrl = NSURL()
    var review_id = String()
    var commentArray = NSMutableArray()
    var logIndict = NSDictionary()
    var login_token = String()
    var bar_id = String()
    var fromBottleBeer = String()
    
        
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

        login_token = "\(logIndict .value(forKey: "login_token")!)"
        login_userID = String(logIndict["user_id"] as! Int)
        
        self.review_id = " "
        self.bar_id = ""
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 180.0
        self.tableView.rowHeight = UITableView.automaticDimension
        
        // Apply radius to Popupview
        Popupview.layer.cornerRadius = 10
        Popupview.layer.masksToBounds = true
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary

        login_token = "\(logIndict .value(forKey: "login_token")!)"
        login_userID = String(logIndict["user_id"] as! Int)
        
        if fromBottleBeer == "bottle"{
            fromBottleBeer = "bottle"
        }
        print(reviews)
    }
    
    func touchesBegan(_ touches: Set<AnyHashable>, with event: UIEvent) {
        let touch: UITouch? = touches.first as? UITouch
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != Popupview {
            Popupview.isHidden = true
        }
    }
    
    //MARK: - TableView Deleagte/DataSource
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviews.count == 0{
            return 1
        }else{
            return reviews.count;
        }
    }
    
    
    // Select item from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        print("Company Name : " + names[indexPath.row])
//
//        Shared.shared.companyName = names[indexPath.row]
        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if reviews.count == 0{
            var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            
            if cell == nil {
                tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"BarCommentCell", for: indexPath)as! PopUpTableViewCell
            
            let dic = self.reviews[indexPath.row] as! NSDictionary
            print(dic)
            
            if fromBottleBeer == "bottle"{
                
                if let id = dic["user_id"] as? NSNumber {
                    self.comment_userId = id.stringValue
                }
                else if let id = dic["user_id"] as? String {
                    self.comment_userId = id
                }
                if let ambience = dic["ambience"] as? NSNumber {
                    cell.lblAmbience.text = ambience.stringValue
                }
                else if let ambience = dic["ambience"] as? String {
                    cell.lblAmbience.text = ambience
                }
                
                if let quality = dic["quality"] as? NSNumber {
                    cell.lblQuality.text = quality.stringValue
                }
                else if let quality = dic["quality"] as? String {
                    cell.lblQuality.text = quality
                }
                
                if let selection = dic["selection"] as? NSNumber {
                    cell.lblSelection.text = selection.stringValue
                }
                else if let selection = dic["selection"] as? String {
                    cell.lblSelection.text = selection
                }
                
                if let staff = dic["staff"] as? NSNumber {
                    cell.lblStaff.text = staff.stringValue
                }
                else if let staff = dic["staff"] as? String {
                    cell.lblStaff.text = staff
                }
                
                if let service = dic["service"] as? NSNumber {
                    cell.lblFood.text = service.stringValue
                }
                else if let service = dic["service"] as? String {
                    cell.lblFood.text = service
                }
                
                if let value = dic["value"] as? NSNumber {
                   cell.lblValue.text = value.stringValue
                }
                else if let value = dic["value"] as? String {
                   cell.lblValue.text = value
                }
                cell.lblUsername.text = dic["user_name"] as? String
                cell.lblStaticFoodText.text = "Service"
                cell.lblStaticStaffText.text = "Staff"
            }else{
                if let id = dic["user_id"] as? NSNumber {
                    self.comment_userId = id.stringValue
                }
                else if let id = dic["user_id"] as? String {
                    self.comment_userId = id
                }
                
                if let ambience = dic["ambience"] as? NSNumber {
                    cell.lblAmbience.text = ambience.stringValue
                }
                else if let ambience = dic["ambience"] as? String {
                    cell.lblAmbience.text = ambience
                }
                
                if let quality = dic["quality"] as? NSNumber {
                    cell.lblQuality.text = quality.stringValue
                }
                else if let quality = dic["quality"] as? String {
                    cell.lblQuality.text = quality
                }
                
                if let selection = dic["selection"] as? NSNumber {
                    cell.lblSelection.text = selection.stringValue
                }
                else if let selection = dic["selection"] as? String {
                    cell.lblSelection.text = selection
                }
                
                if let staffservice = dic["staffservice"] as? NSNumber {
                    cell.lblStaff.text = staffservice.stringValue
                }
                else if let staffservice = dic["staffservice"] as? String {
                    cell.lblStaff.text = staffservice
                }
                
                if let food = dic["food"] as? NSNumber {
                    cell.lblFood.text = food.stringValue
                }
                else if let food = dic["food"] as? String {
                    cell.lblFood.text = food
                }
                
                if let value = dic["value"] as? NSNumber {
                   cell.lblValue.text = value.stringValue
                }
                else if let value = dic["value"] as? String {
                   cell.lblValue.text = value
                }
                
                cell.lblUsername.text = dic["user_name"] as? String
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
            
            self.mostRecentComment = (dic["comments"] as! NSArray).mutableCopy() as! NSMutableArray
            print(self.mostRecentComment.count)
            
            //self.likeList = ((dic["likes"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Int]
            
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
    
    //MARK:- Custom Delegate Method
    
    func PopUpTableViewCell(_ obj: PopUpTableViewCell, like index: Int, section:Int){
        print("Like tapped")
        let dic = self.reviews[index] as! NSDictionary
        print(dic)
        
        self.review_id = (dic["_id"] as? String)!
        self.likeReview()
    }
    
    func PopUpTableViewCell(_ obj: PopUpTableViewCell, comment index: Int, section:Int){
        print("Comment tapped")
        let dic = self.reviews[index] as! NSDictionary
        print(dic)
            
        self.commentArray = (dic["comments"] as! NSArray).mutableCopy() as! NSMutableArray
        
        self.review_id = (dic["_id"] as? String)!
        
        let CommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        CommentViewController.revewID = self.review_id
        //CommentViewController.commentList = self.commentArray
        CommentViewController.fromBottleBeer = self.fromBottleBeer
        self.navigationController?.pushViewController(CommentViewController, animated: true)
        
    }
    
    func PopUpTableViewCell(_ obj: PopUpTableViewCell, delete index: Int, section:Int){
        print("Delete tapped")
        let dic = self.reviews[index] as! NSDictionary
        print(dic)
        self.bar_id = (dic["restaurent_id"] as? String)!
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
    
    //MARK:- Like Review Api Call
    
    func likeReview(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "bar_like_review"
        
        let newTodo: [String: Any] = ["rev_id": self.review_id,"login_token": login_token]
        
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
                self.navigationController?.dismiss(animated: true, completion: nil)
                SVProgressHUD.dismiss()
        }        
    }

    //MARK:- Delete Comment Api Call
    
    func deleteReview(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "delete_bar_review"
        
        let newTodo: [String: Any] = ["rev_id": self.review_id,"login_token": login_token,"bar_id":self.bar_id]
        
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
                self.bar_id = ""
                self.navigationController?.dismiss(animated: true, completion: nil)
                SVProgressHUD.dismiss()
        }
    }
    
    // Close PopUp
    @IBAction func closePopup(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
