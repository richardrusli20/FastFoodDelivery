//
//  ProfileViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 7/06/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var fullNameTxtField: UITextField!
    @IBOutlet var phoneTxtField: UITextField!
    @IBOutlet var locationTxtField: UITextField!
    @IBOutlet var postCodeTxtField: UITextField!
    @IBOutlet var profileImg: UIImageView!
    var selectedImage : UIImage!
    var userArray : [String:AnyObject] = [:]
     var userProfile = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        self.phoneTxtField.delegate = self;
        self.postCodeTxtField.delegate = self;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.handleSelectProfileImageView))
        profileImg.addGestureRecognizer(tapGesture)
        profileImg.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func phone_change(_ sender: UITextField) {
        maxLength(textFieldName: phoneTxtField, max2: 10)
    }
    
    @IBAction func postCode_change(_ sender: UITextField) {
        maxLength(textFieldName: postCodeTxtField, max2: 4)
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        let dbRef = FIRDatabase.database().reference()
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userEmail = FIRAuth.auth()?.currentUser?.email
        let storageRef = FIRStorage.storage().reference(forURL: "gs://fit3027-ios-project.appspot.com").child("profile_image").child(userID!)
        
        if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1){
            storageRef.put(imageData, metadata:nil, completion: { (metadata,error) in
                if error != nil {
                    return
                }
                let profileImageURL = metadata?.downloadURL()?.absoluteString
                
        //append a userArray anyobject string with a list of objects that will be sent to firebase
        self.userArray["name"] = self.fullNameTxtField.text as AnyObject
        self.userArray["email"] = userEmail as AnyObject
        self.userArray["location"] = self.locationTxtField.text as AnyObject
        self.userArray["postcode"] = self.postCodeTxtField.text as AnyObject
        self.userArray["phone"] = self.phoneTxtField.text as AnyObject
        self.userArray["profileImage"] = profileImageURL as AnyObject?
        dbRef.child("users").child(userID!).setValue(self.userArray)
            
        self.saveAlert()
            })
        }
            else{
            //append a userArray anyobject string with a list of objects that will be sent to firebase
            //without the profile image which is not necessary for user to put their image
            self.userArray["name"] = self.fullNameTxtField.text as AnyObject
            self.userArray["email"] = userEmail as AnyObject
            self.userArray["location"] = self.locationTxtField.text as AnyObject
            self.userArray["postcode"] = self.postCodeTxtField.text as AnyObject
            self.userArray["phone"] = self.phoneTxtField.text as AnyObject
            dbRef.child("users").child(userID!).setValue(self.userArray)
                saveAlert()
            }
    }

    @IBAction func backToOrders(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(destVC, animated: true, completion: nil)
    }

    
    func saveAlert(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //get users data and present it
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
                user.profileImage = dictionary["profileImage"] as! String?
                self.userProfile.append(user)
                
                let u = self.userProfile[0]
                self.fullNameTxtField.text = u.name
                self.phoneTxtField.text = u.Phone
                self.locationTxtField.text = u.location
                self.postCodeTxtField.text = u.postcode
                print(u.profileImage)
                if (u.profileImage == "") || (u.profileImage == nil) {
                    
                }
                else{

                    self.profileImg.loadImageUsingCacheWithUrlString(urlString: u.profileImage!)
                }

            }
        },withCancel:nil)
    }
    
    
    //handle the profile image clicks
    func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true,completion: nil)
    }
    
    //handle the input should only be integer
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    //handle the input length
    func maxLength(textFieldName:UITextField, max2:Int){
        var length = textFieldName.text?.characters.count
        var text = textFieldName.text
        if(length! > max2)
        {
            let index = text?.index((text?.startIndex)!, offsetBy: max2)
            textFieldName.text = textFieldName.text?.substring(to: index!)
        }
    }

}

    //extension of profile image clicks, saving the image
    extension ProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[String:Any]){
        print("did finish picking photos")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImg.image = image
        }
        else{
            print("something is not right")
        }
        print(info)
        self.dismiss(animated: true, completion: nil)
    }
}
