//
//  AppsTableViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AMScrollingNavbar


class AppsTableViewController: UITableViewController {

    //MARK: - Variables
    var categoryNumber = ""
    var urlArray = [String]()
    var nameArray = [String]()
    var categoryArray = [String]()
    var summaryArray = [String]()
    var artistArray = [String]()
    var rightArray = [String]()
    var releaseDateArray = [String]()
    var cache =  NSCache<AnyObject, UIImage>()
    
    var appTitle = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Apps"
        getTopApps(category: categoryNumber)
        
        // Creating Custon Bar Button to perform custom segues
        
        self.navigationItem.hidesBackButton = true
    
        let leftBarButton = UIBarButtonItem(title: "< Categories", style: .done, target: self, action: #selector(AppsTableViewController.performSegueFromApps))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let imageView = UIImageView(image: UIImage(named: "background_1.jpg"))
        imageView.alpha = 0.5
        
        imageView.contentMode = .scaleAspectFill
         tableView.backgroundView = imageView
        
        setTitleLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppsTableViewController.reachabilityChanged(note:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        
        NotificationCenter.default.post(name: ReachabilityChangedNotification, object: reachability)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
    }
    
    func setTitleLabel () {
        
        titleLabel.text = self.appTitle
        titleLabel.layer.cornerRadius = 7
        titleLabel.layer.borderWidth = 2
        titleLabel.layer.borderColor = UIColor.white.cgColor
        titleLabel.clipsToBounds = true
    }

    
    func performSegueFromApps () {
        
        performSegue(withIdentifier: "idFirstSegueUnwind", sender: self)
    }
    
    // MARK: - Reachability for internet connection
    
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
    
    func getTopApps (category: String) {
        
        cache.removeAllObjects()
        
        var string = ""
    
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
    
                
                for item in json["feed"]["entry"].arrayValue {
                    
                    print(item["im:name"]["label"].stringValue)
                    self.nameArray.append(item["im:name"]["label"].stringValue)
                    self.summaryArray.append(item["summary"]["label"].stringValue)
                    self.artistArray.append(item["im:artist"]["label"].stringValue)
                    self.rightArray.append(item["rights"]["label"].stringValue)
                    self.releaseDateArray.append(item["im:releaseDate"]["attributes"]["label"].stringValue)
                    self.categoryArray.append(item["category"]["attributes"]["label"].stringValue)
                    self.urlArray.append(item["im:image"][1]["label"].stringValue)
                }
                DispatchQueue.main.async() { () -> Void in
                    
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return urlArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppsTableViewCell

        // Configure the cell...
        
        
        cell.appName.text = nameArray[indexPath.section]
        
        cell.categoryLabel.text = categoryArray[indexPath.section]
        
        cell.rankLabel.text = "\(indexPath.section + 1)"
        
        
        if let image = cache.object(forKey: indexPath.section as AnyObject) {
            
            cell.appImageView.image = image
            
        } else {
            
            
            let url = URL(string: urlArray[indexPath.section])!
            
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    if let data = data {
                        
                        if let image = UIImage(data: data) {
                            
                            self.cache.setObject(image, forKey: indexPath.section as AnyObject)
                          
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
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        
        cell.layer.transform = transform
        
        UIView.animate(withDuration: 1) { 
            cell.alpha = 1
             cell.layer.transform = CATransform3DIdentity
            
        }
    }
    
    @IBAction func unwindFromDetail (_ sender: UIStoryboardSegue) {
        
        
    }
    
    // Helper method for creating alerts
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "appToDetails" {
            
            let indexPath: IndexPath = tableView.indexPathForSelectedRow!
            
            let detailVC = segue.destination as! ViewController
            
            detailVC.appName = nameArray[indexPath.section]
            detailVC.rights = rightArray[indexPath.section]
            detailVC.artist = artistArray[indexPath.section]
            detailVC.category = categoryArray[indexPath.section]
            detailVC.summary = summaryArray[indexPath.section]
            detailVC.image = cache.object(forKey: indexPath.section as AnyObject)
            detailVC.date = releaseDateArray[indexPath.section]
            
        }
    }
    

}
