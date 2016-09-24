//
//  AppCollectionViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AppCollectionViewController: UICollectionViewController {
    
    var categoryNumber = ""
    var urlArray = [String]()
    var nameArray = [String]()
    var categoryArray = [String]()
    var priceArray = [String]()
    var cache =  NSCache<AnyObject, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
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
                        
                        self.collectionView?.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return urlArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AppCollectionViewCell
    
        // Configure the cell
        
        cell.appNameLabel.text = nameArray[indexPath.row]
        
        cell.categoryLabel.text = categoryArray[indexPath.row]
        
        // Circular ImageView
        cell.appImageView.layer.cornerRadius = 15
        
        cell.appImageView.layer.borderWidth = 1
        cell.appImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.appImageView.clipsToBounds = true
        
        
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
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
