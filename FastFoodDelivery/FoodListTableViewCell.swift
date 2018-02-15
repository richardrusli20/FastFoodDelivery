//
//  FoodListTableViewCell.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 3/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {
    
    @IBOutlet var foodName: UILabel!
    @IBOutlet var foodPrice: UILabel!
    @IBOutlet var imageCell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
