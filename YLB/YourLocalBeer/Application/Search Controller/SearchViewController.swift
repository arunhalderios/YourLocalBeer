//
//  SearchViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 13/05/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class SearchViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var btnBeerOutlet: UIButton!
    @IBOutlet weak var btnBreweryOutlet: UIButton!
    @IBOutlet weak var btnBarOutlet: UIButton!
    @IBOutlet weak var btnBottleOutlet: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblSearchList: UITableView!
    var beercount = Int()
    var brewerycount = Int()
    var barcount = Int()
    var bottlecount = Int()
    var type = String()
    var dataarray = NSMutableArray()
    var tempData = [String]()
    var cellReuseIdentifier = "cell"
    var search:String=""
    var fromBrewery = Bool()
    var fromBeer = Bool()
    var fromBar = Bool()
    var fromBottle = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        tblSearchList.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.txtSearch.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Search for a specific beer or place"
    }
    
    //MARK:- Button Actions
    
    @IBAction func btnBeerDidTap(_ sender: Any) {
        self.txtSearch.isUserInteractionEnabled = true
        fromBrewery = false
        fromBar = false
        fromBottle = false
        fromBeer = true
        self.dataarray = NSMutableArray()
        self.tblSearchList.reloadData()
        beercount = beercount + 1
        self.txtSearch.becomeFirstResponder()
        self.txtSearch.text = ""
        if(btnBeerOutlet.isSelected != true)
        {
            btnBeerOutlet.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
            btnBeerOutlet.isSelected = true
            btnBreweryOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBreweryOutlet.isSelected = false
            btnBarOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBarOutlet.isSelected = false
            btnBottleOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBottleOutlet.isSelected = false
            type = "beer"
            
//            if(femalebutton.isSelected == true && femalecount != 0)
//            {
//                femalebutton.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
//                femalebutton.isSelected = false
//            }
        }
            
        else
        {
            btnBeerOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBeerOutlet.isSelected = false
        }
    }
    
    @IBAction func btnBreweryDidTap(_ sender: Any) {
        self.txtSearch.isUserInteractionEnabled = true
        fromBrewery = true
        fromBar = false
        fromBottle = false
        fromBeer = false
        self.dataarray = NSMutableArray()
        self.tblSearchList.reloadData()
        brewerycount = brewerycount + 1
        self.txtSearch.becomeFirstResponder()
        self.txtSearch.text = ""
        if(btnBreweryOutlet.isSelected != true)
        {
            btnBeerOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBeerOutlet.isSelected = false
            btnBreweryOutlet.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
            btnBreweryOutlet.isSelected = true
            btnBarOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBarOutlet.isSelected = false
            btnBottleOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBottleOutlet.isSelected = false
            type = "brewery"
        }
            
        else
        {
            btnBreweryOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBreweryOutlet.isSelected = false
        }
    }
    
    @IBAction func btnBarDidTap(_ sender: Any) {
        self.txtSearch.isUserInteractionEnabled = true
        fromBrewery = false
        fromBar = true
        fromBottle = false
        fromBeer = false
        self.dataarray = NSMutableArray()
        self.tblSearchList.reloadData()
        barcount = barcount + 1
        self.txtSearch.becomeFirstResponder()
        self.txtSearch.text = ""
        if(btnBarOutlet.isSelected != true)
        {
            btnBeerOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBeerOutlet.isSelected = false
            btnBreweryOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBreweryOutlet.isSelected = false
            btnBarOutlet.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
            btnBarOutlet.isSelected = true
            btnBottleOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBottleOutlet.isSelected = false
            type = "bar"
        }
            
        else
        {
            btnBarOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBarOutlet.isSelected = false
        }
    }
    
    @IBAction func btnBottleDidTap(_ sender: Any) {
        self.txtSearch.isUserInteractionEnabled = true
        fromBrewery = false
        fromBar = false
        fromBottle = true
        fromBeer = false
        self.dataarray = NSMutableArray()
        self.tblSearchList.reloadData()
        bottlecount = bottlecount + 1
        self.txtSearch.becomeFirstResponder()
        self.txtSearch.text = ""
        if(btnBottleOutlet.isSelected != true)
        {
            btnBeerOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBeerOutlet.isSelected = false
            btnBreweryOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBreweryOutlet.isSelected = false
            btnBarOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBarOutlet.isSelected = false
            btnBottleOutlet.setImage(UIImage(named: "radio-on-button.png"), for: UIControl.State.normal)
            btnBottleOutlet.isSelected = true
            type = "bottleshop"
        }
            
        else
        {
            btnBottleOutlet.setImage(UIImage(named: "circle-shape-outline.png"), for: UIControl.State.normal)
            btnBottleOutlet.isSelected = false
        }
    }
    
    //MARK:- Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        if string.isEmpty
        {
            search = String(search.dropLast())
        }
        else
        {
            search=textField.text!+string
        }
        
        print(search)
        
        if search.count >= 4{
            self.fetchSearchList()
        }
        else if search.count == 0{
            self.dataarray = NSMutableArray()
            self.tblSearchList.delegate = self
            self.tblSearchList.dataSource = self
            self.tblSearchList.reloadData()
        }
        return true
    }
    
    //MARK:- Search List Api
    
    func fetchSearchList(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "search_autocomplete"
        
        let newTodo: [String: Any] = ["search_str": self.txtSearch.text!,"type": self.type]
        
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
                if (json["lists"] as! NSArray).count > 0{
                    self.dataarray = NSMutableArray()
                    self.dataarray = (json["lists"] as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for conversationID in self.dataarray {
                        let snapshotValue = conversationID as? NSDictionary
                        if let value = snapshotValue!["name"] as? String {
                            self.tempData.append(value)
                        }
                    }
                    self.tblSearchList.reloadData()
                    self.tblSearchList.delegate = self
                    self.tblSearchList.dataSource = self
                }else{
                    self.tblSearchList.delegate = self
                    self.tblSearchList.dataSource = self
                    self.tblSearchList.reloadData()
                }
                SVProgressHUD.dismiss()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.txtSearch){
            print(type)
        }
    }

    //MARK:- Tableview Delegate/Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataarray.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(self.dataarray.count > 0) && (self.dataarray.count > indexPath.row){
            let cell:UITableViewCell = self.tblSearchList.dequeueReusableCell(withIdentifier:cellReuseIdentifier, for: indexPath)
            let dic = self.dataarray[indexPath.row] as! NSDictionary
            if fromBeer == true{
                 cell.textLabel?.text = "\((dic["name"] as? String)!) (\((dic["brewery"] as? String)!))"
            }else{
                if (dic["state"] as? String) == nil{
                    cell.textLabel?.text = "\((dic["name"] as? String)!) (\((dic["city"] as? String)!), \((dic["country"] as? String)!))"
                }else{
                    cell.textLabel?.text = "\((dic["name"] as? String)!) (\((dic["city"] as? String)!), \((dic["state"] as? String)!), \((dic["country"] as? String)!))"
                }
            }
            
            //cell?.imageView?.image = #imageLiteral(resourceName: "ic_history").withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = UIColor.gray
            cell.contentView.backgroundColor = .white
            return cell
        }else{
            let cell:UITableViewCell = self.tblSearchList.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
            
            //cell?.textLabel?.text = "No data found"
            //cell?.textLabel?.textAlignment = .center
            cell.imageView?.tintColor = UIColor.gray
            cell.contentView.backgroundColor = .white
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.fromBrewery == true{
            let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "BreweryDetail") as! BreweryDetailViewController
            let dic = self.dataarray[indexPath.row] as! NSDictionary
            print(dic)
            HomeViewController.breweryID = (dic["_id"] as? String)!
            //HomeViewController.fromBrewery = true
            self.navigationController?.pushViewController(HomeViewController, animated: true)
        }else if self.fromBeer == true{
            let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerDetail") as! BeerDetailViewController
            let dic = self.dataarray[indexPath.row] as! NSDictionary
            print(dic)
            HomeViewController.beerID = (dic["_id"] as? String)!
            //HomeViewController.fromBeer = true
            self.navigationController?.pushViewController(HomeViewController, animated: true)
        }else if self.fromBar == true{
            let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetail") as! RestaurantDetailViewController
            let dic = self.dataarray[indexPath.row] as! NSDictionary
            print(dic)
            HomeViewController.barID = (dic["_id"] as? String)!
            //HomeViewController.fromBar = true
            self.navigationController?.pushViewController(HomeViewController, animated: true)
        }else{
            let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "BottleshopDetail") as! BottleshopDetailViewController
            let dic = self.dataarray[indexPath.row] as! NSDictionary
            print(dic)
            HomeViewController.bottleID = (dic["_id"] as? String)!
            //HomeViewController.fromBottle = true
            self.navigationController?.pushViewController(HomeViewController, animated: true)
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
