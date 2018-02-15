//
//  MenuTableViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 3/05/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import Firebase

class MenuTableViewController: UITableViewController {
    var menuItems = [String]()
    var currentItem = ["Menu","Contact US", "About US","Profile","Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItems  = ["Menu","Contact US", "About US","Profile","Logout"]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuItems[indexPath.row], for: indexPath) as! MenuTableViewCell
        
        // Configure the cell...
        cell.titleLabel.text = menuItems[indexPath.row]
        cell.titleLabel.textColor = (menuItems[indexPath.row] == currentItem[indexPath.row]) ? UIColor.black : UIColor.white
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you selected \(indexPath.row)")

        
        if indexPath.row == 3{
            handleProfile()
        }
        if indexPath.row == 4{
            handleLogout()
        }

    }
    
    func handleLogout(){
        do{
            //signout the authenticated user
            try FIRAuth.auth()?.signOut()
        }
        catch let logoutError{
            print(logoutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        //present it back to login controller
        self.present(loginController, animated: true, completion: nil)
    }
    
    //handle selected 
    func handleProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        //        let loginController = LoginViewController()
        self.present(profileController, animated: true, completion: nil)
    }
}
