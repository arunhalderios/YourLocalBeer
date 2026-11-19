//
//  MapInfoView.swift
//  YLB
//
//  Created by Abhishek Mullick on 01/07/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import UIKit

class MapInfoView: UIView {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnDetailOutlet: UIButton!
    @IBOutlet weak var btnNavigateOutlet: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func btnDetailDidTap(_ sender: Any) {
        print("Details Tapped")
    }
    
    @IBAction func btnNavigateDidTap(_ sender: Any) {
        print("Navigate Tapped")
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MapInfoWindow", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
    
}
