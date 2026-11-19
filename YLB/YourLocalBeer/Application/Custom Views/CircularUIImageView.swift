//
//  CircularUIImageView.swift
//  SettingNeeds
//
//  Created by Efflorescence 1 on 05/11/18.
//  Copyright © 2018 Efflorescence. All rights reserved.
//

import UIKit

@IBDesignable
class CircularUIImageView: UIImageView {

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
            // self.layer.masksToBounds = self.borderWidth > 0
        }
    }
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet{
//            self.layer.cornerRadius = self.cornerRadius
//        }
//    }
    @IBInspectable var borderColor:UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    func customizeView(){
        self.layer.cornerRadius = self.layer.frame.width / 2
        // self.layer.borderWidth = 6
        //self.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.masksToBounds = true
        //clipsToBounds = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
