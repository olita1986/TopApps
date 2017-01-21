//
//  AppCollectionViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import ReachabilitySwift
import SwiftyJSON
import Alamofire
import Cache
import NVActivityIndicatorView


private let reuseIdentifier = "Cell"

class AppCollectionViewController: UICollectionViewController {
    
    
    //MARK: - Variables
    var indexPathRow = 0
    var categoryNumber = ""
    var appTitle = ""
    var urlArray = [String]()
    var nameArray = [String]()
    var categoryArray = [String]()
    var summaryArray = [String]()
    var artistArray = [String]()
    var rightArray = [String]()
    var releaseDateArray = [String]()
    var cache =  NSCache<AnyObject, UIImage>()
    
    let hybridCache = HybridCache(name: "Mix")
    
    var activityIndicator: NVActivityIndicatorView?
    var activityIndicator2: NVActivityIndicatorView?
 
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        
        self.title = "Top Apps"
        
        getTopApps(category: categoryNumber)
        
        // Creating Custon Bar Button to perform custom segues
        
        self.navigationItem.hidesBackButton = true
        
        let leftBarButton = UIBarButtonItem(title: "< Categories", style: .done, target: self, action: #selector(AppCollectionViewController.performSegueFromApps))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        setLayOut()
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppCollectionViewController.reachabilityChanged(note:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        
        NotificationCenter.default.post(name: ReachabilityChangedNotification, object: reachability)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.navigationBar.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.navigationBar.isHidden = true
        
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        let transform = CATransform3DTranslate(CATransform3DIdentity, 20, 250, 0)
        
        cell.layer.transform = transform
        
        UIView.animate(withDuration: 1) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! AppCollectionReusableView
            
            headerView.titleLabel.text = self.appTitle
            self.activityIndicator =  headerView.activityIndicator
            self.activityIndicator2 = headerView.activityIndicator2
            
            return headerView
            
        default:
            fatalError("Unexpected element kind")
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AppCollectionViewCell
    
        // Configure the cell
        
        cell.appNameLabel.text = nameArray[indexPath.row]
        
        cell.categoryLabel.text = categoryArray[indexPath.row]
    
        cell.numerLabel.text = String(indexPath.row + 1)
        
        if let image = cache.object(forKey: self.categoryNumber + "\(indexPath.row)" as AnyObject) {
            
            cell.appImageView.image = image
            
        
            
        } else {
            
            
            let url = URL(string: urlArray[indexPath.row])!
            
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    
                    print(error as Any)
                    
                } else {
                    
                    if let data = data {
                        
                        if let image = UIImage(data: data) {
                            
                            self.cache.setObject(image, forKey: self.categoryNumber + "\(indexPath.row)" as AnyObject)
                            
                            DispatchQueue.main.async() { () -> Void in
                                
                                cell.appImageView.image = image
                        
                            }
                        }
                    }
                }
            }
            
            task.resume()
            
        }
        
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor

        
        return cell
    }
    
    // MARK: - CollectionView Layout
    func setLayOut () {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left:50, bottom: 10, right: 50)
        layout.itemSize = CGSize(width: 263, height: 157)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 156)
        
        collectionView!.collectionViewLayout = layout
    }
    


    // action for unwind custom segue

    @IBAction func unwindFromDetail (_ sender: UIStoryboardSegue) {
        
        
    }
    
    // MARK: - Helper methods
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
            
            self.perform(#selector(AppCollectionViewController.alert), with: nil, afterDelay: 1)
            
        }
    }
    
    func alert() {
        
        createAlert(title: "Opps!", message: "You don't have Internet connection!")
        
    }
    
    
    // API Request
    
    func getTopApps (category: String) {
        
        
        
        hybridCache.object(category) { (json: JSON2?) in
            
            if json != nil {
                
                let json1 = JSON(json?.object ?? "hola")
                
                for item in json1.arrayValue {
                    
                    self.nameArray.append(item["im:name"]["label"].stringValue)
                    self.summaryArray.append(item["summary"]["label"].stringValue)
                    self.artistArray.append(item["im:artist"]["label"].stringValue)
                    self.rightArray.append(item["rights"]["label"].stringValue)
                    self.releaseDateArray.append(item["im:releaseDate"]["attributes"]["label"].stringValue)
                    self.categoryArray.append(item["category"]["attributes"]["label"].stringValue)
                    self.urlArray.append(item["im:image"][1]["label"].stringValue)
                }
                
                DispatchQueue.main.async() { () -> Void in
                    
                    self.collectionView?.reloadData()
                }
            } else {
                
                
                var string = ""
                
                self.activityIndicator?.type = .audioEqualizer
                self.activityIndicator2?.type = .audioEqualizer
                
                self.activityIndicator?.startAnimating()
                self.activityIndicator2?.startAnimating()
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    
                    string = "topfreeipadapplications"
                    
                } else {
                    
                    string = "topfreeapplications"
                }
                
                let url = URL(string:  "https://itunes.apple.com/us/rss/" + string + "/limit=25/genre=" + category + "/json")
                
                Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).validate().responseJSON { (response) in
                    
                    switch response.result {
                        
                    case .success:
                        
                        let json = JSON(response.result.value as Any)
                        
                        self.hybridCache.add(category, object: JSON2.array(json["feed"]["entry"].arrayObject!))
                        
                        
                        for item in json["feed"]["entry"].arrayValue {
                            
                            self.nameArray.append(item["im:name"]["label"].stringValue)
                            self.summaryArray.append(item["summary"]["label"].stringValue)
                            self.artistArray.append(item["im:artist"]["label"].stringValue)
                            self.rightArray.append(item["rights"]["label"].stringValue)
                            self.releaseDateArray.append(item["im:releaseDate"]["attributes"]["label"].stringValue)
                            self.categoryArray.append(item["category"]["attributes"]["label"].stringValue)
                            self.urlArray.append(item["im:image"][1]["label"].stringValue)
                        }
                        DispatchQueue.main.async() { () -> Void in
                            
                            self.collectionView?.reloadData()
                            self.activityIndicator?.stopAnimating()
                            self.activityIndicator2?.stopAnimating()
                            
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            }
            
        }
        
    }


    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "appToDetails" {
        
            let indexPath = collectionView?.indexPath(for: sender as! UICollectionViewCell)

            
            let detailVC = segue.destination as! ViewController
            
            detailVC.appName = nameArray[(indexPath?.row)!]
            detailVC.rights = rightArray[(indexPath?.row)!]
            detailVC.artist = artistArray[(indexPath?.row)!]
            detailVC.category = categoryArray[(indexPath?.row)!]
            detailVC.summary = summaryArray[(indexPath?.row)!]
            detailVC.image = cache.object(forKey: self.categoryNumber + "\(indexPath?.row)" as AnyObject)
            detailVC.date = releaseDateArray[(indexPath?.row)!]
            
        }
 
    }
    
    func performSegueFromApps () {
        
        performSegue(withIdentifier: "idFirstSegueUnwind", sender: self)
    }
    

}
