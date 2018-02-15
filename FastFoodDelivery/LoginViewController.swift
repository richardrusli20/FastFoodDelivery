//
//  LoginViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 2/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!

    
    @IBAction func loginButton(_ sender: AnyObject) {
        //saving the user into user defaults
        let defaults = UserDefaults.standard
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
        
        //Firebase authentication sign in
        FIRAuth.auth()?.signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!, completion: {
            user, error in
            if error != nil{
                let myAlert = UIAlertController(title: "Email or password is not correct", message: "", preferredStyle:UIAlertControllerStyle.alert )
                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
                self.present(myAlert, animated:true, completion:nil)
                print("Email or password is not Correct")
            }
            else{
                //present the List of Food view controller
                defaults.set(self.emailTxtField.text, forKey: "email")
                defaults.set(self.passwordTxtField.text, forKey: "password")
                defaults.synchronize()
                
                self.present(secondVC, animated: true, completion: nil)
                print("login successful")
            }
        })
    }
    
    //loading saved user defaults and show it to the user.
    func loadDefaults(){
        let defaults = UserDefaults.standard
        emailTxtField.text = defaults.object(forKey: "email") as? String
        passwordTxtField.text = defaults.object(forKey: "password") as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDefaults()
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
// Pass the selected object to the new view controller.
    }
    


}
