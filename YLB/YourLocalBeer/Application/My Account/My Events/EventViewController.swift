//
//  EventViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


class EventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,EventTableViewCellDelegate {

    @IBOutlet weak var eventTableView: UITableView!
    var dataArray = NSMutableArray()
    var logIndict = NSDictionary()
    var login_token = String()
    var accudate1 = String()
    var accudate2 = String()
    var eventData = NSDictionary()
    var event_id = String()
    var totalPageCount = Int()
    var pageNo = Int()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.eventTableView.rowHeight = UITableView.automaticDimension
        self.eventTableView.estimatedRowHeight = 140;
        
        self.fetchEventList()
        // Do any additional setup after loading the view.
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
    
    func fetchEventList(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "my_events"
        
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
                let listPageArr = json["events"] as! NSArray
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
                        let arrConcert = (json["events"] as! NSArray).mutableCopy() as! NSMutableArray
                        for i in 0 ..< arrConcert.count
                        {
                            self.dataArray.add(arrConcert[i])
                            
                        }
                        self.eventTableView.delegate = self
                        self.eventTableView.dataSource = self
                        self.eventTableView.reloadData()
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
                
                cell = eventTableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }else{
            let cell = eventTableView.dequeueReusableCell(withIdentifier:"EventCell", for: indexPath)as! EventTableViewCell
            let dic = self.dataArray[indexPath.row] as! NSDictionary
            print(dic)
            cell.lblEventName.text = dic["event_title"] as? String
            let string1 = "\(dic["event_start_date"]!)"
            let string2 = "\(dic["event_end_date"]!)"
            
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "E MMM-d-yyyy h:mm a"
            
            if let date = dateFormatterGet.date(from: string1) {
                print(dateFormatterPrint.string(from: date))
                accudate1 = dateFormatterPrint.string(from: date)
            } else {
                print("There was an error decoding the string")
            }
            
            if let date2 = dateFormatterGet.date(from: string2) {
                print(dateFormatterPrint.string(from: date2))
                accudate2 = dateFormatterPrint.string(from: date2)
            } else {
                print("There was an error decoding the string")
            }
            
            cell.lblEventDate.text = "\(accudate1) - \(accudate2)"
            cell.lblEventLocation.text = dic["event_location"] as? String
            cell.delegate = self
            cell.index = indexPath.row
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    //MARK:- Custom Delegate Method
    func EventTableViewCell(_ obj: EventTableViewCell, info index: Int){
        print("Tapped index \(index)")
        let EventDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "EventDetail") as! EventDetailViewController
        let dic = self.dataArray[index] as! NSDictionary
        print(dic)
        self.eventData = dic
        EventDetailViewController.eventData = self.eventData
        self.navigationController?.pushViewController(EventDetailViewController, animated: true)
    }
    
    func EventTableViewCell(_ obj: EventTableViewCell, delete index: Int){
        print("Tapped index \(index)")
        let dic = self.dataArray[index] as! NSDictionary
        print(dic)
        self.event_id = (dic["id"] as! NSNumber).stringValue
        self.deleteEvent()
    }
    
    //MARK:- Api Call to delete event
    func deleteEvent(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "delete_my_events"
        
        let newTodo: [String: Any] = ["login_token": "ddd928424197406f808a29010de114ed","event_id":self.event_id]
        
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
                self.fetchEventList()
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
