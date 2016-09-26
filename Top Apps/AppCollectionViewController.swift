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
    
    var indexPathRow = 0
    
    var categoryNumber = ""
    var urlArray = [String]()
    var nameArray = [String]()
    var categoryArray = [String]()
    var summaryArray = [String]()
    var artistArray = [String]()
    var rightArray = [String]()
    var releaseDateArray = [String]()
    var cache =  NSCache<AnyObject, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()

   
        
        self.title = "Top Apps"
        
        getTopApps(category: categoryNumber)
        
        // Creating Custon Bar Button to perform custom segues
        
        self.navigationItem.hidesBackButton = true
        
        let leftBarButton = UIBarButtonItem(title: "< Categories", style: .done, target: self, action: #selector(AppCollectionViewController.performSegueFromApps))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: ReachabilityChangedNotification, object: reachability)
    }
    
    func performSegueFromApps () {
        
        performSegue(withIdentifier: "idFirstSegueUnwind", sender: self)
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
                        
                        
                        // Extracting the result from the json 
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
                                    
                                    if let title = app["summary"] as? NSDictionary {
                                        
                                        if let name = title["label"] as? String {
                                            
                                            self.summaryArray.append(name)
                                        }
                                        
                                    }
                                    
                                    if let title = app["im:artist"] as? NSDictionary {
                                        
                                        if let name = title["label"] as? String {
                                            
                                            self.artistArray.append(name)
                                        }
                                        
                                    }
                                    
                                    if let title = app["rights"] as? NSDictionary {
                                        
                                        if let name = title["label"] as? String {
                                            
                                            self.rightArray.append(name)
                                        }
                                        
                                    }
                                    
                                    if let category = app["im:releaseDate"] as? NSDictionary, let attributes = category["attributes"] as? NSDictionary, let label = attributes["label"] as? String {
                                        
                                        self.releaseDateArray.append(label)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //indexPathRow = indexPath.row
        
        //print(indexPath.row)
        
    }
    
    // action for unwind custom segue

    @IBAction func unwindFromDetail (_ sender: UIStoryboardSegue) {
        
        
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "appToDetails" {
        
            let indexPath = collectionView?.indexPath(for: sender as! UICollectionViewCell)


            print(indexPath?.row)
            
            let detailVC = segue.destination as! DetailViewController
            
            detailVC.appName = nameArray[(indexPath?.row)!]
            detailVC.rights = rightArray[(indexPath?.row)!]
            detailVC.artist = artistArray[(indexPath?.row)!]
            detailVC.category = categoryArray[(indexPath?.row)!]
            detailVC.summary = summaryArray[(indexPath?.row)!]
            detailVC.image = cache.object(forKey: (indexPath?.row)! as AnyObject)
            detailVC.date = releaseDateArray[(indexPath?.row)!]
            
        }
 
    }
    

}
