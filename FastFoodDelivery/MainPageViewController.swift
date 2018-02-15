//
//  MainPageViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 9/06/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {


    @IBOutlet var delivery: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.handleSelectProfileImageView))

        delivery.addGestureRecognizer(tapGesture)
        delivery.isUserInteractionEnabled = true
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //a button that present to the menu page
    @IBAction func DeliveryBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
    
    
    //handle imagepicker to redirect view into the menu page
    func handleSelectProfileImageView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(secondVC, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
