//
//  CommentViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 11/02/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import GrowingTextView
import SDWebImage

class CommentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tblComment: UITableView!
    @IBOutlet weak var txtComment: GrowingTextView!
     @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    var revewID = String()
    var login_token = String()
    var logIndict = NSDictionary()
    var commentList = NSMutableArray()
    var fromBar = Bool()
    var type = String()
    var fromBottleBeer = String()
    var fileUrl = NSURL()
    var todosEndpoint = String()
    var newTodo = [String: Any]()
    
    
    
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
        
        if fromBottleBeer == "bar"{
            self.type = "bar"
        }else if fromBottleBeer == "bottle"{
            self.type = "bottleshop"
        }else{
            self.type = "beer"
        }
        self.fetchComments()
        
        (tblComment).register(UINib(nibName:"CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "Comment")
        
        self.tblComment.rowHeight = UITableView.automaticDimension
        self.tblComment.estimatedRowHeight = 80.0
        
        txtComment.layer.cornerRadius = 5
        txtComment.clipsToBounds = true
        txtComment.textColor = UIColor.black
        txtComment.toolbarPlaceholder = "Type here"
        txtComment.minHeight = 30
        txtComment.maxHeight = 100
        
        
        tblComment.rowHeight = UITableView.automaticDimension
        tblComment.estimatedRowHeight = 111
        tblComment.tableFooterView = UIView()
        tblComment.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        
        let loginData = UserDefaults.standard.object(forKey: "key_profile_info")
        logIndict = NSKeyedUnarchiver.unarchiveObject(with: loginData as! Data) as! NSDictionary
        login_token = "\(logIndict .value(forKey: "login_token")!)"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    @IBAction func btnCommentDidTap(_ sender: Any) {
        if txtComment.text.isEmpty{
            let alert = UIAlertController(title: "Alert", message: "Cannot post blank comment", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
           
            self.submitComment()
        }
    }
    
    //MARK:- Fetch Comment List
    
    func fetchComments() {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "comments"
        
        let newTodo: [String: Any] = ["review_id": revewID,"type": self.type]
        
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
                self.commentList = (json["comments"] as! NSArray).mutableCopy() as! NSMutableArray
                self.tblComment.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK: - TableView Deleagte/DataSource
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if commentList.count == 0{
            return 1
        }else{
            return commentList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (self.commentList.count == 0) {
            var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            
            if cell == nil {
                
                tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                
                cell = tblComment.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }else{
            let cell = tblComment.dequeueReusableCell(withIdentifier:"Comment", for: indexPath)as! CommentTableViewCell
            
            let dic = self.commentList[indexPath.row] as! NSDictionary
            
            cell.lblUserName.text = dic["user_name"] as? String
            
            
            if (dic["user_image"] is NSNull){
                //            cell.imageVWCell.image = placeholderImage
            }else{
                let imageUrl = dic["user_image"] as! String
                let fullUrl = imageUrl
                self.fileUrl = NSURL(string: fullUrl)!
                
                cell.imgUser.image = UIImage(named: "placeholder.png")
                
                SDWebImageManager.shared().downloadImage(with: NSURL(string: fullUrl) as URL?, options: .continueInBackground, progress: {
                    (receivedSize :Int, ExpectedSize :Int) in
                    
                }, completed: {
                    (image : UIImage?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                    cell.imgUser.image = image
                })
            }
            
            if self.type == "beer"{
                cell.lblTime.text = dic["comment_date_time"] as? String
                if dic["comments_desc"] as? String != nil{
                    let desstr = dic["comments_desc"] as? String
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
            }else{
                cell.lblTime.text = dic["created_at"] as? String
                if dic["comment"] as? String != nil{
                    let desstr = dic["comment"] as? String
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
            }
            
            return cell
        }
    }
    
    
    //MARK:- Submit Comment Api Call
    
    func submitComment(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        
        if fromBottleBeer == "bar"{
            todosEndpoint = BASE_URL + "bar_review_comment"
            
            newTodo = ["rev_id": revewID,"login_token": login_token,"description":self.txtComment.text!]
        }else if fromBottleBeer == "bottle"{
            todosEndpoint = BASE_URL + "bar_review_comment"
            
            newTodo = ["rev_id": revewID,"login_token": login_token,"description":self.txtComment.text!]
        }else{
            todosEndpoint = BASE_URL + "beer_comment"
            
            newTodo = ["review_id": revewID,"login_token": login_token,"description":self.txtComment.text!]
        }
        
//        let todosEndpoint: String = BASE_URL + "beer_comment"
//
//        let newTodo: [String: Any] = ["review_id": revewID,"login_token": login_token,"description":self.txtComment.text!]
        
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
                self.txtComment.text = ""
                self.fetchComments()
                SVProgressHUD.dismiss()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CommentViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
