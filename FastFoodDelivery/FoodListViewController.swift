//
//  ViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 2/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import Firebase


class FoodListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    var foodlist = [Foods]()
    var ref: FIRDatabaseReference?
    var foodImage : UIImage!
    var foodImages : UIImage!
    var foodName = [String]()
    var filteredFood = [Foods]()
    var isSearching = false
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuBtn: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sidemenus()
        fetchFoodList()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        let scoresRef = FIRDatabase.database().reference(withPath: "foodlist")
        scoresRef.keepSynced(true)
    }
    
    //fetching food list from the firebase
    func fetchFoodList(){

        let dbRef = FIRDatabase.database().reference()
        //observing the added value from the firebase database
        dbRef.child("foodlist").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let food = Foods()
                food.setValuesForKeys(dictionary)
                food.name = dictionary["name"] as! String?

                self.foodlist.append(food)
                self.tableView.reloadData()

            }

        },withCancel:nil)
    }
    
    //side menu controller
    public func sidemenus(){
        if revealViewController() != nil{
            menuBtn.target = revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of row for searching
        if isSearching{
            return filteredFood.count
        }
            
        //return all row if not searching
        else{
            return foodlist.count;
        }
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodListTableViewCell
        
            //if user enters the value in the searchbar loads data with filtered food
            if isSearching{
                if filteredFood.count == 0{
                    print("no data found")
                }
                else{
                let foods = filteredFood[indexPath.row]
                cell.foodName.text = foods.name
                cell.foodPrice.text = String(foods.price)
                cell.imageCell?.image = UIImage(named:"")
                    if let img = foods.img{
                        cell.imageCell.loadImageUsingCacheWithUrlString(urlString: img)
                    }
                }
            }
                
            //load table view with all foodlist
            else{
                let foods = foodlist[indexPath.row]
                cell.foodName.text = foods.name
                cell.foodPrice.text = String(foods.price)
                cell.imageCell?.image = UIImage(named:"")
                if let img = foods.img{
                cell.imageCell.loadImageUsingCacheWithUrlString(urlString: img)
                }
            }
        return cell
        }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //if search text is empty fetch all food
        if searchText == nil || searchText == ""{
            self.foodlist = [Foods]()
            fetchFoodList()
            isSearching = false
        }
            
        //fetching the filtered food list
        else{
            filteredFood = [Foods]()
            for i in 0...(foodlist.count-1){
                let flist = foodlist[i]
                if flist.name.lowercased().contains(searchText.lowercased()){
                    
                    //put the selected foodlist into the filteredFood array
                    filteredFood.append(flist)
                    print(foodlist)
                }
            }
                //set the searching bool into true
                isSearching = true
                self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "foodDetailsSegue" {
            if let indexpath = tableView.indexPathForSelectedRow{
                let destVC = segue.destination as! FoodDetailsViewController
                if isSearching {
                    print(filteredFood)
                    let foods = filteredFood[indexpath.row]
                    destVC.foodLabel = foods.name
                    destVC.priceLabel = String(foods.price)
                    destVC.desc = foods.desc
                    print("this is \(foodImage)")
                    destVC.im = foods.img
                }
                else{
                let foods = foodlist[indexpath.row]
                    destVC.foodLabel = foods.name
                    destVC.priceLabel = String(foods.price)
                    destVC.desc = foods.desc
                    print("this is \(foodImage)")
                    destVC.im = foods.img
                }
            }
        }
    }


}

