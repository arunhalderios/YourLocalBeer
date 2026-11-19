//
//  BeerListTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 12/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit
import HCSStarRatingView

protocol BeerListTableViewCellDelegate: class {
    
    func BeerListTableViewCell(_ obj: BeerListTableViewCell, info index: Int)
    func BeerListTableViewCell(_ obj: BeerListTableViewCell, rate index: Int)
}

class BeerListTableViewCell: UITableViewCell {

    //MARK: - Custom Delegate Method Initialisation
    var delegate: BeerListTableViewCellDelegate?
    var index: Int?
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerType: UILabel!
    @IBOutlet weak var beerStyle: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var btnRateOutlet: UIButton!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var vwCategory: UIView!
    @IBOutlet weak var viewRating: HCSStarRatingView!
    @IBOutlet weak var lblNoScore: UILabel!
    @IBOutlet var lblCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblCount.layer.cornerRadius = self.lblCount.frame.size.width/2
        lblCount.clipsToBounds = true
        
        btnRateOutlet.layer.cornerRadius = 5
        lblRating.layer.cornerRadius = 5
        lblRating.clipsToBounds = true
        
        vwContent.layer.cornerRadius = 5
        vwContent.clipsToBounds = true
//        vwContent.layer.shadowColor = UIColor.red.cgColor
//        vwContent.layer.shadowOpacity = 0.5
//        vwContent.layer.shadowOffset = CGSize.zero
//        vwContent.layer.shadowRadius = 15
//        vwContent.layer.shadowPath = UIBezierPath(rect: vwContent.bounds).cgPath
//        vwContent.layer.shouldRasterize = true
        vwContent.addBorder(toSide: .Left, withColor: UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0).cgColor, andThickness: 4.0)
        
        vwCategory.layer.borderWidth = 2
        vwCategory.layer.borderColor = UIColor(red: 241.0/255.0, green: 128.0/255.0, blue: 24.0/255.0, alpha: 1.0).cgColor
        vwCategory.layer.cornerRadius = vwCategory.frame.size.width/2
        vwCategory.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnBeerDetailDidTap(_ sender: Any) {
        delegate?.BeerListTableViewCell((self as BeerListTableViewCell), info: index!)
    }
    @IBAction func btnRateDidTap(_ sender: Any) {
        delegate?.BeerListTableViewCell((self as BeerListTableViewCell), rate: index!)
    }
    
    
}

/*extension UIView {
    
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
}*/

