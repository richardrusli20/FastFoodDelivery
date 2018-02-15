//
//  FoodDetailsViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 7/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class FoodDetailsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet var qtyTextInput: UITextField!
    @IBOutlet var foodLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var imageDetail: UIImageView!
    @IBOutlet var descLbl: UILabel!
    
    var foodLabel:String! = " label"
    var priceLabel:String! = "label"
    var managedObjectContext : NSManagedObjectContext
    var cart : [NSManagedObject] = []
    var pickerNumb = [String]()
    var desc:String! = ""
    var im :String?
    let picker = UIPickerView()
    var food : Foods?
//    var list : NSManagedObject? = nil
    
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...100{
            let numb = String(i)
            pickerNumb.append(numb)
        }
        
        picker.delegate = self
        picker.dataSource = self
        qtyTextInput.inputView = picker
        
        foodLbl.text = foodLabel!
        priceLbl.text = priceLabel!
        descLbl.text = desc
        
        //using the extension to load the view data and cache it
        imageDetail.loadImageUsingCacheWithUrlString(urlString: im!)

    }

    @IBAction func addToCart(_ sender: Any) {
        addFood()
        print("adding cart \(foodLbl.text!)")
        //initialize the monster variable as monster data
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    save record
    func saveRecords()
    {
        do{
            try self.managedObjectContext.save()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CheckoutData")
            do{
                self.cart = try self.managedObjectContext.fetch(fetchRequest)
            }
            catch{
                let fetchError = error as NSError
                print(fetchError)
            }
        }
        catch let error{
            print("Could not save: \(error)")
        }
    }
    

    
    func addFood(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CheckoutData")
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count == 0 {
                let data = NSEntityDescription.insertNewObject(forEntityName: "CheckoutData", into: managedObjectContext) as? CheckoutData
                data!.setValue(foodLabel, forKey: "name")
                data!.setValue(Float(priceLbl.text!)! * Float(qtyTextInput.text!)!, forKey: "price")
                data!.setValue(Int32(qtyTextInput.text!), forKey: "qty")
                saveRecords()
            }
            else{
                //checking if there is a same type of data in the coredata
                var check : Bool = false
                for result in results
                {
                    if let foodname = result.value(forKey: "name") as? String
                    {
                        let qty = result.value(forKey: "qty") as? Float
                        let totalQty = Float(qtyTextInput.text!)! + qty!
                        print("foodname = " + foodname)
                        print("foodLabel = " + foodLabel)
                        if foodname == foodLabel{
                            result.setValue(self.foodLabel, forKey: "name")
                            result.setValue(Float(priceLbl.text!)!*totalQty, forKey: "price")
                            result.setValue(totalQty, forKey: "qty")
                            
                            //found set of data check equals true
                            return check = true
                        }
                    }
                }
                //data has not been found check equals false
                if (check == false){
                    let data = NSEntityDescription.insertNewObject(forEntityName: "CheckoutData", into: managedObjectContext) as? CheckoutData
                    data!.setValue(foodLabel, forKey: "name")
                    data!.setValue(Float(priceLbl.text!)!*Float(qtyTextInput.text!)!, forKey: "price")
                    data!.setValue(Int32(qtyTextInput.text!), forKey: "qty")
                    saveRecords()
                }
            }
        }
        catch
        {
                let fetchError = error as NSError
                print(fetchError)
        }
    }
    
    //picker functions
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerNumb.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerNumb[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        qtyTextInput.text = pickerNumb[row]
        self.view.endEditing(false)
    }



}




