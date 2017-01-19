//
//  CategoryTableViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit




class CategoryTableViewController: UITableViewController {
    
    // Creacion de las categorias del App Store
    
    let categoryArray = ["Books", "Business" , "Catalogues", "Education", "Entertainment" , "Finance", "Food & Drink", "Games", "Health & Fitness", "Lifestyle", "Magazines & Newspapers", "Medical", "Music", "Navigation", "News", "Photo & Video", "Productivity", "Reference", "Shopping", "Social Networking", "Sports", "Travel", "Utilities", "Weather" ]
    
    // Creacion de los numero correspondientes a las categorias
    let genreArray = ["6018", "6000", "6022", "6017", "6016", "6015", "6023", "6014", "6013", "6012", "6020", "6011", "6010", "6009", "6021" , "6008", "6007", "6006","6024", "6005", "6004", "6003", "6002", "6001"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CategoryTableViewController.reachabilityChanged(note:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        NotificationCenter.default.post(name: ReachabilityChangedNotification, object: reachability)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
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
            appVC.appTitle = categoryArray[indexPath.row]
        }
        
    }
    
    @IBAction func unwindFromAppController (_ sender: UIStoryboardSegue) {
        
        
    }
    
    // Reachability for internet connection
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            
            
            //application.createAlert(title: "Oops!", message: "You don't have Internet connection!")
            
            print("No Connection")
            createAlert(title: "Opps!", message: "You don't have Internet connection!")
        }
    }
    
    // Helper method for creating alerts
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    

}
