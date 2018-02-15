//
//  RegisterViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 23/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var nameReg: UITextField!
    @IBOutlet var emailReg: UITextField!
    @IBOutlet var passwordReg: UITextField!
    @IBOutlet var locationReg: UITextField!
    @IBOutlet var postcodeReg: UITextField!
    @IBOutlet var phoneReg: UITextField!
    @IBOutlet var profileImage: UIImageView!
    var selectedImage : UIImage?
    
    @IBAction func postcode_change(_ sender: UITextField) {
        maxLength(textFieldName: postcodeReg, max2: 4)
    }
    
    @IBAction func phone_change(_ sender: UITextField) {
        maxLength(textFieldName: phoneReg, max2: 10)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneReg.delegate = self;
        self.postcodeReg.delegate = self;
        
        
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func registerBtn(_ sender: Any) {
        handleRegister()
    }
    
    
    
    func handleRegister(){
        if nameReg.text == ""{
            let myAlert = UIAlertController(title: "Please fill in the blank.", message: "", preferredStyle:UIAlertControllerStyle.alert )
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
            self.present(myAlert, animated:true, completion:nil)
            print("Please fill in the blank")
        }
        else if locationReg.text == "" {
            let myAlert = UIAlertController(title: "Please fill in the blank.", message: "", preferredStyle:UIAlertControllerStyle.alert )
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
            self.present(myAlert, animated:true, completion:nil)
            print("Please fill in the blank")
        }
        else if emailReg.text == "" {
            let myAlert = UIAlertController(title: "Please fill in the blank.", message: "", preferredStyle:UIAlertControllerStyle.alert )
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
            self.present(myAlert, animated:true, completion:nil)
            print("Please fill in the blank")
        }
        else if passwordReg.text == "" {
            let myAlert = UIAlertController(title: "Please fill in the blank.", message: "", preferredStyle:UIAlertControllerStyle.alert )
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
            self.present(myAlert, animated:true, completion:nil)
            print("Please fill in the blank")
        }
        else if postcodeReg.text == ""{
            let myAlert = UIAlertController(title: "Please fill in the blank.", message: "", preferredStyle:UIAlertControllerStyle.alert )
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
            self.present(myAlert, animated:true, completion:nil)
            print("Please fill in the blank")
        }
        else if phoneReg.text == ""{
            let myAlert = UIAlertController(title: "Please fill in the blank.", message: "", preferredStyle:UIAlertControllerStyle.alert )
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
            self.present(myAlert, animated:true, completion:nil)
            print("Please fill in the blank")
        }
        else{
            
        guard let name = nameReg.text, let email = emailReg.text, let password = passwordReg.text, let location = locationReg.text, let postcode = postcodeReg.text, let phone = phoneReg.text
            else{
            print("Form is not valid")
            return
        }
            
            //create a new user in the firebase
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user:FIRUser?, error) in
                
            if error != nil{
                let myAlert = UIAlertController(title: "Please enter the correct email", message: "Password should be more than 6 digits", preferredStyle:UIAlertControllerStyle.alert )
                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default))
                self.present(myAlert, animated:true, completion:nil)
                print("Email or password is not Correct")
                print (error)
                return
            }
            
                
            
            //successfully authenticates user
            let uid = user?.uid
            let ref = FIRDatabase.database().reference(fromURL: "https://fit3027-ios-project.firebaseio.com/")
            let userReference = ref.child("users").child(uid!)
            let storageRef = FIRStorage.storage().reference(forURL: "gs://fit3027-ios-project.appspot.com").child("profile_image").child(uid!)
            
            //if the profileimage is selected then put data with profile image
            if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1){
                storageRef.put(imageData, metadata:nil, completion: { (metadata,error) in
                    if error != nil {
                        return
                    }
                    let profileImageURL = metadata?.downloadURL()?.absoluteString
                    print(profileImageURL)
                    let values = ["name" : name,"email" : email, "location" : location, "postcode" : postcode,"phone":phone, "profileImage" :profileImageURL]
                    //update child valuses in the firebase
                    userReference.updateChildValues(values, withCompletionBlock: {(err,ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                        else{
                        let alertController = UIAlertController(title: "Thank you for registering", message: "", preferredStyle: .alert)
                        let backToSignIn = UIAlertAction(title: "OK", style: .cancel, handler: { action in self.performSegue(withIdentifier: "backToSignIn", sender: self)})
                        alertController.addAction(backToSignIn)
                        self.present(alertController, animated: true, completion: nil)
                        print("User successfully saved into Firebase DB")
                        //                self.dismiss(animated: true, completion: nil)
                        }
                        })
                    })
                }
                
            //else profile image not selected put data without image
            else{
                let values = ["name" : name,"email" : email, "location" : location, "postcode" : postcode,"phone":phone, "profileImage" : ""]
                userReference.updateChildValues(values, withCompletionBlock: {(err,ref) in
                    if err != nil {
                        print(err)
                        return
                    }
                    else{
                        let alertController = UIAlertController(title: "Thank you for registering", message: "", preferredStyle: .alert)
                        let backToSignIn = UIAlertAction(title: "OK", style: .cancel, handler: { action in self.performSegue(withIdentifier: "backToSignIn", sender: self)})
                        alertController.addAction(backToSignIn)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
                
            }
            })
        
        }
    }
     
    //handle profile image picker
    func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true,completion: nil)
    }
    
    //texfield only allowed integer
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    //checking for length of the textfield
    func maxLength(textFieldName:UITextField, max2:Int){
        var length = textFieldName.text?.characters.count
        let text = textFieldName.text
        if(length! > max2)
        {
            let index = text?.index((text?.startIndex)!, offsetBy: max2)
            textFieldName.text = textFieldName.text?.substring(to: index!)
        }
        
    }
    
}

//extension for registerviewcontroller for picking a media
extension RegisterViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info:[String:Any]){
        print("did finish picking photos")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        else{
            print("something is not right")
        }
        print(info)
        self.dismiss(animated: true, completion: nil)
    }
}
