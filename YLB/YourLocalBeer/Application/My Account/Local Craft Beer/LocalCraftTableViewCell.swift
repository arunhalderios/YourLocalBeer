//
//  LocalCraftTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol LocalCraftTableViewCellDelegate: class {
    
    func LocalCraftTableViewCell(_ obj: LocalCraftTableViewCell, delete index: Int)
}

class LocalCraftTableViewCell: UITableViewCell {

    //MARK: - Custom Delegate Method Initialisation
    var delegate: LocalCraftTableViewCellDelegate?
    var index: Int?
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnDeleteOutlet.layer.cornerRadius = self.btnDeleteOutlet.frame.size.width/2
        btnDeleteOutlet.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnDeleteDidTap(_ sender: Any) {
        delegate?.LocalCraftTableViewCell((self as LocalCraftTableViewCell), delete: index!)
    }
}
