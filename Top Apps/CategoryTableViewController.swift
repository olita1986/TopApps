//
//  CategoryTableViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    let categoryArray = ["Books", "Business" , "Catalogues", "Education", "Entertainment" , "Finance", "Food & Drink", "Games", "Health & Fitness", "Lifestyle", "Magazines & Newspapers", "Medical", "Music", "Navigation", "News", "Photo & Video", "Productivity", "Reference", "Shopping", "Social Networking", "Sports", "Travel", "Utilities", "Weather" ]
    
    let genreArray = ["6018", "6000", "6022", "6017", "6016", "6015", "6023", "6014", "6013", "6012", "6020", "6011", "6010", "6009", "6021" , "6008", "6007", "6006","6024", "6005", "6004", "6003", "6002", "6001"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = categoryArray[indexPath.row]

        return cell
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            let indexPath: IndexPath = tableView.indexPathForSelectedRow!
            
            let appVC = segue.destination as! AppCollectionViewController
            
            appVC.categoryNumber = genreArray[indexPath.row]
            
        } else {
            
            let indexPath: IndexPath = tableView.indexPathForSelectedRow!
            
            let appVC = segue.destination as! AppsTableViewController
            
            appVC.categoryNumber = genreArray[indexPath.row]
        }
        
    }
    
    @IBAction func unwindFromAppController (_ sender: UIStoryboardSegue) {
        
        
    }
    
    

}
