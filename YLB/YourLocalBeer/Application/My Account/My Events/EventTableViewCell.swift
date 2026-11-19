//
//  EventTableViewCell.swift
//  YLB
//
//  Created by Abhishek Mullick on 18/07/18.
//  Copyright © 2018 Abhishek Mullick. All rights reserved.
//

import UIKit

protocol EventTableViewCellDelegate: class {
    
    func EventTableViewCell(_ obj: EventTableViewCell, info index: Int)
    func EventTableViewCell(_ obj: EventTableViewCell, delete index: Int)
}

class EventTableViewCell: UITableViewCell {

    //MARK: - Custom Delegate Method Initialisation
    var delegate: EventTableViewCellDelegate?
    var index: Int?
    
    //MARK: - Variable Declaration
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblEventDate: UILabel!
    @IBOutlet weak var btnInfoOutlet: UIButton!
    @IBOutlet weak var btnDeleteOutlet: UIButton!
    @IBOutlet weak var lblEventLocation: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnInfoOutlet.layer.cornerRadius = self.btnInfoOutlet.frame.size.width/2
        btnInfoOutlet.layer.masksToBounds = true
        
        btnDeleteOutlet.layer.cornerRadius = self.btnDeleteOutlet.frame.size.width/2
        btnDeleteOutlet.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnInfoDidTap(_ sender: Any) {
        delegate?.EventTableViewCell((self as EventTableViewCell), info: index!)
    }
    
    @IBAction func btnDeleteDidTap(_ sender: Any) {
        delegate?.EventTableViewCell((self as EventTableViewCell), delete: index!)
    }
    
}
