//
//  HomeTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 27/09/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol HomeTableViewCellDelegate: class {
    
    func HomeTableViewCell(_ obj: HomeTableViewCell, info index: Int)
    func HomeTableViewCell(_ obj: HomeTableViewCell, rate index: Int)
}

class HomeTableViewCell: UITableViewCell {

    //MARK: - Custom Delegate Method Initialisation
    var delegate: HomeTableViewCellDelegate?
    var index: Int?
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var vwInner: UIView!
    @IBOutlet weak var vwCategoryImage: UIImageView!
    @IBOutlet weak var vwCategory: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var btnRateOutlet: UIButton!
    @IBOutlet weak var lblNoScore: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vwContent.layoutIfNeeded()
        
        lblCount.layer.cornerRadius = self.lblCount.frame.size.width/2
        lblCount.clipsToBounds = true
        
        vwInner.layer.cornerRadius = 5
        vwInner.clipsToBounds = true
        
        lblRate.layer.cornerRadius = 5
        lblRate.clipsToBounds = true
        
        lblNoScore.layer.cornerRadius = 5
        lblNoScore.clipsToBounds = true

        vwInner.addBorder(toSide: .Left, withColor: UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0).cgColor, andThickness: 4.0)
        
        vwCategory.layer.borderWidth = 2
        vwCategory.layer.borderColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0).cgColor
        vwCategory.layer.cornerRadius = vwCategory.frame.size.width/2
        vwCategory.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnDetailsDidTap(_ sender: Any) {
        delegate?.HomeTableViewCell((self as HomeTableViewCell), info: index!)
    }
    
    @IBAction func btnRateDidTap(_ sender: Any) {
        delegate?.HomeTableViewCell((self as HomeTableViewCell), rate: index!)
    }
    
}

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}
