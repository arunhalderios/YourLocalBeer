//
//  BeerListViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 12/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView
import PopupDialog
import Alamofire
import SVProgressHUD
import TCPickerView

class BeerListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BeerListTableViewCellDelegate,TCPickerViewOutput {

    // MARK: Outlets
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var beerAddOutlet: UIButton!
    @IBOutlet weak var beerTable: UITableView!
    var beerData = NSMutableArray()
    
    @IBOutlet weak var lblHeader: UILabel!
    var breweryName = String()
    var breweryID = String()
    var dataArray = NSMutableArray()
    var pageNo = Int()
    var sort_style = String()
    var logindict = String()
    var styleList = NSMutableArray()
    let cellReuseIdentifier = "cell"
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    var totalPageCount = Int()
    var isLoadingTableView = Bool()
    var filter_by = String()
    @IBOutlet weak var lblBeerNo: UILabel!
    var picker: TCPickerViewInput = TCPickerView()
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        lblHeader.text = "Brewery: \(breweryName)"
        // Do any additional setup after loading the view.
        
        pageNo = 1
        self.sort_style = "name||ASC"
        self.isLoadingTableView = false
        
        self.beerTable.rowHeight = UITableView.automaticDimension
        self.beerTable.estimatedRowHeight = 165;
        
