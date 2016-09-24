//
//  AppsTableViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class AppsTableViewController: UITableViewController {

    var categoryNumber = ""
    var urlArray = [String]()
    var nameArray = [String]()
    var categoryArray = [String]()
    var priceArray = [String]()
    var cache =  NSCache<AnyObject, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Apps"
        getTopApps(category: categoryNumber)
    }
    
    func getTopApps (category: String) {
        
        cache.removeAllObjects()
        
        var string = ""
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            string = "topfreeipadapplications"
            
        } else {
            
            string = "topfreeapplications"
        }
        
        let url = URL(string:  "https://itunes.apple.com/us/rss/" + string + "/limit=25/genre=" + category + "/json")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            if error != nil {
                
                print(error)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        
                        // Extracting the result count
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        if let feed = jsonResult["feed"] as? NSDictionary, let entry = feed["entry"] as? NSArray {
                            
                            for app in entry  {
                                
                                if let app = app as? NSDictionary {
                                    
                                    if let title = app["im:name"] as? NSDictionary {
                                        
                                        if let name = title["label"] as? String {
                                            
                                            self.nameArray.append(name)
                                        }
                                        
                                    }
                                    
                                    if let category = app["category"] as? NSDictionary, let attributes = category["attributes"] as? NSDictionary, let label = attributes["label"] as? String {
                                        
                                        self.categoryArray.append(label)
                                    }
                                    
                                   
                                    if let image = app["im:image"] as? NSArray {
                                        
                                        if let content = image[1] as? NSDictionary {
                                            
                                            if let imageURL = content["label"] as? String {
                                                
                                                self.urlArray.append(imageURL)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                    } catch {
                        
                        
                        
                    }
                    
                    DispatchQueue.main.async() { () -> Void in
                        
                        self.tableView.reloadData()
                    }

                }
            }
  
        }
        task.resume()

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
        return urlArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppsTableViewCell

        // Configure the cell...
        
        
        cell.appName.text = nameArray[indexPath.row]
        
        cell.categoryLabel.text = categoryArray[indexPath.row]
        
        cell.rankLabel.text = "\(indexPath.row + 1)"
        
        
        if let image = cache.object(forKey: indexPath.row as AnyObject) {
            
            cell.appImageView.image = image
            
        } else {
            
            
            let url = URL(string: urlArray[indexPath.row])!
            
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    if let data = data {
                        
                        if let image = UIImage(data: data) {
                            
                            self.cache.setObject(image, forKey: indexPath.row as AnyObject)
                          
                                DispatchQueue.main.async() { () -> Void in
                                    
                                   cell.appImageView.image = image
                                }
                        }
                    }
                }
            }
            
            task.resume()

        }

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
