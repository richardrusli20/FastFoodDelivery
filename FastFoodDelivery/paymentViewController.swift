//
//  paymentViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 23/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import Firebase
import CoreData
class paymentViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var notesLbl: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var noteLbl: UILabel!
    var noteTxt : String?
    var priceTotal : Double = 0
    var users = [Users]()
    var listOfFood = [Foods]()
    var checkoutList : [NSManagedObject] = []
    var foodArray = [String:Any]()
    var userName :String?
    var phone : String?
    var postCode : String?
    var managedObjectContext:NSManagedObjectContext!
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        priceLabel.text = String(priceTotal)
        getUsers()
        getData()
        noteLbl.text = noteTxt

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToMenu(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let deliverVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(deliverVC, animated: true, completion: nil)
    }



    
    @IBAction func placeOrder(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let deliverVC = storyboard.instantiateViewController(withIdentifier: "DeliveryViewController") as! DeliveryViewController
        let myAlert = UIAlertController(title: "Do you wish to proceed?", message: "", preferredStyle:UIAlertControllerStyle.alert )
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(ACTION) in
                self.sendFood()
            
                self.present(deliverVC, animated: true, completion: nil)
            }))
        myAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel))
        self.present(myAlert, animated:true, completion:nil)
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkoutList.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutTableViewCell
        
        let s:CheckoutData = self.checkoutList[indexPath.row] as! CheckoutData
        cell.foodNameLbl.text = s.name
        cell.foodPriceLbl.text = String(s.price)
        cell.foodQtyLbl.text = String(s.qty)

        
        return cell
    }
    
    // sending food to firebase database
    func sendFood(){
//        .chilbyAutoID()
        let userID = FIRAuth.auth()?.currentUser?.uid
        let dbRef = FIRDatabase.database().reference().child("orders")
        let hist = FIRDatabase.database().reference().child("history").child(userID!)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CheckoutData")
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            for result in results{
                let name = result.value(forKey: "name") as! String
                let price = result.value(forKey: "price") as! Double
                let qty = result.value(forKey: "qty") as! Int32

//                foodArray.append(foodSent)
                
                foodArray["name"] = name as AnyObject
                foodArray["qty"] = qty as AnyObject
                foodArray["price"] = price as AnyObject
                print("debug")
                print(foodArray)
                dbRef.childByAutoId().setValue(foodArray)
                hist.childByAutoId().setValue(foodArray)
                
            }
        }
        catch{
            
        }
        dbRef.child("user").child("username").setValue(userName)
        dbRef.child("user").child("userPhone").setValue(phone)
        dbRef.child("user").child("userAddress").setValue(addressLbl.text)
        dbRef.child("user").child("userpostcode").setValue(postCode)
        dbRef.child("user").child("Notes").setValue(noteLbl.text)
        DatabaseController.deleteContext()
    }
    
    //get users data and present it
    func getUsers(){
        let userID = FIRAuth.auth()?.currentUser?.uid
        print("testing\(userID!)")
        let dbRef = FIRDatabase.database().reference()
        dbRef.child("users").child(userID!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let user = Users()
                user.setValuesForKeys(dictionary)
                user.name = dictionary["name"] as! String?
                self.users.append(user)
                
                //            if let users = self.users{
                let u = self.users[0]
                self.addressLbl.text = u.location! + ", " + u.postcode!
                self.userName = u.name
                self.postCode = u.postcode
                self.phone = u.Phone
                print(u.name!, u.location!)
            }
        },withCancel:nil)
    }
    
    //    fetching data from database
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            checkoutList = try context.fetch(CheckoutData.fetchRequest())
            print(checkoutList)
        }
        catch{
            print("Fetching Failed")
        }
    }

}
