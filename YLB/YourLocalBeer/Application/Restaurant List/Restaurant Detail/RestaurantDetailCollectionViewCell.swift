//
//  RestaurantDetailCollectionViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 20/06/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol RestaurantDetailCollectionViewCellDelegate: class {
    
    func RestaurantDetailCollectionViewCell(_ obj: RestaurantDetailCollectionViewCell, camera index: Int)
    
    func RestaurantDetailCollectionViewCell(_ obj: RestaurantDetailCollectionViewCell, delete index: Int)
}

class RestaurantDetailCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Custom Delegate Method Initialisation
    var delegate: RestaurantDetailCollectionViewCellDelegate?
    var index: Int?
    
    @IBOutlet weak var barImage: UIImageView!
    @IBOutlet weak var btnCameraOutlet: UIButton!
    @IBOutlet var btnDeleteOutlet: UIButton!
    
    
    @IBAction func btnCameraDidTap(_ sender: Any) {
        delegate?.RestaurantDetailCollectionViewCell((self as RestaurantDetailCollectionViewCell), camera: index!)
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        delegate?.RestaurantDetailCollectionViewCell((self as RestaurantDetailCollectionViewCell), delete: index!)
    }
    
    
}
