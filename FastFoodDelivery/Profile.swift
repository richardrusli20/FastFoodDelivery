//
//  myprofile.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 8/06/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation
class Profile :UIViewController{
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
