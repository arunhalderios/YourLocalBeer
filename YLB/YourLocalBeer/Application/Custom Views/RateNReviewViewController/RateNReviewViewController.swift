//
//  RateNReviewViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 08/11/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView
import IQKeyboardManagerSwift

class RateNReviewViewController: UIViewController {

    //MARK:- Variable Declaration
    var toggleIsOn = Bool()
    var anonymousStatus = String()
    @IBOutlet weak var btnanonymousOutlet: UIButton!
    @IBOutlet weak var lblStaticReviewText: UILabel!
    
    @IBOutlet weak var lblAppearanceValue: UILabel!
    @IBOutlet weak var appearanceView: HCSStarRatingView!
    
    @IBOutlet weak var lblAromaValue: UILabel!
    @IBOutlet weak var aromaView: HCSStarRatingView!
    
    
    @IBOutlet weak var lblMouthfeelValue: UILabel!
    @IBOutlet weak var mouthfeelView: HCSStarRatingView!
    
    
    @IBOutlet weak var lblTasteValue: UILabel!
    @IBOutlet weak var tasteView: HCSStarRatingView!
    
    
    @IBOutlet weak var lblDrinkValue: UILabel!
    @IBOutlet weak var drinkView: HCSStarRatingView!
    
    
    @IBOutlet weak var lblOverallValue: UILabel!
    @IBOutlet weak var OverallView: HCSStarRatingView!
    
    @IBOutlet weak var innerScroll: UIScrollView!
    @IBOutlet weak var txtComment: IQTextView!
    
    //MARK:- View lifecycle
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
    }

    override func viewWillAppear(_ animated: Bool) {
        innerScroll.contentSize = CGSize(width: self.innerScroll.frame.size.width, height: 500)
    }
    
    //MARK:- Button actions
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
    
    @IBAction func appearanceValue(_ sender: HCSStarRatingView) {
        if (appearanceView.value == 0 || appearanceView.value == -0 || appearanceView.value == 0.0){
            lblAppearanceValue.text = "0"
        }else{
            let x = Double(appearanceView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblAppearanceValue.text = "\(x)"
        }
    }
    
    @IBAction func aromaValue(_ sender: Any) {
        if (aromaView.value == 0 || aromaView.value == -0){
            lblAromaValue.text = "0"
        }else{
            let x = Double(aromaView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblAromaValue.text = "\(x)"
        }
        
    }
    
    @IBAction func mouthfeelValue(_ sender: Any) {
        if (mouthfeelView.value == 0 || mouthfeelView.value == -0){
            lblMouthfeelValue.text = "0"
        }else{
            let x = Double(mouthfeelView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblMouthfeelValue.text = "\(x)"
        }
    }
    
    @IBAction func tasteValue(_ sender: Any) {
        if (tasteView.value == 0 || tasteView.value == -0){
            lblTasteValue.text = "0"
        }else{
            let x = Double(tasteView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblTasteValue.text = "\(x)"
        }
    }
    
    @IBAction func drinkValue(_ sender: Any) {
        if (drinkView.value == 0 || drinkView.value == -0){
            lblDrinkValue.text = "0"
        }else{
            let x = Double(drinkView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblDrinkValue.text = "\(x)"
        }
    }
    
    @IBAction func overallValue(_ sender: Any) {
        if (OverallView.value == 0 || OverallView.value == -0){
            lblOverallValue.text = "0"
        }else{
            let x = Double(OverallView.value).rounded(toPlaces: 1)
            //let y = x * 2
            lblOverallValue.text = "\(x)"
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
