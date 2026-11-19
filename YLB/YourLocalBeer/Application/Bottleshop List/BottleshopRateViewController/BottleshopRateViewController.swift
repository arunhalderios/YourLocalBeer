//
//  BottleshopRateViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 08/11/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView
import IQKeyboardManagerSwift

class BottleshopRateViewController: UIViewController {

    //MARK:- Varibale Declaration
    var toggleIsOn = Bool()
    var anonymousStatus = String()
    @IBOutlet weak var btnanonymousOutlet: UIButton!
    @IBOutlet weak var lblStaticReviewText: UILabel!
    
    @IBOutlet weak var lblAmbienceValue: UILabel!
    @IBOutlet weak var ambienceView: HCSStarRatingView!
    
    @IBOutlet weak var lblQualityValue: UILabel!
    @IBOutlet weak var qualityView: HCSStarRatingView!
    
    
    @IBOutlet weak var lblSelectionValue: UILabel!
    @IBOutlet weak var selectionView: HCSStarRatingView!
    
    
    @IBOutlet weak var lblStaffValue: UILabel!
    @IBOutlet weak var staffView: HCSStarRatingView!
    
    
    @IBOutlet weak var lblFoodValue: UILabel!
    @IBOutlet weak var foodView: HCSStarRatingView!
    
    @IBOutlet weak var txtComment: IQTextView!
    
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var valueView: HCSStarRatingView!
    
    var fromBottleBeer = String()
    @IBOutlet weak var lblStaticStaffText: UILabel!
    @IBOutlet weak var lblStaticFoodText: UILabel!
    
    
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        self.anonymousStatus = "0"
        // Do any additional setup after loading the view.
        txtComment.layer.cornerRadius = 5
        txtComment.layer.borderWidth = 1.0
        txtComment.layer.borderColor = UIColor.lightGray.cgColor
        
        if fromBottleBeer == "bottle"{
            fromBottleBeer = "bottle"
            self.lblStaticFoodText.text = "Service"
            self.lblStaticStaffText.text = "Staff"
        }else{
            fromBottleBeer = "bar"
        }
    }

    //MARK:- Button Action
    @IBAction func btnAnonymousStatusDidTap(_ sender: Any) {
        toggleIsOn = !toggleIsOn;
        if(toggleIsOn){
            //do anything else you want to do.
            self.btnanonymousOutlet.setImage(UIImage(named:"checked.png"), for:.normal);
            self.anonymousStatus = "1"
        }
        else {
            //do anything you want to do.
            self.btnanonymousOutlet.setImage(UIImage(named:"unchecked.png"), for:.normal);
            self.anonymousStatus = "0"
        }
    }
    
    @IBAction func ambienceValue(_ sender: HCSStarRatingView) {
        if (ambienceView.value == 0 || ambienceView.value == -0 || ambienceView.value == 0.0){
            print(ambienceView.value)
            lblAmbienceValue.text = "0"
        }else{
            let x = Double(ambienceView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblAmbienceValue.text = "\(x)"
        }
    }
    
    @IBAction func qualityValue(_ sender: Any) {
        if (qualityView.value == 0 || qualityView.value == -0){
            lblQualityValue.text = "0"
        }else{
            let x = Double(qualityView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblQualityValue.text = "\(x)"
        }
    }
    
    @IBAction func selectionValue(_ sender: Any) {
        if (selectionView.value == 0 || selectionView.value == -0){
            lblSelectionValue.text = "0"
        }else{
            let x = Double(selectionView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblSelectionValue.text = "\(x)"
        }
    }
    
    @IBAction func staffValue(_ sender: Any) {
        if (staffView.value == 0 || staffView.value == -0){
            lblStaffValue.text = "0"
        }else{
            let x = Double(staffView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblStaffValue.text = "\(x)"
        }
    }
    
    @IBAction func foodValue(_ sender: Any) {
        if (foodView.value == 0 || foodView.value == -0){
            lblFoodValue.text = "0"
        }else{
            let x = Double(foodView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblFoodValue.text = "\(x)"
        }
    }
    
    @IBAction func Value(_ sender: Any) {
        if (valueView.value == 0 || valueView.value == -0){
            lblValue.text = "0"
        }else{
            let x = Double(valueView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblValue.text = "\(x)"
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
