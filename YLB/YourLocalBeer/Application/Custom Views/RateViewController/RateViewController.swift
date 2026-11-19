//
//  RateViewController.swift
//  YLB
//
//  Created by Abhishek Mullick on 08/11/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView


class RateViewController: UIViewController {

    //MARK:- Variable Declaration
    var toggleIsOn = Bool()
    var anonymousStatus = String()
    @IBOutlet weak var btnanonymousOutlet: UIButton!
    
    @IBOutlet weak var lblAppearanceValue: UILabel!
    @IBOutlet weak var appearanceView: HCSStarRatingView!
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
