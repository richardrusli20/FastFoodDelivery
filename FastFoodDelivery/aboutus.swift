//
//  aboutus.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 22/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation
class aboutus :UIViewController{
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
