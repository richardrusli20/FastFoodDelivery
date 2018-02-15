//
//  CheckoutViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 7/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CheckoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var checkOutView: UIView!
    @IBOutlet var priceTotalLbl: UILabel!
    @IBOutlet var notesTxtInput: UITextField!
    @IBOutlet var clearBtn: UIBarButtonItem!
    
    var checkoutList : [NSManagedObject] = []
    var managedObjectContext:NSManagedObjectContext!
    var emptyFloats: Array<String> = Array()
    var totalPrice : Double = 0
    
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    @IBAction func clearBtn(_ sender: UIBarButtonItem) {
        DatabaseController.deleteContext()
        getData()
        getTotal()
        hideView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        getTotal()
        hideView()
        print("this is test only \(checkoutList.count)")
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
            cell.plusBtn.addTarget(self, action: #selector(CheckoutViewController.plusAction), for: .touchUpInside)
            priceTotalLbl.text = String(totalPrice)
        
            return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // Delete the row from the data source
            context.delete(checkoutList[indexPath.row])
            checkoutList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do{
                try context.save()
                getData()
                getTotal()
                priceTotalLbl.text = String(totalPrice)
                hideView()
            }
            catch let error{
                print("Could not save: \(error)")
            }
        }
    }
    
    func plusAction(){
        
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
    
    
    //get total price and shows it to the label
    func getTotal(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CheckoutData")
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count == 0 {
                print("no data found")
                totalPrice = 0
            }
            else{
                totalPrice = 0
                for result in results{
//                    totalPrice = 0
                    let price = result.value(forKey: "price") as! Double
//                    let qty = result.value(forKey: "qty") as! Int32
                    totalPrice = totalPrice + price
                    print(price)
                }
                 
            }
        }
        catch{
            
        }
    }
    
    
    //hiding the no food view
    func hideView(){
        //if list is empty show view
        if checkoutList.count == 0 {
            checkOutView.isHidden = false
            clearBtn.isEnabled = false
        }
            
        //if list is not empty hide view
        else{
            checkOutView.isHidden = true
            clearBtn.isEnabled = true
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentSegue" {
            let destVC = segue.destination as! paymentViewController
                print(totalPrice)
                destVC.priceTotal = totalPrice + 5
                destVC.noteTxt = notesTxtInput.text
        }
    }

    

}
