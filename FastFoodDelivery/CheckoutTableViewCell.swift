//
//  CheckoutTableViewCell.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 7/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {

    @IBOutlet var foodNameLbl: UILabel!
    @IBOutlet var foodQtyLbl: UILabel!
    @IBOutlet var foodPriceLbl: UILabel!
    @IBOutlet var plusBtn: UIButton!
    @IBOutlet var minusBtn: UIButton!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
