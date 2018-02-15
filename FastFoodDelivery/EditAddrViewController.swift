//
//  EditAddrViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 10/06/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import Firebase

class EditAddrViewController: UIViewController {

    @IBOutlet var postCodeTxt: UITextField!
    @IBOutlet var addressTxt: UITextField!
    var userProfile = [Users]()
    var userArray = [String:AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        // Do any additional setup after loading the view.
    }

    //save address into the firebase database
    @IBAction func saveBtn(_ sender: Any) {
        let dbRef = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userEmail = FIRAuth.auth()?.currentUser?.email
        self.userArray["location"] = self.addressTxt.text as AnyObject
        self.userArray["postcode"] = self.postCodeTxt.text as AnyObject
        dbRef.child("users").child(userID!).updateChildValues(userArray)
        
        //go back to root view controller
        self.navigationController?.popToRootViewController(animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUsers(){
        //get firebase authentication user id
        let userID = FIRAuth.auth()?.currentUser?.uid
        print("testing\(userID!)")
        let dbRef = FIRDatabase.database().reference()
        
        dbRef.child("users").child(userID!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let user = Users()
                user.setValuesForKeys(dictionary)
                user.name = dictionary["name"] as! String?
                self.userProfile.append(user)
                
                let u = self.userProfile[0]

                self.addressTxt.text = u.location
                self.postCodeTxt.text = u.postcode
            }
        },withCancel:nil)
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