        self.fetchBeerList()

        
//        if Connectivity.isConnectedToInternet {
//            print("Yes! internet is available.")
//            self.fetchBeerList()
//            // do some tasks..
//        }else{
//            let alert = UIAlertController(title: "Your Local Beer", message: "Check your internet connectivity", preferredStyle: UIAlertController.Style.alert)
//            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        let addressData = UserDefaults.standard.object(forKey: "key_currentaddress_info")
        if addressData == nil{
            let currentContinentData = UserDefaults.standard.object(forKey: "key_currentcontinent_info")
            let continent = NSKeyedUnarchiver.unarchiveObject(with: currentContinentData as! Data) as! String
            
            
            let currentCountryData = UserDefaults.standard.object(forKey: "key_currentdenycountry_info")
            let country = NSKeyedUnarchiver.unarchiveObject(with: currentCountryData as! Data) as! String
            
            let stateData = UserDefaults.standard.object(forKey: "key_currentdenystate_info")
            let state = NSKeyedUnarchiver.unarchiveObject(with: stateData as! Data) as! String
            
            let cityData = UserDefaults.standard.object(forKey: "key_currentdenycity_info")
            let city = NSKeyedUnarchiver.unarchiveObject(with: cityData as! Data) as! String
            
            
            logindict = "\(continent),\(country),\(state),\(city)"                       //ALASKA, 99515-1901"
        }else{
            logindict = NSKeyedUnarchiver.unarchiveObject(with: addressData as! Data) as! String
            print("UserDict: == \(logindict)")
        }
        
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "magnifying-glass"), style:  UIBarButtonItem.Style.plain, target: self, action: #selector(BeerListViewController.barButtonClickAction))
        
        // Only execute the code if there's a navigation controller
        if self.navigationController == nil {
            return
        }
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
    
    //MARK:- Fetch Beer List Api Call
    
    func fetchBeerList(){
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "beer_list"
        
        let newTodo: [String: Any] = ["brewery_id": breweryID,"sort": self.sort_style,"page_number":pageNo,"style":self.filter_by]
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
                if((json["beers"] as! Array<Any>).count>0){
                    self.isLoadingTableView = true
                       if self.filter_by == ""{
                            self.lblBeerNo.text = " \((json["total"] as! NSNumber).intValue) Beers"
                       }
                       else{
                            if(((json["total"] as! NSNumber).intValue) > 1){
                                self.lblBeerNo.text = "\((json["total"] as! NSNumber).intValue) \(self.filter_by)s"
                            }else{
                                self.lblBeerNo.text = "\((json["total"] as! NSNumber).intValue) \(self.filter_by)"
                            }
                        }
                    self.dataArray.addObjects(from: ((json["beers"] as! NSArray).mutableCopy() as! NSMutableArray) as! [Any])
                }else{
                    self.isLoadingTableView = false
                }
                self.beerTable.reloadData()
                SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Fetch Style List
    
    func fetchStyleList()
    {
        SVProgressHUD.show(withStatus: "It's working...")
        let todosEndpoint: String = BASE_URL + "styles_of_brewery"
        
        let newTodo: [String: Any] = ["brewery_id": breweryID]
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
                self.styleList = (json["styles"] as! NSArray).mutableCopy() as! NSMutableArray
                self.showPicker()
                SVProgressHUD.dismiss()
        }
    }
    
    
    //MARK:- Show style picker
    
    func showPicker(){
        picker.title = "Styles"
        let values = self.styleList.map { TCPickerView.Value(title: $0 as! String) }
        picker.values = values
        picker.delegate = self
        picker.selection = .single
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                print(values[i].title)
                //self.styleValue = values[i].title
                self.pageNo = 1
                self.dataArray = NSMutableArray()
                self.sort_style = "baRating||DESC"
                self.fetchBeerList()
            }
        }
        
        picker.closeAction = {
            self.filter_by = ""
            self.sort_style = ""
            self.pageNo = 1
            self.dataArray = NSMutableArray()
            self.fetchBeerList()
        }
        picker.show()
    }
    
    //MARK:- Picker view Delegate/DataSource
    
    func pickerView(_ pickerView: TCPickerViewInput, didSelectRowAtIndex index: Int) {
        print("Uuser select row at index: \(index)")
        self.filter_by = (self.styleList[index] as? String)!
    }
    
    
    //MARK:- Button Sort Action
    
    @IBAction func btnSortByDidTap(_ sender: Any) {
        let alert = UIAlertController()
        
        alert.view.layer.cornerRadius = 25
        
        let action1 = UIAlertAction(title: "Name", style: .default, handler: { (action) -> Void in
            print("Name selected!")
            self.filter_by = ""
            self.dataArray = NSMutableArray()
            self.sort_style = "name||ASC"
            self.pageNo = 1
            self.fetchBeerList()
        })
        
        let action2 = UIAlertAction(title: "Rating (High to Low)", style: .default, handler: { (action) -> Void in
            print("Ranking High to Low selected!")
            self.filter_by = ""
            self.dataArray = NSMutableArray()
            self.sort_style = "baRating||DESC"
            self.pageNo = 1
            self.fetchBeerList()
        })
        
        let action3 = UIAlertAction(title: "Rating (Low to High)", style: .default, handler: { (action) -> Void in
            print("Ranking Low to High selected!")
            self.filter_by = ""
            self.dataArray = NSMutableArray()
            self.pageNo = 1
            self.sort_style = "baRating||ASC"
            self.fetchBeerList()
        })
        
        let action4 = UIAlertAction(title: "Style", style: .default, handler: { (action) -> Void in
            print("Near By selected!")
            self.fetchStyleList()
        })
        
        let action5 = UIAlertAction(title: "Highest ABV%", style: .default, handler: { (action) -> Void in
            print("Highest ABV%")
            self.filter_by = ""
            self.dataArray = NSMutableArray()
            self.sort_style = "abv||DESC"
            self.pageNo = 1
            self.fetchBeerList()
        })
        
        let action6 = UIAlertAction(title: "Lowest ABV%", style: .default, handler: { (action) -> Void in
            print("Lowest ABV%")
            self.filter_by = ""
            self.dataArray = NSMutableArray()
            self.sort_style = "abv||ASC"
            self.pageNo = 1
            self.fetchBeerList()
        })
    
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // Add action buttons and present the Alert
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(action5)
        alert.addAction(action6)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews()
    {
        // Assumption is we're supporting a small maximum number of entries
        // so will set height constraint to content size
        // Alternatively can set to another size, such as using row heights and setting frame
        //heightConstraint.constant = self.styleTableList.contentSize.height
    }
    
    // Manage keyboard and tableView visibility
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return;
        }
    }
    
    
    //MARK: - TableView Deleagte/DataSource
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.beerTable{
            return 165
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.beerTable{
            if(dataArray.count == 0){
                return 1
            }else{
                return dataArray.count
            }
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == beerTable{
            if(dataArray.count == 0){
                var cell: NoDataTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
                
                if cell == nil {
                    
                    tableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: "NoDataTableViewCell")
                    
                    cell = beerTable.dequeueReusableCell(withIdentifier: "NoDataTableViewCell") as? NoDataTableViewCell
                }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }else{
                let cell = beerTable.dequeueReusableCell(withIdentifier:"beerCell", for: indexPath)as! BeerListTableViewCell
                let infoDic = ((self.dataArray) .object(at: indexPath.row) as! NSDictionary)
                print(infoDic)
                cell.beerName.text = "\(infoDic["name"]!)"
                cell.beerType.text = breweryName
                cell.beerStyle.text = "\(infoDic["style"]!)"
                
                cell.lblCount.text = String(indexPath.row + 1)
                cell.delegate = self
                cell.index = indexPath.row
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                let hads = Int("\(infoDic["baHads"]!)")
                
                if hads! >= 10{
                    cell.lblRating.isHidden = false
                    cell.lblNoScore.isHidden = true
                    cell.viewRating.isHidden = false
                    cell.lblRatingCount.isHidden = false
                    cell.viewRating.value = CGFloat(Float((infoDic["baRating"] as! NSNumber).floatValue))
                    let rateVal = Double("\(infoDic["baRating"]!)")
                    cell.lblRating.text =  String(format: "%.1f/10", rateVal!)
                    cell.lblRatingCount.text = "\(infoDic["baHads"]!) Ratings"
                    cell.lblRating.backgroundColor = UIColor(red: 53.0/255.0, green: 125.0/255.0, blue: 34.0/255.0, alpha: 1.0)
                }else if hads! > 0{
                    cell.lblRating.isHidden = false
                    cell.lblNoScore.isHidden = true
                    cell.viewRating.isHidden = false
                    cell.lblRatingCount.isHidden = false
                    cell.viewRating.value = CGFloat(Float((infoDic["baRating"] as! NSNumber).floatValue))
                    let rateVal = Double("\(infoDic["baRating"]!)")
                    cell.lblRating.text =  String(format: "%.1f/10", rateVal!)
                    cell.lblRatingCount.text = "\(infoDic["baHads"]!) Ratings"
                    cell.lblRating.backgroundColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0)
                }else{
                    cell.lblNoScore.isHidden = false
                    cell.viewRating.isHidden = true
                    cell.lblRatingCount.isHidden = true
                    cell.lblRating.isHidden = true
                    cell.lblNoScore.backgroundColor = UIColor.red
                    cell.lblNoScore.text = "No score yet"
                }
                if indexPath.row == self.dataArray.count - 1 && self.isLoadingTableView == true
                {
                    pageNo = pageNo + 1;
                    print("Page:== \(pageNo)")
                    self.fetchBeerList()
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
//        print("\(indexPath.row)")
//        if indexPath.row == dataArray.count - 1 && self.isLoadingTableView == true// last cell
//        {
//            pageNo = pageNo + 1;
//            print("Page:== \(pageNo)")
//            self.fetchBeerList()
//        }
//    }
    
    //MARK:- Custom Delegate Method
    
    func BeerListTableViewCell(_ obj: BeerListTableViewCell, info index: Int){
        print("Index: \(index)")
        let BeerDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerDetail") as! BeerDetailViewController
        let infoDic = ((self.dataArray) .object(at: index) as! NSDictionary)
        print(infoDic)
        BeerDetailViewController.beerID = "\(infoDic["_id"]!)"
        BeerDetailViewController.BeerName = "\(infoDic["name"]!)"
        //BeerDetailViewController.BreweryName = "\(infoDic["brewery"]!)"
        BeerDetailViewController.Style = "\(infoDic["style"]!)"
        self.navigationController?.pushViewController(BeerDetailViewController, animated: true)
    }
    
    func BeerListTableViewCell(_ obj: BeerListTableViewCell, rate index: Int)
    {
        print("Rate tapped of Index: \(index)")
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
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    func openReview(){
        // Create a custom view controller
        let reviewVC = ReviewViewController(nibName: "ReviewViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: reviewVC,
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
        let buttonTwo = DefaultButton(title: "REVIEW", height: 60) {
            //self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
            //self.label.text = ratingVC.commentTextField.text
            //print(reviewVC.commentTextField.text!)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    //MARK:- Add Beer Button
    @IBAction func btnAddBeerDidTap(_ sender: Any) {
        let EditBreweryViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditBrewery") as! EditBreweryViewController
        EditBreweryViewController.breweryID = breweryID
        EditBreweryViewController.fromAddBeer = true
        self.navigationController?.pushViewController(EditBreweryViewController, animated: true)
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
