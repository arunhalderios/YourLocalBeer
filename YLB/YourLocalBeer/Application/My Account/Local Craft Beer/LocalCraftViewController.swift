//
//  LocalCraftViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class LocalCraftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LocalCraftTableViewCellDelegate {

    
    @IBOutlet weak var localCraftTableView: UITableView!
    var dataArray = NSMutableArray()
    var logIndict = NSDictionary()
    var login_token = String()
    var craft_id = String()
    var totalPageCount = Int()
    var pageNo = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        dataArray = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Pri quas audiam virtute ut, case utamur fuisset eam ut, iisque accommodare an eam. Reque blandit qui eu, cu vix nonumy volumus. Legendos intellegam id usu, vide oporteat vix eu, id illud principes has. Nam tempor utamur gubergren no.","Ex soleat habemus usu, te nec eligendi deserunt vituperata. Natum consulatu vel ea, duo cetero repudiare efficiendi cu. Has at quas nonumy facilisis, enim percipitur mei ad. Mazim possim adipisci sea ei, omnium aeterno platonem mei no."]
        localCraftTableView.estimatedRowHeight = 117.0
        localCraftTableView.rowHeight = UITableView.automaticDimension
        
        self.fetchCraftList()
        
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
    
    //MARK:- Fetch Event List
    
    func fetchCraftList(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_crafts"
        
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
                let listPageArr = json["crafts"] as! NSArray
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
                        let arrConcert = (json["crafts"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.localCraftTableView.delegate = self
                        self.localCraftTableView.dataSource = self
                        self.localCraftTableView.reloadData()
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
        return 117.0
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
                
                cell = localCraftTableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }else{
            let cell = localCraftTableView.dequeueReusableCell(withIdentifier:"LocalCraftCell", for: indexPath)as! LocalCraftTableViewCell
            let dic = self.dataArray[indexPath.row] as! NSDictionary
            print(dic)
            
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
            
            if dic["description"] as? String != nil{
                let desstr = dic["description"] as? String
                let snack = desstr?.removingHTMLEntities
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .justified
                
                let str = snack?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
                let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue): paragraph]
                let attrString = NSAttributedString(string:str!, attributes: attributes)
                cell.lblComment.attributedText = attrString
            }
            
            cell.delegate = self
            cell.index = indexPath.row
            cell.lblComment.numberOfLines = 0
            cell.lblComment.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    //MARK:- Custom Delegate Method
    func LocalCraftTableViewCell(_ obj: LocalCraftTableViewCell, delete index: Int){
        print("Tapped index \(index)")
        let dic = self.dataArray[index] as! NSDictionary
        print(dic)
        self.craft_id = (dic["id"] as! NSNumber).stringValue
        self.deleteCraft()
    }

    //MARK:- Api Call to delete event
    func deleteCraft(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "delete_my_craft"
        
        let newTodo: [String: Any] = ["login_token": login_token,"craft_id":self.craft_id]
        
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
                self.fetchCraftList()
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
