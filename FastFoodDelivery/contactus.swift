//
//  contactus.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 22/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation
class contactus :UIViewController{
    @IBOutlet var menuBtn: UIBarButtonItem!
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        let menuItem = UIBarButtonItem(image: UIImage(named: "icon_menu"), style: .plain, target: self, action: Selector(("menuBarButtonItemClicked")))
//        menuItem.tintColor = UIColor.white
//        self.navigationItem.leftBarButtonItem = menuItem
    }
}
